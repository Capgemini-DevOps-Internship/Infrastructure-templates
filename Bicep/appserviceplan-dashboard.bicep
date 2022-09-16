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
              y: 4
              rowSpan: 3
              colSpan: 11
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
              type: 'Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart'
            }
          }
          {
            position: {
              x: 0
              y: 7
              rowSpan: 2
              colSpan: 3
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
              type: 'Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart'
            }
          }
          {
            position: {
              x: 3
              y: 7
              rowSpan: 2
              colSpan: 3
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
              type: 'Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart'
            }
          }
          {
            position: {
              x: 6
              y: 7
              rowSpan: 2
              colSpan: 3
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
              type: 'Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart'
            }
          }
        ]
      }
    ]
  }
}