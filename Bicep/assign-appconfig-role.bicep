resource DataReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id)
  properties: {
    principalId: 'b51bdd8d-bfdb-4d45-9e5f-cf2f6b718038'
    principalType: 'ServicePrincipal'
    roleDefinitionId: concat('/subscriptions/', subscription().subscriptionId, '/providers/Microsoft.Authorization/roleDefinitions/', '516239f1-63e1-4d78-a4de-a74fb236a071')
  }
}
