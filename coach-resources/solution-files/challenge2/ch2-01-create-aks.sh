#!/bin/bash

export RESOURCE_GROUP=CHANGEME
export CLUSTER_NAME=CHANGEME

export ACR=$(az acr list -g $RESOURCE_GROUP --query "[0].name" -o tsv)

# Create minimally configured AKS cluster
az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $CLUSTER_NAME \
    --attach-acr $ACR \
    --node-count 1 \
    --generate-ssh-keys

# Get kubeconfig credentials
az aks get-credentials -g $RESOURCE_GROUP -n $CLUSTER_NAME