@description('Name of the existing app service plan to show in the dashboard')
param appServicePlanName string

@description('Name of the resource group that contains the app service plan')
param appServicePlanResourceGroup string

@metadata({ Description: 'Resource name that Azure portal uses for the dashboard' })
param dashboardName string = 'appServicePlan-dashboard'
param location string = resourceGroup().location

resource dashboardName_resource 'Microsoft.Portal/dashboards@2020-09-01-preview' = {
  name: dashboardName
  location: location
  properties: {
    lenses: [
      {
        order: 0
        parts: [
          {
            position: {
              x: 0
              y: 0
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'queryInputs'
                  value: {
                    timespan: {
                      duration: 'PT1H'
                    }
                    id: resourceId(appServicePlanResourceGroup, 'Microsoft.Web/serverfarms', appServicePlanName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'CPU Percentage'
                        resourceId: resourceId(appServicePlanResourceGroup, 'Microsoft.Web/serverfarms', appServicePlanName)
                      }
                    ]
                  }
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 7
              y: 0
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'queryInputs'
                  value: {
                    timespan: {
                      duration: 'PT1H'
                    }
                    id: resourceId(appServicePlanResourceGroup, 'Microsoft.Web/serverfarms', appServicePlanName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Memory Percentage'
                        resourceId: resourceId(appServicePlanResourceGroup, 'Microsoft.Web/serverfarms', appServicePlanName)
                      }
                    ]
                  }
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 0
              y: 5
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'queryInputs'
                  value: {
                    timespan: {
                      duration: 'PT1H'
                    }
                    id: resourceId(appServicePlanResourceGroup, 'Microsoft.Web/serverfarms', appServicePlanName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Disk Queue Length'
                        resourceId: resourceId(appServicePlanResourceGroup, 'Microsoft.Web/serverfarms', appServicePlanName)
                      }
                    ]
                  }
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
          {
            position: {
              x: 7
              y: 5
              rowSpan: 4
              colSpan: 6
            }
            metadata: {
              inputs: [
                {
                  name: 'queryInputs'
                  value: {
                    timespan: {
                      duration: 'PT1H'
                    }
                    id: resourceId(appServicePlanResourceGroup, 'Microsoft.Web/serverfarms', appServicePlanName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'HTTP Queue Length'
                        resourceId: resourceId(appServicePlanResourceGroup, 'Microsoft.Web/serverfarms', appServicePlanName)
                      }
                    ]
                  }
                }
              ]
              type: 'Extension/HubsExtension/PartType/MonitorChartPart'
            }
          }
        ]
      }
    ]
  }
}
