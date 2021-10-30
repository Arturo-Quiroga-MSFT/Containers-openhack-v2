
# registry nanme
registryrpj9926.azurecr.io/insurance:1.0

# the insurance app is nasty, it will starve a node's memory, without limits or quotas the pod will be constantly
# evicted, deploy insurance to its own namespace.
kubectl create namespace insurance
kubectl apply -f memory-defaults.yaml --namespace=insurance
kubectl apply -f insurance.yaml
kubectl apply -f insurance-ingress.yaml or insurance-ingress-https.yaml

# insurance app deploy insurance.yaml file

apiVersion: apps/v1
kind: Deployment
metadata:
  name: insurance-deployment
  labels:
    deploy: insurance
spec:
  replicas: 2
  selector:
    matchLabels:
      app: insurance
  template:
    metadata:
      labels:
        app: insurance
    spec:
      containers:
      - image: "registryrpj9926.azurecr.io/insurance:1.0"
        imagePullPolicy: Always
        name: insurance
        ports:
        - containerPort: 8081
          name: http
          protocol: TCP
---
apiVersion: v1
kind: Service
metadata:
  name: insurance
spec:
  type: ClusterIP
  selector:
    app: insurance
  ports:
  - protocol: TCP
    name: insurance-http
    port: 80
    targetPort: 8081

#insurance app ingress deployment file

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx
  name: insurance-ingress
  namespace: insurance
spec:
  rules:
  - http:
      paths:
      - backend:
          serviceName: insurance
          servicePort: 80
        path: /insurance


# To deploy the insurance app with limits and quotas, follow the lnks below
# you can decide to restrict the resources at the namespace level, deploy insurance to its own namespace.

https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/memory-default-namespace/

https://kubernetes.io/docs/tasks/administer-cluster/manage-resources/cpu-default-namespace/

# you can use a ResourceQuota to restrict the memory request total for all Containers running in a namespace. 
# you can also restrict the totals for memory limit, cpu request, and cpu limit.
# If you want to restrict individual Containers, instead of totals for all Containers, use a LimitRange

# file named memory-defaults.yaml, which has been applied to the insurance NS, as per above commands (top)
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
spec:
  limits:
  - default:
      memory: 2Gi
    defaultRequest:
      memory: 256Mi
    type: Container





# MONITORING

# the NEW all up monitoring stack via KUBE-PROMETHEUS-STACK:
# DO THIS, to install the operator via HELM charts:
# FROM ==> https://github.com/prometheus-community/helm-charts
# AND FROM ==> https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm search repo prometheus-community
helm show values prometheus-community/kube-prometheus-stack
kubectl create namespace monitoring
RELEASE_NAME=kube-prometheus
helm install $RELEASE_NAME prometheus-community/kube-prometheus-stack -n monitoring


###########################################################################
# BELOW ARE OLD INSTRUCTIONS for the PREVIOUS WAY OF DEPLOYING
# PROMETHEUS AND GRAFANA SEPARATELY, LEAVING THEM HERE FOR COMPLETENESS
###########################################################################

# Get the Prometheus server URL by running these commands in the same shell:
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 9090
# The Prometheus alertmanager can be accessed via port 80 on the following DNS name from within your cluster:
prometheus-1605732765-alertmanager.monitoring.svc.cluster.local
# Get the Alertmanager URL by running these commands in the same shell:
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=prometheus,component=alertmanager" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 9093
# The Prometheus PushGateway can be accessed via port 9091 on the following DNS name from within your cluster:
prometheus-1605732765-pushgateway.monitoring.svc.cluster.locak
# Get the PushGateway URL by running these commands in the same shell:
export POD_NAME=$(kubectl get pods --namespace monitoring -l "app=prometheus,component=pushgateway" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace monitoring port-forward $POD_NAME 9091
# install GRAFANA chart
https://github.com/grafana/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm search repo grafana
helm install  --generate-name --namespace monitoring grafana/grafana
# 1. Get your 'admin' user password by running:
   kubectl get secret --namespace monitoring grafana-1605733331 -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
# 2. The Grafana server can be accessed via port 80 on the following DNS name from within your cluster:
   grafana-1605733331.monitoring.svc.cluster.local
    # Get the Grafana URL to visit by running these commands in the same shell:
     export POD_NAME=$(kubectl get pods --namespace monitoring -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=grafana-1605733331" -o jsonpath="{.items[0].metadata.name}")
     kubectl --namespace monitoring port-forward $POD_NAME 3000
# 3. Login with the password from step 1 and the username: admin

# check status and versions.
helm ls --namespace monitoring
kubectl get pods -n monitoring
# then create a data source in grafana for prometheus, use the FQDN from STEP 32 ==> grafana-1605733331.monitoring.svc.cluster.local
# IMPORT  this dashboard:
https://grafana.com/grafana/dashboards/11074


# to integrate GRAFANA with AZURE MONITOR, create an SP:
https://grafana.com/grafana/plugins/grafana-azure-monitor-datasource
az ad sp create-for-rbac -n "http://localhost:3000"
Creating a role assignment under the scope of "/subscriptions/47cec5c4-2ef0-4cf0-aaff-289188420f41"
      AppId                                 DisplayName     Name                   Password                            Tenant
      ------------------------------------  --------------  ---------------------  ----------------------------------  ------------------------------------
      c4a948c2-61df-4d6a-b9c7-be7d2ba1fb56  localhost:3000  http://localhost:3000  q8051iJe-5t1NcwmF_s5EJgr5QHm0G35_M  138b68c0-c6fd-41fc-93aa-e26a15fd14a8

kubectl top pods --all-namespaces

kubectl describe node aks-nodepool1-14499335-vmss000000



# AZURE MONITOR FOR CONTAINERS STUFF

https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-enable-existing-clusters
https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-overview
https://docs.microsoft.com/en-us/azure/azure-monitor/insights/containers
https://docs.microsoft.com/en-us/azure/azure-monitor/learn/quick-collect-linux-computer
https://github.com/helm/charts/tree/master/incubator/azuremonitor-containers
https://github.com/Microsoft/OMS-docker/blob/ci_feature_prod/docs/solution-onboarding.md


# FOR AKS_ENGINE STUFF (UNMANAGED CLUSTERS)

https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/attach-monitoring-tags.md
https://github.com/Microsoft/OMS-docker/blob/ci_feature_prod/docs/solution-onboarding.md


# Attach tags using Azure CLI

az resource list --resource-type Microsoft.OperationalInsights/workspaces
or
az resource show -g aq-k8s-engine-rg -n aq-k8s-logs --resource-type Microsoft.OperationalInsights/workspaces


https://github.com/microsoft/Docker-Provider/blob/ci_prod/scripts/onboarding/attach-monitoring-tags.md#attach-tags-using-azure-cli

curl -sL https://raw.githubusercontent.com/microsoft/Docker-Provider/ci_prod/scripts/onboarding/aksengine/kubernetes/AddMonitoringOnboardingTags.sh | bash -s "AzureCloud" "28c473e4-ad30-46cd-b669-f92768ef2cc4"  "aq-k8s-engine-rg"  "/subscriptions/28c473e4-ad30-46cd-b669-f92768ef2cc4/resourceGroups/aq-k8s-engine-rg/providers/Microsoft.OperationalInsights/workspaces/aq-k8s-logs" "my-aks-engine-cluster"

https://github.com/helm/charts/tree/master/incubator/azuremonitor-containers

# this repo at google is old and has been deprecated, you will get errors about this if you add the repo
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
helm install --name azmon-containers-release-1 \
--set omsagent.secret.wsid=603cb6f9-4812-478e-ba4d-c7e0f7762284,omsagent.secret.key=<your_workspace_key>,omsagent.env.clusterName=<my_prod_cluster>  incubator/azuremonitor-containers
