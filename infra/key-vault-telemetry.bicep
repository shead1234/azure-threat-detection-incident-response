param location string = resourceGroup().location

var keyVaultName = 'kv-nrg-sent-dev-eus-001'
var workspaceName = 'law-nrg-sentinel-dev-eus-001'
var diagnosticSettingName = 'ds-nrg-keyvault-sentinel'

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: workspaceName
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
  }
  tags: {
    Environment: 'Development'
    Project: 'Sentinel-Detection-Response'
    Organization: 'Northstar-Retail-Group'
    ManagedBy: 'Bicep'
  }
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: diagnosticSettingName
  scope: keyVault
  properties: {
    workspaceId: workspace.id
    logAnalyticsDestinationType: 'Dedicated'
    logs: [
      {
        category: 'AuditEvent'
        enabled: true
      }
    ]
  }
}

output keyVaultName string = keyVault.name
output diagnosticSettingName string = diagnosticSetting.name

