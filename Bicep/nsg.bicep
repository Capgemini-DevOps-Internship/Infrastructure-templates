@description('Location for all resources.')
param location string = resourceGroup().location

resource linuxNSGName 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: 'linux-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'DenyAllIncoming'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Inbound'
          priority: 100
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowAllOutgoing'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 101
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
    ]
  }
}
resource windowsNSGName 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: 'windows-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDPIncoming'
        properties: {
          access: 'Deny'
          destinationAddressPrefix: '*'
          destinationPortRange: '3389'
          direction: 'Inbound'
          priority: 100
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
      {
        name: 'AllowAllOutgoing'
        properties: {
          access: 'Allow'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          direction: 'Outbound'
          priority: 101
          protocol: '*'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
        }
      }
    ]
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' existing = {
  name: 'build-agents-vnet'

  resource subnet1Name 'subnets' = {
    name: 'agents-subnet'
    properties: {
      addressPrefix: '10.0.0.0/24'
      networkSecurityGroup: linuxNSGName
    }
  }

  resource subnet2Name 'subnets' = {
    name: 'jumpbox-subnet'
    properties: {
      addressPrefix: '10.0.1.0/24'
      networkSecurityGroup: windowsNSGName
    }
  }
}
