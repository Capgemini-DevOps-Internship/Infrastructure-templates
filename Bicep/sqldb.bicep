@description('The name of the SQL logical server.')
param serverName string = uniqueString('sql', resourceGroup().id)

@description('The name of the SQL Database.')
param sqlDBName string = 'SampleDB'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('The administrator username of the SQL logical server.')
param administratorLogin string

@description('The administrator password of the SQL logical server.')
@secure()
param administratorLoginPassword string

@description('array of firewall rules.')
param firewallRulesName string = 'FirewallRules'

@description('DB Backup Policy.')
param backupPolicyName string = 'Default'

resource sqlServer 'Microsoft.Sql/servers@2021-08-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlFirewall 'Microsoft.Sql/servers/firewallRules@2022-02-01-preview' = {
  name: firewallRulesName
  parent: sqlServer
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2021-08-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

resource BackupPolicy 'Microsoft.Sql/servers/databases/geoBackupPolicies@2022-02-01-preview' = {
  name: backupPolicyName
  parent: sqlDB
  properties: {
    state: 'Enabled'
  }
}
