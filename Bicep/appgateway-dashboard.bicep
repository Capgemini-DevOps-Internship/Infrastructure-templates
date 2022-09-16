@description('Name of the existing app gateway to show in the dashboard')
param appGatewayName string

@description('Name of the resource group that contains the app gateway')
param appGatewayResourceGroup string

@metadata({ Description: 'Resource name that Azure portal uses for the dashboard' })
param dashboardName string = 'appGateway-dashboard'
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
                    id: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Total Requests'
                        resourceId: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
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
                    id: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Failed Requests'
                        resourceId: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
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
                    id: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Healthy host count'
                        resourceId: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
                      }
                      {
                        name: 'Unhealthy host count'
                        resourceId: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
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
                    id: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Throughput'
                        resourceId: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
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
                    id: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Backend first byte response time'
                        resourceId: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
                      }
                      {
                        name: 'Backend last byte response time'
                        resourceId: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
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
                    id: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Backend connect time'
                        resourceId: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
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
              y: 0
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
                    id: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
                    chartType: 0
                    metrics: [
                      {
                        name: 'Application gateway total time'
                        resourceId: resourceId(appGatewayResourceGroup, 'Microsoft.Network/applicationGateways', appGatewayName)
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