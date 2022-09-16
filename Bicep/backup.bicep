param webAppName string = uniqueString(resourceGroup().id) // Generate unique String for web app name
param sku string = 'S1' // The SKU of App Service Plan
param language string = '.net' // The runtime stack of web app
param location string = resourceGroup().location // Location for all resources

var appServicePlanName = '${webAppName}${uniqueString(resourceGroup().id)}'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
  }
  kind: language
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: webAppName
  location: location
  properties: {
    siteConfig: {
      appSettings: []
      netFrameworkVersion: '6.0'
    }
    serverFarmId: appServicePlan.id
  }
}

resource backup 'Microsoft.Web/sites/config@2022-03-01' = {
  name: 'backup'
  kind: language
  parent: webApp
  properties: {
    backupName: 'backup'
    backupSchedule: {
      frequencyInterval: 6
      frequencyUnit: 'Hour'
      keepAtLeastOneBackup: false
      retentionPeriodInDays: 7
    }
    enabled: true
    storageAccountUrl: 'https://yhiyq453gyzto.blob.core.windows.net/logs?sp=r&st=2022-08-30T09:50:29Z&se=2022-09-05T17:50:29Z&spr=https&sv=2021-06-08&sr=c&sig=Ze5G4VsGXFYsP0bzmLYWypuewocO6upJHPn%2BRQHbEoA%3D'
  }
}
