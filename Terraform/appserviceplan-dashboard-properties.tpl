{
  "properties": {
    "lenses": {
      "0": {
        "order": 0,
        "parts": {
          "0": {
            "position": {
              "x": 0,
              "y": 4,
              "colSpan": 11,
              "rowSpan": 3
            },
            "metadata": {
              "inputs": [
                {
                  "name": "queryInputs",
                  "value": {
                    "timespan": {
                      "duration": "PT1H"
                    },
                    "id": "/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/build-agents-templates/providers/Microsoft.Web/serverfarms/ServerFarm1",
                    "chartType": 0,
                    "metrics": [
                      {
                        "name": "CPU Percentage",
                        "resourceId": "/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/build-agents-templates/providers/Microsoft.Web/serverfarms/ServerFarm1"
                      }
                    ]
                  }
                }
              ],
              "type": "Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart"
            }
          },
          "1": {
            "position": {
              "x": 0,
              "y": 7,
              "colSpan": 3,
              "rowSpan": 2
            },
            "metadata": {
              "inputs": [
                {
                  "name": "queryInputs",
                  "value": {
                    "timespan": {
                      "duration": "PT1H"
                    },
                    "id": "/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/build-agents-templates/providers/Microsoft.Web/serverfarms/ServerFarm1",
                    "chartType": 0,
                    "metrics": [
                      {
                        "name": "Memory Percentage",
                        "resourceId": "/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/build-agents-templates/providers/Microsoft.Web/serverfarms/ServerFarm1"
                      }
                    ]
                  }
                }
              ],
              "type": "Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart"
            }
          },
          "2": {
            "position": {
              "x": 3,
              "y": 7,
              "colSpan": 3,
              "rowSpan": 2
            },
            "metadata": {
              "inputs": [
                {
                  "name": "queryInputs",
                  "value": {
                    "timespan": {
                      "duration": "PT1H"
                    },
                    "id": "/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/build-agents-templates/providers/Microsoft.Web/serverfarms/ServerFarm1",
                    "chartType": 0,
                    "metrics": [
                      {
                        "name": "Disk Queue Length",
                        "resourceId": "/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/build-agents-templates/providers/Microsoft.Web/serverfarms/ServerFarm1"
                      }
                    ]
                  }
                }
              ],
              "type": "Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart"
            }
          },
          "3": {
            "position": {
              "x": 6,
              "y": 7,
              "colSpan": 3,
              "rowSpan": 2
            },
            "metadata": {
              "inputs": [
                {
                  "name": "queryInputs",
                  "value": {
                    "timespan": {
                      "duration": "PT1H"
                    },
                    "id": "/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/build-agents-templates/providers/Microsoft.Web/serverfarms/ServerFarm1",
                    "chartType": 0,
                    "metrics": [
                      {
                        "name": "HTTP Queue Length",
                        "resourceId": "/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/build-agents-templates/providers/Microsoft.Web/serverfarms/ServerFarm1"
                      }
                    ]
                  }
                }
              ],
              "type": "Extension/Microsoft_Azure_Monitoring/PartType/MetricsChartPart"
            }
          }
        }
      }
    },
    "metadata": {
      "model": {}
    }
  },
  "name": "appServicePlan-dashboard",
  "type": "Microsoft.Portal/dashboards",
  "location": "INSERT LOCATION",
  "tags": {
    "hidden-title": "appServicePlan-dashboard"
  },
  "apiVersion": "2015-08-01-preview"
}