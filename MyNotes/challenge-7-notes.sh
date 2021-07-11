# to add a new user node pool to the existing clutser:

az aks get-versions
            The behavior of this command has been altered by the following extension: aks-preview
            KubernetesVersion    Upgrades
            -------------------  ----------------------------------------
            1.18.6(preview)      None available
            1.18.4(preview)      1.18.6(preview)
            1.17.9               1.18.4(preview), 1.18.6(preview)
            1.17.7               1.17.9, 1.18.4(preview), 1.18.6(preview)
            1.16.13              1.17.7, 1.17.9
            1.16.10              1.16.13, 1.17.7, 1.17.9
            1.15.12              1.16.10, 1.16.13
            1.15.11              1.15.12, 1.16.10, 1.16.13

RESOURCE_GROUP_NAME=teamresources
az aks nodepool list --resource-group $RESOURCE_GROUP_NAME --cluster-name myAKSCluster

# Get the virtual network subnet resource ID
RESOURCE_GROUP_NAME=teamresources
SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP_NAME --vnet-name vnet --name aks-subnet --query id -o tsv)

# A taint can only be set for node pools during node pool creation, but you can set up taints on a node basis.
# Windows agent pool name can not be longer than 6 characters
# the default type of added node pools is = User
# the version of K8S in the added node pool will be the same as the exxisting one, which you upgraded in a previous exercise.

az aks nodepool add \
    --resource-group teamresources \
    --cluster-name myAKSCluster \
    --os-type Windows \
    --name win001 \
    --node-count 1 \
    --vnet-subnet-id $SUBNET_ID \
    --no-wait

# YOU MAY WANT TO ADD these as well, at time of creation, especially max-pods as it can only be set at time of node pool creation
# BTW, the defaul to max-pods is = 30
--max-count
--max-pods
--min-count

# if you need to scale up the nodepool:
az aks nodepool scale \
    --resource-group teamresources \
    --cluster-name myAKSCluster \
    --name win001 \
    --node-count 2 \
    --no-wait

kubectl get nodes -o wide

# IMPORTANT NOTE
# You can find out the username in the portal for the WINDOWS VMSS, and then reset the password using the portal as well
# the default user is "azuser", even if no windows profile was included when you created the AKS cluster

# test deploymnet of a windows container to your windows nodes 
# make sure participants use the proper node selector ' '"kubernetes.io/os": Windows ' (dont use the "beta" use suggested in the azure docs)
https://kubernetes.io/docs/setup/production-environment/windows/user-guide-windows-containers/

https://docs.microsoft.com/en-us/azure/aks/windows-container-cli

# participants have wcf & tripviewer2 apps in the ACR. They need to create new yaml files to deploy them.
# wcf is a windows app, must run in a windows node, and tripviewer2 is a linux app, will need a new ingress
# should I remove tripviewer (original) prior to deploying tripviewer2?
# 

