targetScope = 'resourceGroup'

param workspaceName string = 'law-nrg-sentinel-dev-eus-001'

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: workspaceName
}

resource tagChangeAlertRule 'Microsoft.SecurityInsights/alertRules@2025-09-01' = {
  name: guid(resourceGroup().id, workspaceName, 'azure-resource-tag-change')
  scope: workspace
  kind: 'Scheduled'

  properties: {
    displayName: 'Azure Resource Tag Change Detected'
    description: 'Detects successful Azure resource tag write operations in the monitored subscription.'
    enabled: false
    severity: 'Low'

    query: '''
AzureActivity
| where CategoryValue == 'Administrative'
| where OperationNameValue =~ 'MICROSOFT.RESOURCES/TAGS/WRITE'
| where ActivityStatusValue =~ 'Success'
| extend AccountName = iff(Caller contains '@', tostring(split(Caller, '@')[0]), tostring(Caller))
| extend AccountUPNSuffix = iff(Caller contains '@', tostring(split(Caller, '@')[1]), '')
| extend TargetResourceId = strcat('/subscriptions/', SubscriptionId, '/resourceGroups/', ResourceGroup)
| project
    TimeGenerated,
    OperationNameValue,
    ActivityStatusValue,
    Caller,
    AccountName,
    AccountUPNSuffix,
    ResourceGroup,
    TargetResourceId
'''

    queryFrequency: 'PT5M'
    queryPeriod: 'PT30M'

    triggerOperator: 'GreaterThan'
    triggerThreshold: 0

    suppressionEnabled: false
    suppressionDuration: 'PT5H'

    eventGroupingSettings: {
      aggregationKind: 'SingleAlert'
    }

    entityMappings: [
      {
        entityType: 'Account'
        fieldMappings: [
          {
            identifier: 'Name'
            columnName: 'AccountName'
          }
          {
            identifier: 'UPNSuffix'
            columnName: 'AccountUPNSuffix'
          }
        ]
      }
      {
        entityType: 'AzureResource'
        fieldMappings: [
          {
            identifier: 'ResourceId'
            columnName: 'TargetResourceId'
          }
        ]
      }
    ]

    customDetails: {
      Operation: 'OperationNameValue'
      Status: 'ActivityStatusValue'
      ResourceGroup: 'ResourceGroup'
    }

    incidentConfiguration: {
      createIncident: true
      groupingConfiguration: {
        enabled: false
        reopenClosedIncident: false
        lookbackDuration: 'PT5H'
        matchingMethod: 'AllEntities'
        groupByEntities: []
        groupByAlertDetails: []
        groupByCustomDetails: []
      }
    }

    tactics: []
    techniques: []
  }
}

output alertRuleName string = tagChangeAlertRule.name
output alertRuleDisplayName string = tagChangeAlertRule.properties.displayName

