# Example build commands to create image locally (make sure you are in src subdirectory)
docker build --tag "tripinsights/poi:1.0" .
docker build --tag "tripinsights/trips:1.0" .
docker build --tag "tripinsights/tripviewer:1.0" .
docker build --tag "tripinsights/user-java:1.0" .
docker build --tag "tripinsights/userprogile:1.0" .

# PUSH APIs to ACR
# make sure you are in correct SOURCE dir
# example build commands to push to ACR (make sure you are in proper src subdirectory)
ACR_NAME=registrylee9469.azurecr.io
RES_GROUP=teamresources
CLUSTER_NAME=myAKSCluster

# make sure you are in correct SOURCE dir
az acr build --resource-group $RES_GROUP --registry $ACR_NAME --image tripinsights/poi:1.0 .

az acr build --resource-group $RES_GROUP --registry $ACR_NAME --image tripinsights/trips:1.0 .

# make sure you are in correct SOURCE dir
az acr build --resource-group $RES_GROUP --registry $ACR_NAME --image tripinsights/tripviewer:1.0 .

# make sure you are in correct SOURCE dir
az acr build --resource-group $RES_GROUP --registry $ACR_NAME --image tripinsights/user-java:1.0 .

# make sure you are in correct SOURCE dir
az acr build --resource-group $RES_GROUP --registry $ACR_NAME --image tripinsights/userprofile:1.0 .


# Create basic cluster
az group create --name $RES_GROUP --location eastus

az aks create --resource-group $RES_GROUP --name $CLUSTER_NAME --node-count 3 --enable-addons monitoring 

az aks install-cli

az aks get-credentials --name $CLUSTER_NAME --resource-group $RES_GROUP  --admin --overwrite-existing

# attach ACR to cluster
az aks update -n $CLUSTER_NAME -g $RES_GROUP --attach-acr registryrpj9926.azurecr.io

kubectl get nodes

# create the web and api namespaces (POI goes in WEB, the rest in API)
kubectl create namespace api
kubectl create namespace web

# create required sql secret (with YAML file or via kubectl)
kubectl create -n api secret generic sql \
    --from-literal=SQL_USER=sqladminuIv6525 \
    --from-literal=SQL_PASSWORD=localtestpw123@ \
    --from-literal=SQL_SERVER=sqlserveruiv6525.database.windows.net \
    --from-literal=SQL_DBNAME=mydrivingDB

# create and put required Deployment information in corresponding YAML files
# deploy the pods (the deployment manifests contain NS definition)
kubectl apply -f poi.yaml
kubectl apply -f trips.yaml
kubectl apply -f user-java.yaml
kubectl apply -f userprofile.yaml
kubectl apply -f tripviewer.yaml

#describe the services
kubectl get pods -n api -o wide
kubectl get pods -n web -o wide
kubectl describe service poi -n api
kubectl describe service trips -n api
kubectl describe service user-java -n api
kubectl describe service userprofile -n api
kubectl describe service tripviewer -n web


# execute command in a pod
kubectl exec mydrive-user-deployment-6bc4556c9c-jpgzj -- printenv | grep SERVICE

#from any node in the cluster, check health of POI API
curl -i -X GET 'http://<ServiceEndPointIP>:8080/api/poi/healthcheck' 

#example:
curl -i -X GET 'http://10.3.0.112:8080/api/poi/healthcheck'

# check the env vars in a POD
 kubectl exec  -n api mydrive-user-deployment-6bc4556c9c-jpgzj -- printenv | grep SERVICE


CLUSTER_RESOURCE_GROUP=$(az aks show --resource-group teamresources --name myAKSCluster --query nodeResourceGroup -o tsv)
az vmss list --resource-group $CLUSTER_RESOURCE_GROUP -o table


# To create an ssh connection to a node in the cluster, deploy a container in the cluster to act as a "jumpbox"

 https://docs.microsoft.com/en-us/azure/aks/ssh#create-the-ssh-connection

kubectl run -it --rm aks-ssh --image=debian 
apt-get update && apt-get install openssh-client -y 
#  copy your private key to the container from another window :
kubectl cp ~/.ssh/id_rsa $(kubectl get pod -l run=aks-ssh -o jsonpath='{.items[0].metadata.name}'):/id_rsa

# ssh into the required cluster node from the newly deployed "jumpbox container":
chmod 0600 id_rsa
ssh -i id_rsa azureuser@10.240.0.4  # this will connect you to one of the nodes below (for example)



# example COMMANDS TO VIEW the NODES, PODS and SERVICES NETWORKING:

kubectl get nodes -o wide

       NAME                                STATUS   ROLES   AGE     VERSION    INTERNAL-IP   EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION      CONTAINER-RUNTIME
       aks-nodepool1-10719468-vmss000000   Ready    agent   4h9m    v1.16.10   10.240.0.4    <none>        Ubuntu 16.04.6 LTS   4.15.0-1089-azure   docker://3.0.10+azure
       aks-nodepool1-10719468-vmss000001   Ready    agent   4h9m    v1.16.10   10.240.0.5    <none>        Ubuntu 16.04.6 LTS   4.15.0-1089-azure   docker://3.0.10+azure
       aks-nodepool1-10719468-vmss000002   Ready    agent   4h10m   v1.16.10   10.240.0.6    <none>        Ubuntu 16.04.6 LTS   4.15.0-1089-azure   docker://3.0.10+azure

az vmss list --resource-group $CLUSTER_RESOURCE_GROUP -o table

       Name                         ResourceGroup                                   Location       Zones    Capacity    Overprovision    UpgradePolicy
       ---------------------------  ----------------------------------------------  -------------  -------  ----------  ---------------  ---------------
       aks-nodepool1-10719468-vmss  MC_aq-kubernetes-rg_myAKSCluster_canadacentral  canadacentral           3           False            Manual

kubectl get pods -n api -o wide

       NAME                                       READY   STATUS    RESTARTS   AGE    IP            NODE                                NOMINATED NODE   READINESS GATES
       mydrive-user-deployment-6bc4556c9c-jpgzj   1/1     Running   0          143m   10.244.1.15   aks-nodepool1-10719468-vmss000000   <none>           <none>
       mydrive-user-deployment-6bc4556c9c-q5qbm   1/1     Running   0          143m   10.244.2.15   aks-nodepool1-10719468-vmss000001   <none>           <none>
       poi-deployment-579cfbc7b8-hlkxn            1/1     Running   0          144m   10.244.2.12   aks-nodepool1-10719468-vmss000001   <none>           <none>
       poi-deployment-579cfbc7b8-whp2k            1/1     Running   0          144m   10.244.1.12   aks-nodepool1-10719468-vmss000000   <none>           <none>
       trip-deployment-559b64449f-vr9gd           1/1     Running   0          144m   10.244.1.13   aks-nodepool1-10719468-vmss000000   <none>           <none>
       trip-deployment-559b64449f-vzmb5           1/1     Running   0          144m   10.244.2.13   aks-nodepool1-10719468-vmss000001   <none>           <none>
       user-java-deployment-68889c96bf-5qmpq      1/1     Running   0          143m   10.244.2.14   aks-nodepool1-10719468-vmss000001   <none>           <none>
       user-java-deployment-68889c96bf-cvfzm      1/1     Running   0          143m   10.244.1.14   aks-nodepool1-10719468-vmss000000   <none>           <none>

kubectl get services -n api

       NAME          TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
       poi           ClusterIP   10.0.105.207   <none>        80/TCP,443/TCP   20h
       trips         ClusterIP   10.0.32.1      <none>        80/TCP,443/TCP   20h
       user-java     ClusterIP   10.0.81.207    <none>        80/TCP,443/TCP   20h
       userprofile   ClusterIP   10.0.60.253    <none>        80/TCP,443/TCP   20h

kubectl describe service poi -n api

       Name:              poi
       Namespace:         api
       Labels:            <none>
       Annotations:       Selector:  app=poi
       Type:              ClusterIP
       IP:                10.0.105.207
       Port:              poi-http  80/TCP
       TargetPort:        8080/TCP
       Endpoints:         10.244.1.12:8080,10.244.2.12:8080
       Port:              poi-https  443/TCP
       TargetPort:        443/TCP
       Endpoints:         10.244.1.12:443,10.244.2.12:443
       Session Affinity:  None
       Events:            <none>


