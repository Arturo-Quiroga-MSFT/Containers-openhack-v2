# github workflow secrets
REGISTRY_USERNAME=acrhackfestaqakslab
REGISTRY_PASSWORD=5+Sp5v0bD8EaClB94qGOrfe7aFizp9nn
AZURE_CREDENTIALS= see below (az ad command output)

# github workflow variables
REGISTRY_NAME=acrhackfestaqakslab
CLUSTER_NAME=aksaqakslab
CLUSTER_RESOURCE_GROUP=aks-rg-aqakslab
NAMESPACE=angular-app

az ad sp create-for-rbac --sdk-auth --role Contributor
# command output
{
  "clientId": "cfae4c35-980c-410b-a313-f9cddefa38bd",
  "clientSecret": "PiWu_iUH6l.W70-yBVTdDwYCW.LvPrhju5",
  "subscriptionId": "c11348eb-0f8f-46cd-8e7d-70a4893d2817",
  "tenantId": "72f988bf-86f1-41af-91ab-2d7cd011db47",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}