targetScope = 'resourceGroup'

param workspaceName string = 'law-nrg-sentinel-dev-eus-001'

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: workspaceName
}

resource rbacChangeAlertRule 'Microsoft.SecurityInsights/alertRules@2025-09-01' = {
  name: guid(resourceGroup().id, workspaceName, 'azure-rbac-role-assignment-change')
  scope: workspace
  kind: 'Scheduled'

  properties: {
    displayName: 'Azure RBAC Role Assignment Change Detected'
    description: 'Detects successful creation or deletion of Azure RBAC role assignments. Mapped to MITRE ATT&CK T1098.003 Additional Cloud Roles.'
    enabled: false
    severity: 'Medium'

    query: '''
AzureActivity
| where CategoryValue == 'Administrative'
| where OperationNameValue in~ (
    'MICROSOFT.AUTHORIZATION/ROLEASSIGNMENTS/WRITE',
    'MICROSOFT.AUTHORIZATION/ROLEASSIGNMENTS/DELETE'
)
| where ActivityStatusValue =~ 'Success'
| extend RBACAction = case(
    OperationNameValue endswith '/WRITE', 'Role Assignment Created or Updated',
    OperationNameValue endswith '/DELETE', 'Role Assignment Deleted',
    'Unknown'
)
| extend AccountName = iff(Caller contains '@', tostring(split(Caller, '@')[0]), tostring(Caller))
| extend AccountUPNSuffix = iff(Caller contains '@', tostring(split(Caller, '@')[1]), '')
| extend TargetResourceId = tostring(ResourceId)
| project
    TimeGenerated,
    RBACAction,
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
      RBACAction: 'RBACAction'
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

    tactics: [
      'Persistence'
      'PrivilegeEscalation'
    ]

    techniques: [
      'T1098'
    ]
  }
}

output alertRuleName string = rbacChangeAlertRule.name
output alertRuleDisplayName string = rbacChangeAlertRule.properties.displayName

















