#!/bin/bash

export RESOURCE_GROUP=CHANGEME
export CLUSTER_NAME=CHANGEME

export POD_IDENTITY_NAME=trips-sql-access
export POD_IDENTITY_NAMESPACE=api

export SQL=$(az sql server list -g $RESOURCE_GROUP --query "[0].name" -o tsv)
export AD_ADMIN=$(az account show --query user.name -o tsv)

# Update the cluster to enable pod identity
az aks update \
    -g $RESOURCE_GROUP -n $CLUSTER_NAME \
    --enable-pod-identity

# Create an identity for the trips service to use
az identity create \
    -g $RESOURCE_GROUP \
    --name $POD_IDENTITY_NAME

export IDENTITY_CLIENT_ID=$(az identity show \
    -g $RESOURCE_GROUP -n $POD_IDENTITY_NAME \
    --query clientId -o tsv)
export IDENTITY_RESOURCE_ID=$(az identity show \
    -g ${RESOURCE_GROUP} -n $POD_IDENTITY_NAME \
    --query id -o tsv)

# Create the pod identity
az aks pod-identity add \
    -g $RESOURCE_GROUP --cluster-name $CLUSTER_NAME \
    --namespace $POD_IDENTITY_NAMESPACE --name $POD_IDENTITY_NAME \
    --identity-resource-id $IDENTITY_RESOURCE_ID

# View pod identity CRDs to confirm that the pod ID has been created
kubectl get azureidentities --namespace $POD_IDENTITY_NAMESPACE
kubectl get azureidentitybindings --namespace $POD_IDENTITY_NAMESPACE

# Add an AD Admin to SQL

# Theoretically this should work, but I've been getting errors from it.
# You can do it in the portal instead
az sql server ad-admin create \
    -g $RESOURCE_GROUP -s $SQL \
    -u $AD_ADMIN

# In SQL db ->
# CREATE USER [trips-sql-access] FROM EXTERNAL PROVIDER
# ALTER ROLE db_datareader ADD MEMBER [trips-sql-access]
# ALTER ROLE db_datawriter ADD MEMBER [trips-sql-access]
