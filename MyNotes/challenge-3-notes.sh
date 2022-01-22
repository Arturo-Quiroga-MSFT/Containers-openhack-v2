
# Creating a new cluster, with all the fixings (NEW WAY):
# with rbac enabled, AAD integration using Managed Identities, monitoring enabled, autoscaler, ACR integration, etc

# Env vars.
TENANT_ID=$(az account show --query tenantId -o tsv)
RESOURCE_GROUP=teamresources
VNET_NAME=vnet
SUBNET_NAME=AKSSubnet
WORKSPACE=aq-logsopenhack
CLUSTERNAME=myAKSCluster
LOCATION=eastus
ACRNAME=registrylee9469
SUB_ID=c11348eb-0f8f-46cd-8e7d-70a4893d2817
VNET_ID=$(az network vnet show -g $RESOURCE_GROUP -n $VNET_NAME --query id -o tsv)
SUBNET_ID=$(az network vnet subnet show -g $RESOURCE_GROUP --vnet-name $VNET_NAME -n  $SUBNET_NAME --query id -o tsv)
SUBNET_IPSPACE=$(az network vnet subnet show -g $RESOURCE_GROUP --vnet-name $VNET_NAME -n  $SUBNET_NAME --query addressPrefix -o tsv)
LOGSPACE_ID=/subscriptions/$SUB_ID/resourcegroups/$RESOURCE_GROUP/providers/microsoft.operationalinsights/workspaces/$WORKSPACE


# create cluster with all the fixings:
az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTERNAME \
    --node-count 3 \
    --nodepool-name linuxpool1 \
    --kubernetes-version 1.21.2 \
    --location=$LOCATION \
    --load-balancer-sku Standard \
    --network-plugin azure \
    --vnet-subnet-id $SUBNET_ID \
    --dns-name-prefix aqaks
    --service-cidr $SUBNET_IPSPACE \
    --dns-service-ip  $SUBNET_IPSPACE \
    --docker-bridge-address 172.7.0.0/16
    --network-policy azure \
    --enable-rbac \
    --enable-cluster-autoscaler \
    --max-count 10 \
    --min-count 3 \
    --max-pods 150 \
    --enable-managed-identity \
    --enable-aad \
    --aad-tenant-id $TENANT_ID \
    --enable-addons monitoring \
    --attach-acr $ACRNAME \
    --workspace-resource-id $LOGSPACE_ID

# you could also add this --aad-admin-group-object-ids $CLUSTER_ADMINS_GRP_ID \

# FYI you could enable acr in an existing cluster.
https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration#configure-acr-integration-for-existing-aks-clusters
az aks update -n $CLUSTERNAME -g $RESOURCE_GROUP --attach-acr $ACRNAME

# FYI you could enable AAD integration in an existing cluster.
https://docs.microsoft.com/en-us/azure/aks/managed-aad
az aks update --name $CLUSTERNAME --resource-group $RESOURCE_GROUP --enable-aad --aad-admin-group-object-ids <object-id-of-aksadmins> --aad-tenant-id <aad-tenant-id>

# FYI, you could UPDATE an existing cluster to use MANAGED IDENTITIES (instead of USING SPs)
https://docs.microsoft.com/en-us/azure/aks/use-managed-identity#update-an-aks-cluster-to-managed-identities-preview
az feature register --namespace Microsoft.ContainerService -n MigrateToMSIClusterPreview
az feature register --namespace Microsoft.ContainerService -n UserAssignedIdentityPreview
az identity list --query "[].{Name:name, Id:id, Location:location}" -o table
az aks update -g $RESOURCE_GROUP -n $CLUSTERNAME --enable-managed-identity

# Control access to cluster resources using K8S RBAC and AAD identities in AKS
# This article shows you how to use Azure AD group membership to control access to namespaces and cluster 
# resources using Kubernetes RBAC in an AKS cluster. Example groups and users are created in Azure AD, then Roles 
# and RoleBindings are created in the AKS cluster to grant the appropriate permissions to create and view resources.
https://docs.microsoft.com/en-us/azure/aks/azure-ad-rbac?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Faks%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Fbread%2Ftoc.json

AKS_ID=$(az aks show \
    --resource-group myResourceGroup \
    --name myAKSCluster \
    --query id -o tsv)

# Create APP DEV group and assign it a role
APPDEVGROUP=appdev
APPDEV_ID=$(az ad group create --display-name $APPDEVGROUP --mail-nickname appdev --query objectId -o tsv)
az role assignment create \
  --assignee $APPDEV_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $AKS_ID

# Create OPERATORS group and assign it a role
OPERSGROUP=opssre
OPERSGROUP_ID=$(az ad group create --display-name $OPERSGROUP --mail-nickname opssre --query objectId -o tsv)
az role assignment create \
  --assignee $OPERSGROUP_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope $AKS_ID

# Create DEMO USERS in AAD
AAD_DOMAIN=arturo1970.onmicrosoft.com
AAD_USER_PASSWORD=P@ssw0rd1
AAD_DEV_USERNAME=aksdev1
AAD_OPS_USERNAME=aksop1

# Create a user for app developers role
AKSDEV_ID=$(az ad user create \
  --display-name "AKS Dev 1" \
  --user-principal-name $AAD_DEV_USERNAME@$AAD_DOMAIN \
  --password $AAD_USER_PASSWORD \
  --query objectId -o tsv)
az ad group member add --group $APPDEVGROUP --member-id $AKSDEV_ID

# Create a user for the operators role
AKSSRE_ID=$(az ad user create \
  --display-name "AKS SRE" \
  --user-principal-name $AAD_OPS_USERNAME@$AAD_DOMAIN \
  --password $AAD_USER_PASSWORD \
  --query objectId -o tsv)
az ad group member add --group $OPERSGROUP --member-id $AKSSRE_ID

# and continue to top the rest of the article
https://docs.microsoft.com/en-us/azure/aks/azure-ad-rbac?toc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Faks%2Ftoc.json&bc=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure%2Fbread%2Ftoc.json


# FOR A QUICK DEMO of the above and to get challenged by RBAC, do:

# get your UPN for your azure login
AD_UPN=$(az ad signed-in-user show --query userPrincipalName -o tsv)

# Basic ClusterRoleBinding.yaml file
      apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRoleBinding
      metadata:
        name: humongous-cluster-admins
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: cluster-admin
      subjects:
      - apiGroup: rbac.authorization.k8s.io
        kind: User
        name: hacker4vsu@OTAPRD1418ops.onmicrosoft.com  # or arturoqu@arturo1970.onmicrosoft.com

# Create role binding
kubectl apply -f ClusterRoleBinding.yaml

# to use user credentails and test being challanged by RBAC, use

az aks get-credentials --name $CLUSTERNAME --resource-group $RESOURCE_GROUP --overwrite-existing

# to revert to not using RBAC and not being challanged, use admin credentials
az aks get-credentials --name $CLUSTERNAME --resource-group $resourcegroup  --admin --overwrite-existing

# get cluster configuration
kubectl config view




# ************************************************************
# LET PARTICIPANTS KNOW ABOUT LENS IDE, and demo it to them.
  https://k8slens.dev/
#
# ************************************************************

============================================================================================

# LEGACY STUFF
# Adding Azure AD integration to the cluster, LEGACY using SPs.
# Main reference:
https://docs.microsoft.com/en-us/azure/aks/azure-ad-integration-cli

# Create the Azure AD application
aksname=myAKSCluster
serverApplicationId=$(az ad app create \
    --display-name "${aksname}Server" \
    --identifier-uris "https://${aksname}Server" \
    --query appId -o tsv)

# Update the application group membership claims
az ad app update --id $serverApplicationId --set groupMembershipClaims=All

# Create a service principal for the Azure AD application
az ad sp create --id $serverApplicationId

# Get the service principal secret
serverApplicationSecret=$(az ad sp credential reset \
    --name $serverApplicationId \
    --credential-description "AKSPassword" \
    --query password -o tsv)

# Assign permissions
az ad app permission add \
    --id $serverApplicationId \
    --api 00000003-0000-0000-c000-000000000000 \
    --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope 06da0dbc-49e2-44d2-8312-53f166ab848a=Scope 7ab1d382-f21e-4acd-a863-ba3e13f7da61=Role

# Grant permissions
az ad app permission grant --id $serverApplicationId --api 00000003-0000-0000-c000-000000000000
az ad app permission admin-consent --id  $serverApplicationId

# Create Azure ID client component
clientApplicationId=$(az ad app create \
    --display-name "${aksname}Client" \
    --native-app \
    --reply-urls "https://${aksname}Client" \
    --query appId -o tsv)

# Create a SP for the client app
az ad sp create --id $clientApplicationId

# get oauth2 ID for the server app
oAuthPermissionId=$(az ad app show --id $serverApplicationId --query "oauth2Permissions[0].id" -o tsv)

# add permissions to server and client apps to use oauth2
az ad app permission add --id $clientApplicationId --api $serverApplicationId --api-permissions ${oAuthPermissionId}=Scope
az ad app permission grant --id $clientApplicationId --api $serverApplicationId
# END OF LEGACY way (using SPs)

