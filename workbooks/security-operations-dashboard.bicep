param location string = resourceGroup().location

var workspaceName = 'law-nrg-sentinel-dev-eus-001'
var workbookDisplayName = 'Northstar Sentinel Security Operations Dashboard'
var workbookName = guid(resourceGroup().id, workbookDisplayName)

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: workspaceName
}

var workbookJson = replace(
  loadTextContent('security-operations-dashboard-content.json'),
  '__WORKSPACE_ID__',
  workspace.id
)

resource securityWorkbook 'Microsoft.Insights/workbooks@2023-06-01' = {
  name: workbookName
  location: location
  kind: 'shared'
  properties: {
    displayName: workbookDisplayName
    description: 'Microsoft Sentinel security operations dashboard for Northstar Retail Group Project 3.'
    category: 'sentinel'
    sourceId: workspace.id
    serializedData: workbookJson
    version: 'Notebook/1.0'
  }
  tags: {
    Environment: 'Development'
    Project: 'Sentinel-Detection-Response'
    Organization: 'Northstar-Retail-Group'
    ManagedBy: 'Bicep'
    'hidden-link:${workspace.id}': 'Resource'
  }
}

output workbookName string = securityWorkbook.name
output workbookDisplayName string = securityWorkbook.properties.displayName

