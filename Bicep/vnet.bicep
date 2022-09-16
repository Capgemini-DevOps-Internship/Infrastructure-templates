@description('Virtual Network Name.')
param virtualNetworkName string = 'build-agents-vnet'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Subnet 1 Name.')
param subnet1Name string = 'agents-subnet'

@description('Subnet 2 Name.')
param subnet2Name string = 'jumpbox-subnet'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}
