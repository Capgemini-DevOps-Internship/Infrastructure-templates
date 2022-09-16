@description('The location in which all resources should be deployed.')
param location string = resourceGroup().location

@description('The name of the app to create.')
param appName string = uniqueString('linuxWebApp', resourceGroup().id)

@description('Docker Hub image to be used.')
param linuxFxVersion string = 'DOCKER|herbertmoore/static-website-01:hello_world'

var appServicePlanName = '${appName}${uniqueString(resourceGroup().id)}'
var vnetName = '${appName}-vnet'
var vnetAddressPrefix = '10.0.0.0/16'
var subnet1Name = '${appName}-subnet'
var subnet2Name = 'appgateway-subnet'
var subnet1AddressPrefix = '10.0.0.0/24'
var subnet2AddressPrefix = '10.0.1.0/24'
var appServicePlanSku = 'S1'
var privateEndpoint_name = 'private-endpoint'
var privateLinkConnection_name = 'private-connection'
var privateDNSZone_name = 'privatelink.azurewebsites.net'
var webapp_dns_name = '.azurewebsites.net'

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
  }
}

resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: subnet1Name
  parent: vnet
  properties: {
    addressPrefix: subnet1AddressPrefix
    privateEndpointNetworkPolicies: 'Disabled'
  }
}

resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
  name: subnet2Name
  parent: vnet
  properties: {
    addressPrefix: subnet2AddressPrefix
    privateEndpointNetworkPolicies: 'Disabled'
  }
}

resource webApp 'Microsoft.Web/sites@2021-01-01' = {
  name: appName
  location: location
  dependsOn:[
    subnet1
  ]
  properties: {
    serverFarmId: appServicePlan.id
    enabled: true
    siteConfig: {
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      linuxFxVersion: linuxFxVersion
    }
    hostNameSslStates: [
      {
        name: '[concat(appName, webapp_dns_name)]'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: concat(appName, '.scm', webapp_dns_name)
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
  }
}

resource webAppConfig 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'web'
  parent: webApp
  properties: {
    ftpsState: 'AllAllowed'
  }
}

resource webAppHNB 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  name: concat(appName, webapp_dns_name)
  parent: webApp
  properties: {
    hostNameType: 'Verified'
    siteName: appName
  }
}

resource webAppPE 'Microsoft.Network/privateEndpoints@2022-01-01' = {
  name: privateEndpoint_name
  location: location
  dependsOn: [
    webApp
  ]
  properties:{
    subnet:{
      name: subnet1Name
      id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnet1Name)
    }
    privateLinkServiceConnections:[
      {
        name: privateLinkConnection_name
        properties:{
          privateLinkServiceId: resourceId('Microsoft.Web/sites', appName)
          groupIds:[
            'sites'
          ]
        }
      }
    ]
  }
}

resource webAppDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSZone_name
  location: 'global'
}

resource vnetlink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: concat(privateDNSZone_name, '-link')
  location: 'global'
  parent: webAppDNSZone
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    }
  }
}

resource dnszonegroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2022-01-01' = {
  name: concat('/dnsgroupname')
  parent: webAppPE
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'config1'
        properties: {
          privateDnsZoneId: resourceId('Microsoft.Network/privateDnsZones', privateDNSZone_name)
        }
      }
    ]
  }
}
