@description('Describes plan\'s pricing tier and instance size.')
param skuName string = 'S1'

@description('Describes plan\'s instance count')
param skuCapacity int = 1

@description('The admin user of the SQL Server')
param sqlAdministratorLogin string

@description('The password of the admin user of the SQL Server')
@secure()
param sqlAdministratorLoginPassword string

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The name of the app to create.')
param appName string = 'sql-appservice'

@description('Docker Hub image to be used.')
param linuxFxVersion string = 'DOCKER|herbertmoore/static-website-01:hello_world'

var hostingPlanName = '${appName}${uniqueString(resourceGroup().id)}'
var sqlserverName = 'sqlserver${uniqueString(resourceGroup().id)}'
var databaseName = 'sampledb'
var vnetName = '${appName}-vnet'
var vnetAddressPrefix = '10.0.0.0/16'
var subnetName = '${appName}-subnet'
var subnetAddressPrefix = '10.0.0.0/24'

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
          serviceEndpoints: [
            {
              service: 'Microsoft.Sql'
              locations:[
                '*'
              ]
            }
          ]
        }
      }
    ]
  }
}

resource sqlserver 'Microsoft.Sql/servers@2021-02-01-preview' = {
  name: sqlserverName
  location: location
  properties: {
    administratorLogin: sqlAdministratorLogin
    administratorLoginPassword: sqlAdministratorLoginPassword
    version: '12.0'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlserver
  name: databaseName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 1073741824
  }
}

resource allowIps 'Microsoft.Sql/servers/firewallRules@2021-02-01-preview' = {
  parent: sqlserver
  name: 'AllowIps'
  properties: {
    endIpAddress: '10.0.0.255'
    startIpAddress: '10.0.0.0'
  }
}

resource BackupPolicy 'Microsoft.Sql/servers/databases/geoBackupPolicies@2015-05-01-preview' = {
  name: 'Default'
  parent: sqlDatabase
  properties: {
    state: 'Enabled'
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: hostingPlanName
  location: location
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  kind: 'linux'
  properties:{
    reserved: true
  }
}

resource website 'Microsoft.Web/sites@2020-12-01' = {
  name: appName
  location: location
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      linuxFxVersion: linuxFxVersion
    }
  }
}

resource webSiteConnectionStrings 'Microsoft.Web/sites/config@2020-12-01' = {
  parent: website
  name: 'connectionstrings'
  properties: {
    DefaultConnection: {
      value: 'Data Source=tcp:${sqlserver.properties.fullyQualifiedDomainName},1433;Initial Catalog=${databaseName};User Id=${sqlAdministratorLogin}@${sqlserver.properties.fullyQualifiedDomainName};Password=${sqlAdministratorLoginPassword};'
      type: 'SQLAzure'
    }
  }
}
