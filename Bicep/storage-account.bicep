@description('The name of the web app.')
param storageAccountName string = uniqueString('store', resourceGroup().id)

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Storage Account Tier.')
param storageAccountType string = 'Standard_LRS'

@description('Container name.')
param containerName string = 'logs'

resource StorageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties:{
    accessTier: 'Hot'
  }
}
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2021-06-01' = {
  name: 'default'
  parent: StorageAccount
}

resource storageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  name: containerName
  parent: blobService
}
