param location string = resourceGroup().location

var logicAppName = 'logic-nrg-sentinel-response-dev-eus-001'
var connectionName = 'conn-nrg-sentinel-response-dev-eus-001'
var sentinelManagedApiId = subscriptionResourceId(
  'Microsoft.Web/locations/managedApis',
  location,
  'azuresentinel'
)

resource sentinelConnection 'Microsoft.Web/connections@2016-06-01' = {
  name: connectionName
  location: location
  #disable-next-line BCP187
  kind: 'V1'
  properties: {
    displayName: connectionName
    customParameterValues: {}
    #disable-next-line BCP037
    parameterValueType: 'Alternative'
    api: {
      id: sentinelManagedApiId
    }
  }
}

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  tags: {
    Environment: 'Development'
    Project: 'Sentinel-Detection-Response'
    Organization: 'Northstar-Retail-Group'
    ManagedBy: 'Bicep'
    LogicAppsCategory: 'security'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {}
          type: 'Object'
        }
      }
      triggers: {
        When_Azure_Sentinel_incident_creation_rule_was_triggered: {
          type: 'ApiConnectionWebhook'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuresentinel\'][\'connectionId\']'
              }
            }
            body: {
              callback_url: '@{listCallbackUrl()}'
            }
            path: '/incident-creation'
          }
        }
      }
      actions: {
        Add_automated_response_comment: {
          type: 'ApiConnection'
          runAfter: {}
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'azuresentinel\'][\'connectionId\']'
              }
            }
            method: 'post'
            body: {
              incidentArmId: '@triggerBody()?[\'object\']?[\'id\']'
              message: '<p>Northstar automated response playbook executed successfully. Incident received by Microsoft Sentinel automation and processed by the managed-identity Logic App.</p>'
            }
            path: '/Incidents/Comment'
          }
        }
      }
    }
    parameters: {
      '$connections': {
        value: {
          azuresentinel: {
            connectionId: sentinelConnection.id
            connectionName: sentinelConnection.name
            id: sentinelManagedApiId
            connectionProperties: {
              authentication: {
                type: 'ManagedServiceIdentity'
              }
            }
          }
        }
      }
    }
  }
}

output logicAppName string = logicApp.name
output logicAppPrincipalId string = logicApp.identity.principalId
output sentinelConnectionName string = sentinelConnection.name


