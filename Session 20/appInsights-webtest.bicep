@description('The name of the underlying Application Insights resource.')
param appName string = 'Capgem-App-Insights'

@description('The url you wish to test.')
param pingURL string = 'https://capgem-webapp-1.azurewebsites.net'

@description('The text you would like to find.')
param pingText string = ''

@description('Location for all resources.')
param location string = resourceGroup().location

var pingTestName_var = 'PingTest-${toLower(appName)}'
var webAppID = '/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/build-agents-templates/providers/Microsoft.Web/sites/Capgem-webapp-1'
var appInsightsResource = '/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/build-agents-templates/providers/Microsoft.Insights/components/Capgem-App-Insights'

resource appName_resource 'Microsoft.Insights/components@2020-02-02' = {
  name: appName
  location: location
  tags: {
    'hidden-link:${webAppID}': 'Resource'
  }
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource pingTestName 'Microsoft.Insights/webtests@2015-05-01' = {
  name: pingTestName_var
  location: location
  tags: {
    'hidden-link:${appInsightsResource}': 'Resource'
  }
  properties: {
    Name: pingTestName_var
    Description: 'Basic ping test'
    Enabled: true
    Frequency: 300
    Timeout: 120
    Kind: 'ping'
    RetryEnabled: true
    Locations: [
      {
        Id: 'emea-nl-ams-azr'
      }
    ]
    Configuration: {
      WebTest: '<WebTest   Name="${pingTestName_var}"   Enabled="True"         CssProjectStructure=""    CssIteration=""  Timeout="120"  WorkItemIds=""         xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"         Description=""  CredentialUserName=""  CredentialPassword=""         PreAuthenticate="True"  Proxy="default"  StopOnError="False"         RecordedResultFile=""  ResultsLocale="">  <Items>  <Request Method="GET"    Version="1.1"  Url="${pingURL}" ThinkTime="0"  Timeout="300" ParseDependentRequests="True"         FollowRedirects="True" RecordResult="True" Cache="False"         ResponseTimeGoal="0"  Encoding="utf-8"  ExpectedHttpStatusCode="200"         ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />        </Items>  <ValidationRules> <ValidationRule  Classname="Microsoft.VisualStudio.TestTools.WebTesting.Rules.ValidationRuleFindText, Microsoft.VisualStudio.QualityTools.WebTestFramework, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" DisplayName="Find Text"         Description="Verifies the existence of the specified text in the response."         Level="High"  ExecutionOrder="BeforeDependents">  <RuleParameters>        <RuleParameter Name="FindText" Value="${pingText}" />  <RuleParameter Name="IgnoreCase" Value="False" />  <RuleParameter Name="UseRegularExpression" Value="False" />  <RuleParameter Name="PassIfTextFound" Value="True" />  </RuleParameters> </ValidationRule>  </ValidationRules>  </WebTest>'
    }
    SyntheticMonitorId: pingTestName_var
  }
  dependsOn: [
    appName_resource
  ]
}