#!/bin/bash

# Identical script to ch2, just deploys into a namespace

# While you can alternately create a secret via YAML file, doing it with kubectl
# manages the base64 encoding for you

export RESOURCE_GROUP=CHANGEME
# Find SQL password in hack portal or deployment script output
export SQL_PASSWORD=CHANGEME

export SQL=$(az sql server list -g $RESOURCE_GROUP --query "[0].name" -o tsv)
export SQL_SERVER=$(az sql server show -g $RESOURCE_GROUP -n $SQL \
    --query fullyQualifiedDomainName -o tsv)
export SQL_USER=$(az sql server show -g $RESOURCE_GROUP -n $SQL \
    --query administratorLogin -o tsv)

export SQL_DBNAME=mydrivingDB

export SECRET_NAME=sql

kubectl create secret -n api generic $SECRET_NAME \
    --from-literal SQL_SERVER=$SQL_SERVER \
    --from-literal SQL_DBNAME=$SQL_DBNAME \
    --from-literal SQL_USER=$SQL_USER \
    --from-literal SQL_PASSWORD=$SQL_PASSWORD
