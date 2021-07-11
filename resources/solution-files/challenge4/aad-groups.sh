#!/bin/bash

## Web Dev
WEBDEV_GROUP_ID=$(az ad group create \
    --display-name Web-dev \
    --mail-nickname webdev \
    --query objectId -o tsv)

az role assignment create \
    --assignee $WEBDEV_GROUP_ID \
    --role "Azure Kubernetes Service Cluster User Role" \
    --scope $AKS_ID

## Api Dev
APIDEV_GROUP_ID=$(az ad group create \
    --display-name Api-dev \
    --mail-nickname apidev \
    --query objectId -o tsv)

az role assignment create \
    --assignee $APIDEV_GROUP_ID \
    --role "Azure Kubernetes Service Cluster User Role" \
    --scope $AKS_ID
