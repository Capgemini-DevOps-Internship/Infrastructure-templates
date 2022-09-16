resource "azurerm_application_insights" "component" {
  name                = "Capgem-App-Insights"
  location            = "westeurope"
  resource_group_name = "build-agents-templates"
  application_type    = "web"
}

resource "azurerm_application_insights_web_test" "availability_test" {
  name                    = "PingTest-capgem-app-insights"
  location                = azurerm_application_insights.component.location
  resource_group_name     = "build-agents-templates"
  application_insights_id = azurerm_application_insights.component.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 60
  enabled                 = true
  geo_locations           = ["emea-nl-ams-azr"]

  configuration = <<XML
<WebTest Name="WebTest1" Id="ABD48585-0831-40CB-9069-682EA6BB3583" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="a5f10126-e4cd-570d-961c-cea43999a200" Version="1.1" Url="https://capgem-webapp-1.azurewebsites.net" ThinkTime="0" Timeout="300" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML

}

output "webtest_id" {
  value = azurerm_application_insights_web_test.example.id
}

output "webtests_synthetic_id" {
  value = azurerm_application_insights_web_test.example.synthetic_monitor_id
}