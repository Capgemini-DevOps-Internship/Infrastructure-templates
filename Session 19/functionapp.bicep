@description('Specifies region of all resources.')
param location string = resourceGroup().location

@description('Suffix for function app, storage account, and key vault names.')
param appNameSuffix string = 'capgem'

@description('Storage account SKU name.')
param storageSku string = 'Standard_LRS'

var functionAppName = 'functionapp-${appNameSuffix}'
var appServicePlanName = 'FunctionPlan'
var appInsightsName = 'AppInsights'
var storageAccountName = 'functionapp-storage${replace(appNameSuffix, '-', '')}'
var functionRuntime = 'node'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource plan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: appServicePlanName
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
  }
  properties: {}
}

resource functionApp 'Microsoft.Web/sites@2020-12-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: appInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: 'InstrumentationKey=${appInsights.properties.InstrumentationKey}'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionRuntime
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
      ]
    }
    httpsOnly: true
  }
}

resource function1 'Microsoft.Web/sites/functions@2020-12-01' = {
  name: '${functionApp.name}/MyHttpTriggeredFunction'
  properties: {
    config: {
      disabled: false
      bindings: [
        {
          name: 'req'
          type: 'httpTrigger'
          direction: 'in'
          authLevel: 'function'
          methods: [
            'get', 'POST'
          ]
        }
        {
          name: '$return'
          type: 'http'
          direction: 'out'
        }
      ]
    }
    files: {
      'run.csx': loadTextContent('index-http.js')
    }
  }
}

resource function2 'Microsoft.Web/sites/functions@2020-12-01' = {
  name: '${functionApp.name}/MyTimerTriggeredFunction-1'
  properties: {
    config: {
      disabled: false
      bindings: [
        {
          name: 'StartMorning'
          schedule: '0 0 8 * * 1-5'
          direction: 'in'
          type: 'timerTrigger'
        }
      ]
    }
    files: {
      'run.csx': loadTextContent('index-start.js')
    }
  }
}

resource function3 'Microsoft.Web/sites/functions@2020-12-01' = {
  name: '${functionApp.name}/MyTimerTriggeredFunction-2'
  properties: {
    config: {
      disabled: false
      bindings: [
        {
          name: 'StopEvening'
          schedule: '0 0 20 * * 1-5'
          direction: 'in'
          type: 'timerTrigger'
        }
      ]
    }
    files: {
      'run.csx': loadTextContent('index-stop.js')
    }
  }
}
