#!/bin/bash

export RESOURCE_GROUP=CHANGEME
export CLUSTER_NAME=CHANGEME
export AD_GROUP_NAME=CHANGEME

export CLUSTER_SUBNET=cluster-subnet

export ACR=$(az acr list -g $RESOURCE_GROUP --query "[0].name" -o tsv)
export VNET=$(az network vnet list -g $RESOURCE_GROUP --query "[0].name" -o tsv)

# In the microsoft tenant, you may not be able to create groups via CLI
# However, you can make a group in the portal *shrug*
export GROUP_OBJECT_ID=$(az ad group create \
    --display-name $AD_GROUP_NAME \
    --mail-nickname $AD_GROUP_NAME \
    --query objectId -o tsv)

# Add your team as members (or alternately owners) to the created group
# This can be done as part of group creation in the portal, or with the CLI:
az ad group member add -g $AD_GROUP_NAME --member-id CHANGEME

# Show existing subnets in your vnet to decide on address space for the cluster subnet
az network vnet subnet list -g $RESOURCE_GROUP --vnet-name $VNET -o table
export CLUSTER_ADDRESS_SPACE=10.2.1.0/24

# Create a subnet for the cluster
export CLUSTER_SUBNET_ID=$(az network vnet subnet create \
    -g $RESOURCE_GROUP --vnet-name $VNET \
    -n $CLUSTER_SUBNET \
    --address-prefixes $CLUSTER_ADDRESS_SPACE \
    --query id -o tsv)

# Create the AKS cluster
# This covers both more advanced networking - in the team vnet, avoiding 
# conflicting address space that is already in use - and enabling Azure AD
az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --attach-acr $ACR \
    --node-count 3 \
    --network-plugin azure \
    --vnet-subnet-id $CLUSTER_SUBNET_ID \
    --service-cidr 10.0.0.0/24 \
    --dns-service-ip 10.0.0.10 \
    --docker-bridge-address 172.17.0.1/16 \
    --enable-aad \
    --aad-admin-group-object-ids $GROUP_OBJECT_ID \
    --generate-ssh-keys

# Get kubeconfig credentials
az aks get-credentials -g $RESOURCE_GROUP -n $CLUSTER_NAME
