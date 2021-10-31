#!/bin/bash

# Unfortunately not fully tested due to limitations of MSFT AD tenant

export RESOURCE_GROUP=teamResources-8
export CLUSTER_NAME=openhack

export WEB_AD_USER=CHANGEME
export API_AD_USER=CHANGEME

export WEB_AD_GROUP_NAME=web-dev
export API_AD_GROUP_NAME=api-dev

export CLUSTER_ID=$(az aks show \
    -g $RESOURCE_GROUP -n $CLUSTER_NAME \
    --query id -o tsv)

# Create group for web users, add web dev, assign Azure RBAC role
# Again, group creation in MSFT tenant is limited - but so is user creation
# so you may not be able to do this regardless
export WEB_GROUP_ID=$(az ad group create \
    --display-name $WEB_AD_GROUP_NAME \
    --mail-nickname $WEB_AD_GROUP_NAME \
    --query objectId -o tsv)

az ad group member add -g $WEB_AD_GROUP_NAME --member-id $WEB_AD_USER

az role assignment create \
    --assignee $WEB_GROUP_ID \
    --role "Azure Kubernetes Service Cluster User Role" \
    --scope $CLUSTER_ID

# Create group for api users, add api dev, assign Azure RBAC role
export API_GROUP_ID=$(az ad group create \
    --display-name $API_AD_GROUP_NAME \
    --mail-nickname $API_AD_GROUP_NAME \
    --query objectId -o tsv)

az ad group member add -g $API_AD_GROUP_NAME --member-id $API_AD_USER

az role assignment create \
    --assignee $API_GROUP_ID \
    --role "Azure Kubernetes Service Cluster User Role" \
    --scope $CLUSTER_ID
