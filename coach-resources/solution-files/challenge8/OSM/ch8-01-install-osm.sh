#!/bin/bash

export CLUSTER_NAME=CHANGEME

export RESOURCE_GROUP=CHANGEME

### REGISTER ADDON ### (Can take up to 10 mins) (needs to go in devContainer)

echo "Registering OSM AddOn"
az feature register --namespace "Microsoft.ContainerService" --name "AKS-OpenServiceMesh"

echo "Querying for registration success, Registration process can be time consuming"
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/AKS-OpenServiceMesh')].{Name:name,State:properties.state}"

## THE STEP ABOVE TAKES A WHILE TO COMPLETE NEED TO LOOP HERE. (WIP)

az provider register --namespace Microsoft.ContainerService

### enable OSM in Cluster
echo "Enabling Open Service Mesh(OSM) on cluster: $CLUSTER_NAME"

az aks enable-addons --addons open-service-mesh -g $RESOURCE_GROUP -n $CLUSTER_NAME

# validate install

az aks list -g $RESOURCE_GROUP -o json | jq -r '.[].addonProfiles.openServiceMesh.enabled'

echo "Installing OSM binary locally"

# Specify the OSM version
export OSM_VERSION=v0.10.0-rc.1

curl -sL "https://github.com/openservicemesh/osm/releases/download/$OSM_VERSION/osm-$OSM_VERSION-linux-amd64.tar.gz" | tar -vxzf -

# copy the osm client binary to the standard user program location in your PATH.
sudo mv ./linux-amd64/osm /usr/local/bin/osm
sudo chmod +x /usr/local/bin/osm

echo "Verifying OSM install"

osm version

echo "Adding namespaces to OSM"

osm namespace add web api

echo "Enabling Metrics for collection"

osm metrics enable --namespace api
osm metrics enable --namespace web

echo "Restarting pods to inject envoy sidecar"

kubectl rollout restart deployment -n api
kubectl rollout restart deployment -n web

### Prometheus/Grafana should already be installed - (script is ../../challenge5/prometheus/ch5-01-prometheus-grafana.sh)

echo "OSM Prometheus required config should return true."
VERIFY_PROMETHEUS=$(kubectl get configmap -n kube-system preset-mesh-config -o json | jq '.data.prometheus_scraping')

if [$VERIFY_PROMETHEUS != "true"]; then
    echo "patching kube-system config for prometheus scraping, previous step returned false"
    kubectl patch configmap -n kube-system preset-mesh-config --type merge --patch '{"data":{"prometheus_scraping":"true"}}'
fi

# to locate the installed prometheus server config map in the monitoring namespace. Informational purposes.
# kubectl get configmap -n monitoring | grep prometheus

# # edit config map with OSM configuration
# kubectl get configmap -n monitoring prometheus-server -o yaml > prometheus-server.yml

# # copy config JIC.
# cp prometheus-server.yml prometheus-server.yml.copy

echo "apply OSM Addon specific prometheus/grafana settings, copied from MSFT docs. https://docs.microsoft.com/en-us/azure/aks/open-service-mesh-open-source-observability"

kubectl apply -n monitoring -f ./new-prometheus-server.yml

## view prometheus metrics in browser

# PROM_POD_NAME=$(kubectl get pods -n monitoring -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")

# kubectl -n monitoring port-forward $PROM_POD_NAME 9090

# #open browser and view
# http://localhost:9090/targets

echo "restart pods for good measure"

kubectl rollout restart deployment -n monitoring

##? Undo osm-add-on and uninstall

## az aks disable-addons -n $CLUSTER_NAME -g $RESOURCE_GROUP - open-service-mesh
