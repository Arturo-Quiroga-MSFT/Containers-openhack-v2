# Secure your cluster using pod security policies
# HIGHLY RECCOMEND PARTICIPANTS TO READ ALL THIS PAGE PRIOR TO DOING ANYTHING (TOP TO BOTTOM).
https://docs.microsoft.com/en-us/azure/aks/use-pod-security-policies

# Install the aks-preview extension
az extension add --name aks-preview

# Update the extension to make sure you have the latest version installed
az extension update --name aks-preview

az feature register --name PodSecurityPolicyPreview --namespace Microsoft.ContainerService
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/PodSecurityPolicyPreview')].{Name:name,State:properties.state}"
az provider register --namespace Microsoft.ContainerService


# secure access to the API server 
https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges

# To disable security policies, (to be able to quickly do challenge #8)
az aks update \
    --resource-group teamresources \
    --name myAKSCluster \
    --disable-pod-security-policy



