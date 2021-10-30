#!/bin/bash

# Script requires being logged in to correct Azure account

# SQL credentials
export SQL_PASSWORD=CHANGEME

# ACR connection details
export ACR=CHANGEME
export ACR_URL=$ACR.azurecr.io

# docker network name
export NETWORK=tripinsights

# Create a Docker network
docker network create $NETWORK

# Pull SQL Server container
docker pull mcr.microsoft.com/mssql/server:2017-latest

# Run SQL Server container
docker run \
    --name sql \
    --network $NETWORK \
    -p 1433:1433 \
    -e "ACCEPT_EULA=Y" \
    -e "SA_PASSWORD=$SQL_PASSWORD" \
    -d \
    mcr.microsoft.com/mssql/server:2017-latest

# Create a database called mydrivingDB
docker exec \
    -it sql \
    /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U SA -P $SQL_PASSWORD \
    -Q "CREATE DATABASE mydrivingDB"

# (Or if you leave off the query string, you can directly interact with sqlcmd)
# In interactive terminal in SQL container:
# CREATE DATABASE mydrivingDB
# GO
# SELECT NAME FROM sys.databases
# GO
# You should see a list of databases including mydrivingDB
# Exit with Ctrl+C or QUIT

# Login to Azure & to team ACR
az acr login -n $ACR

# Run dataload image
docker run \
    --network $NETWORK \
    -e "SQLFQDN=sql" \
    -e "SQLUSER=SA" \
    -e "SQLPASS=$SQL_PASSWORD" \
    -e "SQLDB=mydrivingDB" \
    $ACR_URL/dataload:1.0

# Run POI
docker run \
    --name poi \
    --network $NETWORK \
    -p 8080:80 \
    -e "SQL_USER=SA" \
    -e "SQL_PASSWORD=$SQL_PASSWORD" \
    -e "SQL_SERVER=sql" \
    -e "ASPNETCORE_ENVIRONMENT=Local" \
    -d \
    tripinsights/poi:1.0

# Open localhost:8080/api/poi in the browser to see several trip datapoints
