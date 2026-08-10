var workspaceName = 'law-nrg-sentinel-dev-eus-001'
var automationRuleDisplayName = 'ar-nrg-sentinel-dev-001 - Medium Severity Incident Triage'
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
    order: 100
    triggeringLogic: {
      isEnabled: true
      triggersOn: 'Incidents'
      triggersWhen: 'Created'
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
      ]
    }
    actions: [
      {
        order: 1
        actionType: 'AddIncidentTask'
        actionConfiguration: {
          title: 'Perform automated-response validation'
          description: 'Review incident entities, validate the triggering security activity, and confirm the automated response workflow completed successfully.'
        }
      }
      {
        order: 2
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
