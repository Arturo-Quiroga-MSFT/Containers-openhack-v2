
# CONTAINERS OPENHACK SOURCE CODE
https://github.com/Azure-Samples/openhack-containers

# BYOS for CONTAINERS OPENHACK
https://github.com/microsoft/OpenHack
https://github.com/microsoft/OpenHack/tree/main/byos/containers


# DOCKERFILES mapping:
POI = DOCKERFILE_3
TRIPS = DOCKERFILE_4
TRIPVIEWER = DOCKERFILE_1
USER-PROFILE-JAVA = DOCKERFILE_5
USER-PROFILE = DOCKERFILE_2

# namespaces in the cluster
API NAMESPACE = POI, TRIPS, USER_JAVA, USER-PROFILE
WEB NAMESPACE = TRIPVIEWER

# Run the SQL SERVER container locally
sqlpassword=localtestpw123@
sqlserver=aqsqlsvr1
docker network create aq-network -d bridge

sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$sqlpassword" \
   -p 1433:1433 --name $sqlserver \
   -d \
   -h $sqlserver \
   --network aq-network \
   mcr.microsoft.com/mssql/server:2019-latest

# make modifications to the sql server container
sudo docker exec -it $sqlserver /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P "$sqlpassword" \
   -Q 'ALTER LOGIN SA WITH PASSWORD="$sqlpassword"'

# connect to the sql server container  
sudo docker exec -it $sqlserver "bash"

# inside the container, run the sqlcmd cli
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "$sqlpassword"

# create a database
CREATE DATABASE mydrivingDB
SELECT Name from sys.Databases
GO

SELECT @@SERVERNAME,
    SERVERPROPERTY('ComputerNamePhysicalNetBIOS'),
    SERVERPROPERTY('MachineName'),
    SERVERPROPERTY('ServerName')
GO

# or create new sql DB in the running sql server container and populate it like this:
docker exec $sqlserver /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U SA \
    -P '$sqlpassword' \
    -Q "CREATE DATABASE mydrivingDB"

docker run -d --network aq-network \
--name dataload -e "SQLFQDN=$sqlserver" \
-e "SQLUSER=sa" -e "SQLPASS=$sqlpassword" \
-e "SQLDB=mydrivingDB" \
openhack/data-load:v1

# give some time for data to load
sleep 20
docker logs dataload

# BUILD the IMAGES locally prior to running them.
# make sure you are in correct SOURCE dir
docker image build -t tripinsights/poi:1.0  .

# make sure you are in correct SOURCE dir
docker image build -t tripinsights/trips:1.0  .

# make sure you are in correct SOURCE dir
docker image build -t tripinsights/tripviewer:1.0 .

# make sure you are in correct SOURCE dir
docker image build -t tripinsights/user-java:1.0 .

# make sure you are in correct SOURCE dir
docker image build -t tripinsights/userprofile:1.0 .
docker images

# once data is loaded into the sql DB, run POI
sqlpassword=localtestpw123@
sqlserver=aqsqlsvr1
docker run -d \
    --network aq-network \
    -p 8080:80 \
    --name poi \
    -e "SQL_PASSWORD=$sqlpassword" \
    -e "SQL_SERVER=$sqlserver" \
    -e "SQL_USER=sa" \
    -e "ASPNETCORE_ENVIRONMENT=Local" \
    tripinsights/poi:1.0
    
# chect status of POI
curl -i -X GET 'http://localhost:8080/api/poi/healthcheck' 
docker logs poi

# if you want, RUN all the other CONTAINERS as well (images previously built).


docker run -d \
    --network aq-network \
    -p 8081:80 \
    --name trips \
    -e "SQL_PASSWORD=$sqlpassword" \
    -e "SQL_SERVER=$sqlserver" \
    -e "SQL_USER=sa" \
    -e "OPENAPI_DOCS_URI=http://temp" \
    tripinsights/trips:1.0

docker run -d \
    --network aq-network \
    -p 8082:80 \
    --name user-java \
    -e "SQL_PASSWORD=$sqlpassword" \
    -e "SQL_SERVER=$sqlserver" \
    -e "SQL_USER=sa" \
    tripinsights/user-java:1.0 

docker run -d \
    --network aq-network \
    -p 8083:80 \
    --name userprofile \
    -e "SQL_PASSWORD=$sqlpassword" \
    -e "SQL_SERVER=$sqlserver" \
    -e "SQL_USER=sa" \
    tripinsights/userprofile:1.0

docker run -d \
    --network aq-network \
    -p 8084:80 \
    --name tripviewer \
    -e "USERPROFILE_API_ENDPOINT=http://userprofile.api.svc.cluster.local" \
    -e "TRIPS_API_ENDPOINT=http://trips.api.svc.cluster.local" \
    tripinsights/tripviewer:1.0 

docker ps

printf "call poi\n"
curl -X GET 'http://localhost:8080/api/poi'





# checking health of the containers

curl -i -X GET 'http://localhost:8082/api/user-java/healthcheck' 
curl -i -X GET 'http://localhost:8081/api/trips/healthcheck' 
curl -i -X GET 'http://localhost:8080/api/poi/healthcheck'
curl -i -X GET 'http://localhost:8083/api/user/healthcheck'
curl -i -X GET 'http://localhost:8084'

You can even open up a browser and go to the URL below to see the TRIPVIEWER web page
http://localhost:8084


# to build and PUSH to the ACR
# if you deploy via the shell script in solutions, make sure the container registry exists and that the containers have been pushed to it.
# or if you just want to push the recently built images to the ACR, do
ACR_NAME=registrybkp3109
RES_GROUP=teamresources
LOCATION=westus
WORKSPACE=aq-logsopenhack77
VNETNAME=vnet
SUBNETNAME=AKSSubnet

az group create --name $RES_GROUP --location $LOCATION

az monitor log-analytics workspace create -g $RES_GROUP -n $WORKSPACE -l $LOCATION --no-wait
az monitor log-analytics workspace list -g $RES_GROUP
az monitor log-analytics workspace show --resource-group $RES_GROUP --workspace-name $WORKSPACE

az acr create -g $RES_GROUP \
  --name $ACR_NAME --sku Standard \
  --admin-enabled true
az acr list
az acr login -n $ACR_NAME -g $RES_GROUP

# Add vnet or add subnet to existing vnet
az network vnet create -n $VNETNAME -g $RES_GROUP -l $LOCATION --address-prefix 10.77.0.0/16 \
    --subnet-name  $SUBNETNAME --subnet-prefix 10.77.0.0/24
az network vnet list

# -OR- add subnet to existing vnet (after adding additional IP address space to the existing vnet)
az network vnet subnet create -g teamresources --vnet-name vnet -n AKSSubnet \
    --address-prefixes 10.3.0.0/17


# PUSH APIs to ACR
# make sure you are in correct SOURCE dir, and that you have modified the Dockerfile accordingly to match the req sqlserver vars
az acr build --resource-group $RES_GROUP --registry $ACR_NAME --image tripinsights/poi:1.0 .

# make sure you are in correct SOURCE dir, and that you have modified the Dockerfile accordingly to match the req sqlserver vars
az acr build --resource-group $RES_GROUP --registry $ACR_NAME --image tripinsights/trips:1.0 .

# make sure you are in correct SOURCE dir
az acr build --resource-group $RES_GROUP --registry $ACR_NAME --image tripinsights/tripviewer:1.0 .

# make sure you are in correct SOURCE dir, and that you have modified the Dockerfile accordingly to match the req sqlserver vars
az acr build --resource-group $RES_GROUP --registry $ACR_NAME --image tripinsights/user-java:1.0 .

# make sure you are in correct SOURCE dir, and that you have modified the Dockerfile accordingly to match the req sqlserver vars
az acr build --resource-group $RES_GROUP --registry $ACR_NAME --image tripinsights/userprofile:1.0 .





# BING MAPS API KEY:
a6bZ_CmPXN8oGUSt3JiFB3fYuFk32btHimsglAua1FLR




