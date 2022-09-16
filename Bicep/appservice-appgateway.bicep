param location string = resourceGroup().location
param applicationGatewayName string = 'bicepAppGateway'
param tier string = 'WAF_v2'
param skuSize string = 'WAF_v2'
param capacity int = 2
param subnetName string = 'appgateway-subnet'
param publicIpAddressName string = 'appgatewayIPaddress'
param sku string = 'Standard'
param allocationMethod string = 'Static'
param autoScaleMaxCapacity int = 10

var vnetId = '/subscriptions/7d743f3c-f61e-488a-bfb3-eed5932a6259/resourceGroups/build-agents-templates/providers/Microsoft.Network/virtualNetworks/ln5qsgimdi2iu-vnet'
var publicIPRef = publicIpAddress.id
var subnetRef = '${vnetId}/subnets/${subnetName}'
var applicationGatewayId = resourceId('Microsoft.Network/applicationGateways', applicationGatewayName)

resource applicationGateway 'Microsoft.Network/applicationGateways@2021-08-01' = {
  name: applicationGatewayName
  location: location
  tags: {
  }
  properties: {
    sku: {
      name: skuSize
      tier: tier
    }
    gatewayIPConfigurations: [
      {
        name: 'appGatewayIpConfig'
        properties: {
          subnet: {
            id: subnetRef
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: 'appGwPublicFrontendIp'
        properties: {
          publicIPAddress: {
            id: publicIPRef
          }
        }
      }
    ]
    frontendPorts: [
      {
        name: 'port_80'
        properties: {
          port: 80
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'appservicebackendpool'
        properties: {
          backendAddresses: [
            {
              fqdn: 'sql-appservice.azurewebsites.net'
            }
            {
              fqdn: 'ln5qsgimdi2iu.azurewebsites.net'
            }
            {
              fqdn: 'zwjbeq43tf66q.azurewebsites.net'
            }
          ]
        }
      }
    ]
    backendHttpSettingsCollection: [
      {
        name: 'appGatewayBackendSetting'
        properties: {
          port: 80
          protocol: 'Http'
          cookieBasedAffinity: 'Disabled'
          requestTimeout: 20
        }
      }
    ]
    backendSettingsCollection: []
    httpListeners: [
      {
        name: 'appGatewayListener'
        properties: {
          frontendIPConfiguration: {
            id: '${applicationGatewayId}/frontendIPConfigurations/appGwPublicFrontendIp'
          }
          frontendPort: {
            id: '${applicationGatewayId}/frontendPorts/port_80'
          }
          protocol: 'Http'
          sslCertificate: null
        }
      }
    ]
    listeners: []
    requestRoutingRules: [
      {
        name: 'appGatewayRoutingRule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: '${applicationGatewayId}/httpListeners/appGatewayListener'
          }
          priority: 200
          backendAddressPool: {
            id: '${applicationGatewayId}/backendAddressPools/appservicebackendpool'
          }
          backendHttpSettings: {
            id: '${applicationGatewayId}/backendHttpSettingsCollection/appGatewayBackendSetting'
          }
        }
      }
    ]
    routingRules: []
    enableHttp2: false
    sslCertificates: []
    probes: []
    autoscaleConfiguration: {
      minCapacity: capacity
      maxCapacity: autoScaleMaxCapacity
    }
    firewallPolicy: {
      id: '/subscriptions/7d743f3c-f61e-488a-bfb3-eed5932a6259/resourceGroups/build-agents-templates/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/waf_policy'
    }
  }
  dependsOn: [
    waf_policy
  ]
}

resource waf_policy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2021-08-01' = {
  name: 'waf_policy'
  location: location
  tags: {
  }
  properties: {
    policySettings: {
      mode: 'Detection'
      state: 'Enabled'
      fileUploadLimitInMb: 100
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
    }
    managedRules: {
      exclusions: []
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.1'
          ruleGroupOverrides: null
        }
      ]
    }
    customRules: []
  }
}

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2020-08-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: sku
  }
  properties: {
    publicIPAllocationMethod: allocationMethod
  }
}
