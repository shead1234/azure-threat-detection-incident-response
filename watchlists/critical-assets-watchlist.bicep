var workspaceName = 'law-nrg-sentinel-dev-eus-001'
var watchlistAlias = 'critical-assets'

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: workspaceName
}

resource criticalAssetsWatchlist 'Microsoft.SecurityInsights/watchlists@2025-09-01' = {
  name: watchlistAlias
  scope: workspace
  properties: {
    displayName: 'Northstar Critical Assets'
    description: 'Critical Azure resources monitored by Microsoft Sentinel for Project 3.'
    provider: 'Microsoft'
    source: 'critical-assets.csv'
    sourceType: 'Local'
    contentType: 'text/csv'
    itemsSearchKey: 'AssetName'
    rawContent: loadTextContent('../watchlists/critical-assets.csv')
    labels: [
      'Northstar'
      'Critical-Assets'
      'Project-3'
    ]
  }
}

output watchlistName string = criticalAssetsWatchlist.name
output watchlistDisplayName string = criticalAssetsWatchlist.properties.displayName
