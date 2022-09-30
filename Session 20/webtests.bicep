@description('The name of the underlying Application Insights resource.')
param appName string = 'appinsight'

@description('The url you wish to test.')
param pingURL1 string = 'https://host-1.azurewebsites.net'

@description('The url you wish to test.')
param pingURL2 string = 'https://host-2.azurewebsites.net'

@description('The url you wish to test.')
param pingURL3 string = 'http://capgemhost.trafficmanager.net'

@description('The url you wish to test.')
param pingURL4 string = ' https://endpoint1-csg6a9c6ggezeyhm.z01.azurefd.net'

@description('The text you would like to find.')
param pingText string = ''

@description('Location for all resources.')
param location string = resourceGroup().location

var pingTestName1 = 'PingTest-host1'
var pingTestName2 = 'PingTest-host2'
var pingTestName3 = 'PingTest-tm'
var pingTestName4 = 'PingTest-fd'
var host1ID = '/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/globally-distributed-systems/providers/Microsoft.Web/sites/host-1'
var host2ID = '/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/globally-distributed-systems/providers/Microsoft.Web/sites/host-2'
var tmID = '/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/globally-distributed-systems/providers/Microsoft.Network/trafficManagerProfiles/capgemTmProfile'
var fdID = '/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourcegroups/globally-distributed-systems/providers/Microsoft.Cdn/profiles/capgemFrontDoor'
var appInsightsResource = '/subscriptions/98cc8bcf-cb96-47e7-8f2a-670bded78f14/resourceGroups/globally-distributed-systems/providers/Microsoft.Insights/components/appinsight'

resource appName_resource 'Microsoft.Insights/components@2020-02-02' = {
  name: appName
  location: location
  tags: {
    'hidden-link:${host1ID}': 'Resource'
    'hidden-link:${host2ID}': 'Resource'
    'hidden-link:${tmID}': 'Resource'
    'hidden-link:${fdID}': 'Resource'
  }
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource pingTest 'Microsoft.Insights/webtests@2015-05-01' = {
  name: pingTestName1
  location: location
  tags: {
    'hidden-link:${appInsightsResource}': 'Resource'
  }
  properties: {
    Name: pingTestName1
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
      WebTest: '<WebTest   Name="${pingTestName1}"   Enabled="True"         CssProjectStructure=""    CssIteration=""  Timeout="120"  WorkItemIds=""         xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"         Description=""  CredentialUserName=""  CredentialPassword=""         PreAuthenticate="True"  Proxy="default"  StopOnError="False"         RecordedResultFile=""  ResultsLocale="">  <Items>  <Request Method="GET"    Version="1.1"  Url="${pingURL1}" ThinkTime="0"  Timeout="300" ParseDependentRequests="True"         FollowRedirects="True" RecordResult="True" Cache="False"         ResponseTimeGoal="0"  Encoding="utf-8"  ExpectedHttpStatusCode="200"         ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />        </Items>  <ValidationRules> <ValidationRule  Classname="Microsoft.VisualStudio.TestTools.WebTesting.Rules.ValidationRuleFindText, Microsoft.VisualStudio.QualityTools.WebTestFramework, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" DisplayName="Find Text"         Description="Verifies the existence of the specified text in the response."         Level="High"  ExecutionOrder="BeforeDependents">  <RuleParameters>        <RuleParameter Name="FindText" Value="${pingText}" />  <RuleParameter Name="IgnoreCase" Value="False" />  <RuleParameter Name="UseRegularExpression" Value="False" />  <RuleParameter Name="PassIfTextFound" Value="True" />  </RuleParameters> </ValidationRule>  </ValidationRules>  </WebTest>'
    }
    SyntheticMonitorId: pingTestName1
  }
  dependsOn: [
    appName_resource
  ]
}

resource pingTest2 'Microsoft.Insights/webtests@2015-05-01' = {
  name: pingTestName2
  location: location
  tags: {
    'hidden-link:${appInsightsResource}': 'Resource'
  }
  properties: {
    Name: pingTestName2
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
      WebTest: '<WebTest   Name="${pingTestName2}"   Enabled="True"         CssProjectStructure=""    CssIteration=""  Timeout="120"  WorkItemIds=""         xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"         Description=""  CredentialUserName=""  CredentialPassword=""         PreAuthenticate="True"  Proxy="default"  StopOnError="False"         RecordedResultFile=""  ResultsLocale="">  <Items>  <Request Method="GET"    Version="1.1"  Url="${pingURL2}" ThinkTime="0"  Timeout="300" ParseDependentRequests="True"         FollowRedirects="True" RecordResult="True" Cache="False"         ResponseTimeGoal="0"  Encoding="utf-8"  ExpectedHttpStatusCode="200"         ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />        </Items>  <ValidationRules> <ValidationRule  Classname="Microsoft.VisualStudio.TestTools.WebTesting.Rules.ValidationRuleFindText, Microsoft.VisualStudio.QualityTools.WebTestFramework, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" DisplayName="Find Text"         Description="Verifies the existence of the specified text in the response."         Level="High"  ExecutionOrder="BeforeDependents">  <RuleParameters>        <RuleParameter Name="FindText" Value="${pingText}" />  <RuleParameter Name="IgnoreCase" Value="False" />  <RuleParameter Name="UseRegularExpression" Value="False" />  <RuleParameter Name="PassIfTextFound" Value="True" />  </RuleParameters> </ValidationRule>  </ValidationRules>  </WebTest>'
    }
    SyntheticMonitorId: pingTestName2
  }
  dependsOn: [
    appName_resource
  ]
}

resource pingTest3 'Microsoft.Insights/webtests@2015-05-01' = {
  name: pingTestName3
  location: location
  tags: {
    'hidden-link:${appInsightsResource}': 'Resource'
  }
  properties: {
    Name: pingTestName3
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
      WebTest: '<WebTest   Name="${pingTestName3}"   Enabled="True"         CssProjectStructure=""    CssIteration=""  Timeout="120"  WorkItemIds=""         xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"         Description=""  CredentialUserName=""  CredentialPassword=""         PreAuthenticate="True"  Proxy="default"  StopOnError="False"         RecordedResultFile=""  ResultsLocale="">  <Items>  <Request Method="GET"    Version="1.1"  Url="${pingURL3}" ThinkTime="0"  Timeout="300" ParseDependentRequests="True"         FollowRedirects="True" RecordResult="True" Cache="False"         ResponseTimeGoal="0"  Encoding="utf-8"  ExpectedHttpStatusCode="200"         ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />        </Items>  <ValidationRules> <ValidationRule  Classname="Microsoft.VisualStudio.TestTools.WebTesting.Rules.ValidationRuleFindText, Microsoft.VisualStudio.QualityTools.WebTestFramework, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" DisplayName="Find Text"         Description="Verifies the existence of the specified text in the response."         Level="High"  ExecutionOrder="BeforeDependents">  <RuleParameters>        <RuleParameter Name="FindText" Value="${pingText}" />  <RuleParameter Name="IgnoreCase" Value="False" />  <RuleParameter Name="UseRegularExpression" Value="False" />  <RuleParameter Name="PassIfTextFound" Value="True" />  </RuleParameters> </ValidationRule>  </ValidationRules>  </WebTest>'
    }
    SyntheticMonitorId: pingTestName3
  }
  dependsOn: [
    appName_resource
  ]
}

resource pingTest4 'Microsoft.Insights/webtests@2015-05-01' = {
  name: pingTestName4
  location: location
  tags: {
    'hidden-link:${appInsightsResource}': 'Resource'
  }
  properties: {
    Name: pingTestName4
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
      WebTest: '<WebTest   Name="${pingTestName4}"   Enabled="True"         CssProjectStructure=""    CssIteration=""  Timeout="120"  WorkItemIds=""         xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010"         Description=""  CredentialUserName=""  CredentialPassword=""         PreAuthenticate="True"  Proxy="default"  StopOnError="False"         RecordedResultFile=""  ResultsLocale="">  <Items>  <Request Method="GET"    Version="1.1"  Url="${pingURL4}" ThinkTime="0"  Timeout="300" ParseDependentRequests="True"         FollowRedirects="True" RecordResult="True" Cache="False"         ResponseTimeGoal="0"  Encoding="utf-8"  ExpectedHttpStatusCode="200"         ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />        </Items>  <ValidationRules> <ValidationRule  Classname="Microsoft.VisualStudio.TestTools.WebTesting.Rules.ValidationRuleFindText, Microsoft.VisualStudio.QualityTools.WebTestFramework, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a" DisplayName="Find Text"         Description="Verifies the existence of the specified text in the response."         Level="High"  ExecutionOrder="BeforeDependents">  <RuleParameters>        <RuleParameter Name="FindText" Value="${pingText}" />  <RuleParameter Name="IgnoreCase" Value="False" />  <RuleParameter Name="UseRegularExpression" Value="False" />  <RuleParameter Name="PassIfTextFound" Value="True" />  </RuleParameters> </ValidationRule>  </ValidationRules>  </WebTest>'
    }
    SyntheticMonitorId: pingTestName4
  }
  dependsOn: [
    appName_resource
  ]
}
