targetScope = 'resourceGroup'

@description('Primary Azure region for Project 3 resources.')
param location string = resourceGroup().location

@description('Log Analytics workspace name.')
param workspaceName string

@description('Deployment environment.')
param environment string = 'Development'

@description('Project name used for resource tagging.')
param project string = 'Sentinel-Detection-Response'

@description('Organization name used for resource tagging.')
param organization string = 'Northstar-Retail-Group'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: workspaceName
  location: location
  tags: {
    Environment: environment
    Project: project
    Organization: organization
    ManagedBy: 'Bicep'
  }
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

resource sentinelOnboarding 'Microsoft.SecurityInsights/onboardingStates@2025-09-01' = {
  name: 'default'
  scope: logAnalyticsWorkspace
  properties: {
    customerManagedKey: false
  }
}

output workspaceName string = logAnalyticsWorkspace.name
output workspaceResourceId string = logAnalyticsWorkspace.id
output workspaceLocation string = logAnalyticsWorkspace.location
output sentinelOnboardingName string = sentinelOnboarding.name
