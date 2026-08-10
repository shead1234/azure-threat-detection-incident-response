var workspaceName = 'law-nrg-sentinel-dev-eus-001'
var automationRuleDisplayName = 'ar-nrg-sentinel-alert-added-dev-001 - Medium Incident Alert Added Response'
var automationRuleName = guid(workspaceName, automationRuleDisplayName)
var logicAppName = 'logic-nrg-sentinel-response-dev-eus-001'

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: workspaceName
}

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' existing = {
  name: logicAppName
}

resource automationRule 'Microsoft.SecurityInsights/automationRules@2025-09-01' = {
  name: automationRuleName
  scope: workspace
  properties: {
    displayName: automationRuleDisplayName
    order: 110
    triggeringLogic: {
      isEnabled: true
      triggersOn: 'Incidents'
      triggersWhen: 'Updated'
      conditions: [
        {
          conditionType: 'Property'
          conditionProperties: {
            propertyName: 'IncidentSeverity'
            operator: 'Equals'
            propertyValues: [
              'Medium'
            ]
          }
        }
        {
          conditionType: 'PropertyArrayChanged'
          conditionProperties: {
            arrayType: 'Alerts'
            changeType: 'Added'
          }
        }
      ]
    }
    actions: [
      {
        order: 1
        actionType: 'RunPlaybook'
        actionConfiguration: {
          logicAppResourceId: logicApp.id
          tenantId: subscription().tenantId
        }
      }
    ]
  }
}

output automationRuleName string = automationRule.name
output automationRuleDisplayName string = automationRule.properties.displayName
