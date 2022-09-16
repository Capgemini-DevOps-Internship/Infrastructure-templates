@description('The location in which all resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the app to create.')
param appName string = uniqueString('linuxWebApp', resourceGroup().id)

@description('Docker Hub image to be used.')
param linuxFxVersion string = 'DOCKER|herbertmoore/static-website-01:hello_world'

var appServicePlanName = '${appName}${uniqueString(resourceGroup().id)}'
var vnetName = '${appName}-vnet'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetName = '${appName}-subnet'
var subnetAddressPrefix = '10.0.0.0/24'
var appServicePlanSku = 'S1'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku
    tier: 'Standard'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }	
}

resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
    ]
  }
}

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    virtualNetworkSubnetId: vnet.properties.subnets[0].id
    httpsOnly: true
    siteConfig: {
      vnetRouteAllEnabled: true
      http20Enabled: true
      linuxFxVersion: linuxFxVersion
    }
  }
}
