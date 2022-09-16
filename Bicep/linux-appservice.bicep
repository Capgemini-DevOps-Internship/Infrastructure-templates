@description('The name of the web app.')
param webAppName string = uniqueString('webApp', resourceGroup().id)

@description('Location for all resources.')
param location string = resourceGroup().location

@description('App Service Pricing Tier.')
param sku string = 'S1'

@description('Docker Hub image to be used.')
param linuxFxVersion string = 'DOCKER|herbertmoore/static-website-01:hello_world'

var appServicePlanName = '${webAppName}${uniqueString(resourceGroup().id)}'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }	
  sku:  {
  	name: sku
    tier: 'Standard'
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: webAppName
  location: location
  tags: {}
  properties: {
    siteConfig: {
      appSettings: []
      linuxFxVersion: linuxFxVersion
    }
    serverFarmId: appServicePlan.id
  }
}
