#!/bin/bash
# set -xeuo pipefail
IFS=$'\n\t'

declare region="canadacentral"
declare resourceGroupName="teamResources"
declare suffix=""
declare proctorRG="proctorResources"
declare randstr=""
declare createAdUsers=""

# Initialize parameters specified from command line
while getopts ":c:s:l:i:q:r:u:p:t:g:o:" arg; do
    case "${arg}" in
        r)
            region=${OPTARG}
        ;;
        t)
            resourceGroupName=${OPTARG}
        ;;
        s)
            suffix=${OPTARG}
        ;;
        a)
            createAdUsers=${OPTARG}
        ;;
    esac
done
shift $((OPTIND-1))

declare teamRG=$resourceGroupName

if [[ -n "$suffix" ]]; then
    
	teamRG=$teamRG-$suffix
	proctorRG=$proctorRG-$suffix
fi

randomChar() {
    s=abcdefghijklmnopqrstuvxwyz
    p=$(( $RANDOM % 26))
    echo -n ${s:$p:1}
}

randomNum() {
    echo -n $(( $RANDOM % 10 ))
}

randomCharUpper() {
    s=ABCDEFGHIJKLMNOPQRSTUVWXYZ
    p=$(( $RANDOM % 26))
    echo -n ${s:$p:1}
}

randStr="$(randomChar;randomCharUpper;randomChar;randomNum;randomNum;randomNum;randomNum)"
registryName="$(echo "registry${randStr}" | tr '[:upper:]' '[:lower:]')"
sqlServerName="$(echo "sqlserver${randStr}" | tr '[:upper:]' '[:lower:]')"
sqlServerUsername="sqladmin${randStr}"
sqlServerPassword="$(randomChar;randomCharUpper;randomNum;randomChar;randomChar;randomNum;randomCharUpper;randomChar;randomNum)" 
sqlDBName="mydrivingDB"
simulatorName="simulator-app-$registryName"
dataLoadImage="openhack/data-load:v1"
webdevpassword="$(randomChar;randomCharUpper;randomNum;randomChar;randomChar;randomNum;randomCharUpper;randomChar;randomNum)" 
apidevpassword="$(randomChar;randomCharUpper;randomNum;randomChar;randomChar;randomNum;randomCharUpper;randomChar;randomNum)" 

echo "=========================================="
echo " VARIABLES"
echo "=========================================="
echo "region            = "${region}
echo "teamRG            = "${teamRG}
echo "proctorRG         = "${proctorRG}
echo "registryName      = "${registryName}
echo "sqlServerName     = "${sqlServerName}
echo "sqlServerUsername = "${sqlServerUsername}
echo "sqlDBName         = "${sqlDBName}

echo "Registering preview features..."

az feature register --name APIServerSecurityPreview --namespace Microsoft.ContainerService
az feature register --name WindowsPreview --namespace Microsoft.ContainerService
az feature register --name PodSecurityPolicyPreview --namespace Microsoft.ContainerService

echo "Registering providers required..."
az provider register --namespace Microsoft.OperationsManagement

az group create -n $teamRG -l $region

# might be already created, but if not create here... 
az group create -n $proctorRG -l $region


# Create Azure SQL Server instance
echo "Creating Azure SQL Server instance..."
az sql server create -l $region -g $teamRG -n $sqlServerName -u $sqlServerUsername -p $sqlServerPassword


if [ $? == 0 ];
then
    echo "SQL Server created successfully."
    echo "Adding firewall rule to SQL server..."
    az sql server firewall-rule create --resource-group $teamRG --server $sqlServerName -n "Allow Access To Azure Services" --start-ip-address 0.0.0.0 --end-ip-address 0.0.0.0
    
    if [ $? == 0 ];
    then
        echo "Firewall rule added successfully to SQL server."
    else
        echo "Failed to add firewall rule to SQL server."
    fi

    # Create Azure SQL DB
    echo "Creating Azure SQL DB..."
    az sql db create -g $teamRG -s $sqlServerName -n $sqlDBName

    echo "SQL database created successfully."
    az container create -g $proctorRG --name dataload --image $dataLoadImage --secure-environment-variables SQLFQDN=$sqlServerName.database.windows.net SQLUSER=$sqlServerUsername SQLPASS=$sqlServerPassword SQLDB=$sqlDBName
else
    echo "Failed to create SQL Server."
fi






echo "SQL Server: $sqlServerName"
echo "SQL Server User Name: $sqlServerUsername"
echo "SQL ServerPassword: $sqlServerPassword"


