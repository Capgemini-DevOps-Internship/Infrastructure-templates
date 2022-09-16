@description('Name of the existing app service to show in the dashboard')
param appServiceName string

@description('Name of the resource group that contains the app service')
param appServiceResourceGroup string

@metadata({ Description: 'Resource name that Azure portal uses for the dashboard' })
param dashboardName string = 'appService-dashboard'
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
                    id: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Requests'
                        resourceId: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
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
                    id: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Response Time'
                        resourceId: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
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
                    id: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Requests In Application Queue'
                        resourceId: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
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
                    id: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'CPU Time'
                        resourceId: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
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
              y: 2
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
                    id: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Memory working set'
                        resourceId: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
                      }
                      {
                        name: 'Average Memory working set'
                        resourceId: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
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
              y: 0
              rowSpan: 4
              colSpan: 8
            }
            metadata: {
              inputs: [
                {
                  name: 'queryInputs'
                  value: {
                    timespan: {
                      duration: 'PT1H'
                    }
                    id: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Http 2xx'
                        resourceId: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
                      }
                      {
                        name: 'Http 3xx'
                        resourceId: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
                      }
                      {
                        name: 'Http 4xx'
                        resourceId: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
                      }
                      {
                        name: 'Http Server Errors'
                        resourceId: resourceId(appServiceResourceGroup, 'Microsoft.Web/sites', appServiceName)
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