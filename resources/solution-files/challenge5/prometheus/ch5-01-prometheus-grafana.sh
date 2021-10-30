#!/bin/bash

echo "Script depends on having helm, kubectl installed and configured and pointed at the right cluster"

kubectl apply -f ./monitoring-namespace.yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus \
    --namespace monitoring \
    prometheus-community/prometheus

echo "You dont have Grafana installed yet, no real useful dashbaord yet"
echo "installing grafana"


helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install osm-grafana \
--namespace monitoring \
-f ./persist-grafana.yml \
grafana/grafana

# Note password (should be set by persist-grafana.yml, but JIC)
kubectl get secret --namespace monitoring osm-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

kubectl port-forward -n monitoring deployment/osm-grafana 3000

##### things to consider ingres to grafana

# navigate to
# http://localhost:3000


# undo all of above
# helm uninstall prometheus osm-grafana
# kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
# kubectl delete crd alertmanagers.monitoring.coreos.com
# kubectl delete crd podmonitors.monitoring.coreos.com
# kubectl delete crd probes.monitoring.coreos.com
# kubectl delete crd prometheuses.monitoring.coreos.com
# kubectl delete crd prometheusrules.monitoring.coreos.com
# kubectl delete crd servicemonitors.monitoring.coreos.com
# kubectl delete crd thanosrulers.monitoring.coreos.com