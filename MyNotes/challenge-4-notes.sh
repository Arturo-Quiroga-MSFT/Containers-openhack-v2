################################################################
# THIS IS THE SECURITY PART of THE CHALLENGE
# main reference for this part of the challange is this:
################################################################
# FROM ==> https://docs.microsoft.com/en-us/azure/aks/azure-ad-rbac
AKS_ID=$(az aks show \
    --resource-group teamresources \
    --name myAKSCluster \
    --query id -o tsv)
# create two AAD GROUPS for API and WEB groups
## Web Dev
WEBDEV_GROUP_ID=$(az ad group create \
    --display-name Web-dev \
    --mail-nickname webdev \
    --query objectId -o tsv)
# wait for AAD propagation, then:
az role assignment create \
    --assignee $WEBDEV_GROUP_ID \
    --role "Azure Kubernetes Service Cluster User Role" \
    --scope $AKS_ID
## Api Dev
APIDEV_GROUP_ID=$(az ad group create \
    --display-name Api-dev \
    --mail-nickname apidev \
    --query objectId -o tsv)
# wait for AAD propagation, then:
az role assignment create \
    --assignee $APIDEV_GROUP_ID \
    --role "Azure Kubernetes Service Cluster User Role" \
    --scope $AKS_ID





# ***************************************************************************************
# THIS IS THE KEYVAULT INTEGRATION part of the challenge.
# TO DO THE NEW WAY WITH CSI_DRIVER (which is an open source project NOT supported by Azure support):
# USE THESE NEW REFERENCES
# ***************************************************************************************
# FROM ==> https://github.com/HoussemDellai/aks-keyvault

# the summary of the procedure is as follows
# Add CSI Driver Helm Repo
helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts

# Install CSI Driver Helm Chart
helm install csi-secrets-store-provider-azure/csi-secrets-store-provider-azure --generate-name

# define variables
keyvaultName=aq-tripinsights-kv
resourcegroup=teamresources
subid=28c473e4-ad30-46cd-b669-f92768ef2cc4
tenantid=$(az account show --query tenantId -o tsv)
location=canadacentral

# Create Key Vault and secrets
az keyvault create --name $keyvaultName --resource-group $resourcegroup --location $location

# Get Key Vault ID for later use, if needed.
export kv_id=$(az keyvault show -g $resourcegroup -n $keyvaultName -o tsv --query id)

# Create required secrets
az keyvault secret set --vault-name $keyvaultName --name "SQLPASSWORD" --value "localtestpw123@"
az keyvault secret show --name "SQLPASSWORD" --vault-name $keyvaultName
az keyvault secret set --vault-name $keyvaultName --name "SQLUSER" --value "sqladminuIv6525"
az keyvault secret show --name "SQLUSER" --vault-name $keyvaultName
az keyvault secret set --vault-name $keyvaultName --name "SQLSERVERNAME" --value "sqlserveruiv6525.database.windows.net"
az keyvault secret show --name "SQLSERVERNAME" --vault-name $keyvaultName
az keyvault secret set --vault-name $keyvaultName --name "SQLDBNAME" --value "mydrivingDB"
az keyvault secret show --name "SQLDBNAME" --vault-name $keyvaultName

# create a SecretProviderClass.yaml file
    apiVersion: secrets-store.csi.x-k8s.io/v1alpha1
    kind: SecretProviderClass
    metadata:
    name: azure-$keyvaultName
    spec:
    provider: azure
    parameters:
        usePodIdentity: "false"         		                    
        useVMManagedIdentity: "false"                               
        userAssignedIdentityID: ""                                                         
        keyvaultName: $keyvaultName                                                                                    
        cloudName: "AzurePublicCloud"          			                            
        objects:  |
        array:
            - |
            objectName: SQLPASSWORD 
            objectAlias: ""                                  
            objectType: secret                                    
            objectVersion: ""                                    
            - |
            objectName: SQLSERVER
            objectAlias: ""   
            objectType: secret
            objectVersion: ""
            - |
            objectName: SQLUSER
            objectAlias: ""   
            objectType: secret
            objectVersion: ""
             - |
            objectName: SQLDBNAME
            objectAlias: ""   
            objectType: secret
            objectVersion: ""
        resourceGroup: $resourcegroup                       
        subscriptionId: $subid                            
        tenantId: $tenantid                          



# make sure the proper env variable is set prior to applying the manifest files.
keyvaultName=aq-tripinsights-kv

# Then create new manifests files and add the volumes section at bottom of all the deployment 
# manifest files for the tripinsighst APIs
# add this at the following section (using POI as an example)
    containers:
      - name: poi
        image: "registryuiv6525.azurecr.io/tripinsights/poi:1.0"
        imagePullPolicy: Always
        volumeMounts:
        - name: secrets-store-inline
          mountPath: "/secrets"
          readOnly: true
# add this in the spec: section, after the env: subsection of the deployment
        env:
          - name: WEB_SERVER_BASE_URI
            value: 'http://0.0.0.0'
          - name: WEB_PORT
            value: '8080'
          - name: ASPNETCORE_ENVIRONMENT
            value: 'Production'
    volumes:
    - name: secrets-store-inline
      csi:
        driver: secrets-store.csi.k8s.io
        readOnly: true
        volumeAttributes:
          secretProviderClass: azure-$KV_NAME

# after you create new yaml for all APIs, then start the pods again
kubectl apply -f poi-csidriver.yaml
kubectl apply -f trips-csidriver.yaml
kubectl apply -f tripviewer-csidriver.yaml
kubectl apply -f user-java-csidriver.yaml
kubectl apply -f userprofile-csidriver.yaml

# Test that the secrets were mounted properly
kubectl exec -it <nameofcontainer> -- cat /secrets/SQLPASSWORD

# additional good references for CSI DRIVER
https://github.com/kubernetes-sigs/secrets-store-csi-driver/blob/master/test/bats/tests/azure/azure_synck8s_v1alpha1_secretproviderclass.yaml
https://github.com/kubernetes-sigs/secrets-store-csi-driver
https://github.com/kubernetes-sigs/secrets-store-csi-driver/blob/master/test/bats/tests/vault/nginx-deployment-synck8s.yaml
https://github.com/kubernetes-sigs/secrets-store-csi-driver/blob/master/test/bats/tests/vault/vault_v1alpha1_secretproviderclass.yaml



##################################################################
# THIS IS THE INGRESS CONTROLLER PART OF THE CHALLENGE
# deploy the INGRESS CONTROLLER via HELM using this:
##################################################################
# FROM==> https://docs.microsoft.com/en-us/azure/aks/ingress-basic
# Create a namespace for your ingress resources
kubectl create namespace ingress-basic
# Add the ingress-nginx repository
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set controller.admissionWebhooks.patch.nodeSelector."beta\.kubernetes\.io/os"=linux
    
# to Troubleshoot ingress controller issues see ==> https://kubernetes.github.io/ingress-nginx/troubleshooting/

# Deploy the capability to use HTTPs by using ==> https://docs.microsoft.com/en-us/azure/aks/ingress-tls
# and from ==> https://cert-manager.io/docs/configuration/

# install CERT MANAGER as well via helm to enable https, use the procedure below to use LET'S ENCRYPT
# https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip#install-cert-manager
# https://github.com/jetstack/cert-manager
# https://cert-manager.io/docs/tutorials/acme/ingress/

# to create a VALID certificate, use this: ==> https://cert-manager.io/docs/usage/certificate/#creating-certificate-resources

# Instead of creating a CUSTOM DOMAIN, to add a FQDN to the PUBLIC IP of the NGINX INGRESS CONTROLLER. do:
# ==> https://docs.microsoft.com/en-us/azure/aks/ingress-tls#add-an-a-record-to-your-dns-zone

        # Public IP address of your ingress controller
        IP="13.83.22.211"

        # Name to associate with public IP address
        DNSNAME="aq-openhack-ingress"

        # Get the resource-id of the public ip
        PUBLICIPID=$(az network public-ip list -g MC_teamResources_myAKSCluster_westus --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv)

        # Update public ip address with DNS name
        az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME

        # Display the FQDN
        az network public-ip show -g MC_teamResources_myAKSCluster_westus --ids $PUBLICIPID --query "[dnsSettings.fqdn]" --output tsv

        # final FQDN for the ingress controller will be   = aq-openhack-ingress.westus.cloudapp.azure.com
        # http://aq-openhack-ingress.westus.cloudapp.azure.com
        # or hhtps://aq-openhack-ingress.westus.cloudapp.azure.com



# VALIDATE THE deployment by using the simulator (container in ACI) and by checking the logs of all the PODS in the API namepsace
# BTW, /api/user-java may not respond, this is TBE.
kubectl logs poi-deployment-559d4d75cc-jggpc -n api




#
# INTEGRATING KEYVAULT TO K8S (OLD WAY)
# to do it the OLD & DEPRECATED way (flexvol and SPs):
# the references are:
https://github.com/Azure/kubernetes-keyvault-flexvol
https://github.com/Azure/kubernetes-keyvault-flexvol/blob/master/deployment/nginx-flex-kv-deployment.yaml

az ad sp create-for-rbac --name humongousServicePrincipal --skip-assignment
Changing "humongousServicePrincipal" to a valid URI of "http://humongousServicePrincipal", which is the required format used for service principal names
AppId                                 DisplayName                Name                              Password                            Tenant
------------------------------------  -------------------------  --------------------------------  ----------------------------------  ------------------------------------
f5c03edb-1564-4b09-b288-fdf08ff821cf  humongousServicePrincipal  http://humongousServicePrincipal  NDglcI9Wpc1GhXxhyUy5Jst-uiazo~D9-u  216a4c5c-1fd6-49d7-bcd2-276158ba6499

az aks show --name myAKSCluster --resource-group teamresources

AZURE_CLIENT_ID=f5c03edb-1564-4b09-b288-fdf08ff821cf
AZURE_CLIENT_SECRET=NDglcI9Wpc1GhXxhyUy5Jst-uiazo~D9-u
SUBID=28c473e4-ad30-46cd-b669-f92768ef2cc4
KEYVAULT_RESOURCE_GROUP=teamresources
KEYVAULT_NAME=aqkeyvault

kubectl create -f https://raw.githubusercontent.com/Azure/kubernetes-keyvault-flexvol/master/deployment/kv-flexvol-installer.yaml
kubectl get pods -n kv

az role assignment create --role Reader --assignee $AZURE_CLIENT_ID --scope /subscriptions/$SUBID/resourcegroups/$KEYVAULT_RESOURCE_GROUP/providers/Microsoft.KeyVault/vaults/$KEYVAULT_NAME
kubectl create secret generic secrets-store-creds --from-literal clientid=$AZURE_CLIENT_ID --from-literal clientsecret=$AZURE_CLIENT_SECRET


# Assign key vault permissions to your service principal
KV_NAME=aqkeyvault
az keyvault set-policy -g teamresources -n $KV_NAME --key-permissions get --spn f5c03edb-1564-4b09-b288-fdf08ff821cf
az keyvault set-policy -g teamresources -n $KV_NAME --secret-permissions get --spn f5c03edb-1564-4b09-b288-fdf08ff821cf
az keyvault set-policy -g teamresources -n $KV_NAME --certificate-permissions get --spn f5c03edb-1564-4b09-b288-fdf08ff821cf

# FYI (OPTIONAL): you can also use FLEXVOL with managed identities:
https://github.com/Azure/kubernetes-keyvault-flexvol#option-4-vmss-system-assigned-managed-identity-new-in-version--v0015

# get the managed identity information & verification (you need the RG name and the VMSS name)
az vmss identity show -g MC_teamresources_myAKSCluster_westus -n aks-linuxpool1-34996606-vmss -o yaml




# TO DO THE NEW WAY WITH CSI_DRIVER (which is an open source project NOT supported by Azure support):
# USE THESE NEW REFERENCES

https://github.com/HoussemDellai/aks-keyvault

https://github.com/kubernetes-sigs/secrets-store-csi-driver/blob/master/test/bats/tests/azure/azure_synck8s_v1alpha1_secretproviderclass.yaml

https://github.com/kubernetes-sigs/secrets-store-csi-driver

https://github.com/kubernetes-sigs/secrets-store-csi-driver/blob/master/test/bats/tests/vault/nginx-deployment-synck8s.yaml

https://github.com/kubernetes-sigs/secrets-store-csi-driver/blob/master/test/bats/tests/vault/vault_v1alpha1_secretproviderclass.yaml



# VALIDATE THE deployment by using the simulator (container in ACI) and by checking the logs of all the PODS in the API namepsace
# BTW, /api/user-java may not respond, this is TBE.
kubectl logs poi-deployment-559d4d75cc-jggpc -n api



# IF PARTICIPANTS COMPLETE THE CHALLANGE #4, share with them the following:

# LENS IDE for K8S
https://k8slens.dev

# CONTAINERS OPENHACK SOURCE CODE
https://github.com/Azure-Samples/openhack-containers

# BYOS for CONTAINERS OPENHACK
https://github.com/microsoft/OpenHack
https://github.com/microsoft/OpenHack/tree/main/byos/containers


