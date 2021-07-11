# Coaches Guide – Containers

This guide is only meant to be a reference. Please **do not** rely on this guide in place of completing the challenges before coaching.

1. [OpenHack Introduction for Coaches](#OpenHack---An-Introduction-for-Coaches)
1. [Preparing to Coach the Containers OpenHack](#Preparing-to-Coach-the-Containers-OpenHack)
    1. [Build Foundational Knowledge](#Build-Foundational-Knowledge)
    1. [Complete the OpenHack Challenges](#Complete-the-OpenHack-Challenges)
    1. [Prepare to Support Your Team](#Prepare-to-Support-Your-Team)
1. [General Expectations](#General-Expectations)
1. [General Troubleshooting Tips](#General-Troubleshooting-Tips)
1. [Tooling Prerequisites](#Tooling-Prerequisites)
1. [Challenge 1](#Challenge-1)
    1. [POI](#POI)
    1. [Docker Networking](#Docker-Networking)
    1. [SQL](#SQL)
    1. [Challenge 1 Follow Up Questions](#Challenge-1-Follow-Up-Questions)
1. [Challenge 2](#Challenge-2)
    1. [Challenge 2 Follow Up Questions](#Challenge-2-Follow-Up-Questions)
1. [Challenge 3](#Challenge-3)
    1. [AAD and Service Principals](#AAD-and-Service-Principals)
    1. [Ensuring Connectivity to an Existing VNET](#Ensuring-Connectivity-to-an-Existing-VNET)
    1. [Challenge 3 Follow Up Questions](#Challenge-3-Follow-Up-Questions)
1. [Challenge 4](#Challenge-4)
    1. [Ingress](#Ingress)
    1. [Helm](#Helm)
    1. [Secret Store CSI driver](#Secret-Store-CSI-driver)
    1. [AAD Integration & RBAC](#AAD-Integration-&-RBAC)
    1. [Challenge 4 Follow Up Questions](#Challenge-4-Follow-Up-Questions)
1. [Challenge 5](#Challenge-5)
    1. [Container Insights](#Container-Insights)
    1. [Prometheus](#Prometheus)
    1. [Grafana](#Grafana)
    1. [Triggering alerts](#Triggering-alerts)
    1. [Challenge 5 Follow Up Questions](#Challenge-5-Follow-Up-Questions)
1. [Challenge 6](#Challenge-6)
    1. [Pod Identity](#Pod-Identity)
1. [Challenge 7](#Challenge-7)
1. [Challenge 8](#Challenge-8)
    1. [LinkerD](#LinkerD)
    1. [Istio](#Istio)

## OpenHack - An Introduction for Coaches

OpenHack is a hands-on experience in which participants work in team to solve a series of coding challenges based on the requirements and resources provided. It is *not* designed to be delivered as a traditional training session or hands-on lab.

Your role as a coach is to encourage your team to work together to solve the challenges for themselves. You may provide critical assessment of their ideas and suggest potential avenues of exploration when they get stuck; but you should *not* provide solutions to the challenges. The outcome that customers value most from OpenHack is the satisfaction of having solved the challenges for themselves, and the in-depth learning that comes from that experience.

So what *is* expected of a coach?

- Facilitating intra- (and inter-) team work to solve the challenges. Lead team discussions, being sure to include all team members. Act as a 'sounding board' for team brainstorming while helping the team focused on the challenges and their success criteria.
- Unblocking technical issues that are not directly related to the challenges (for example, command line syntax or network authentication issues).
- Explaining underlying concepts where necessary. Participants can often find the code they need in documentation or on sites like StackOverflow; but they may have difficulty understanding what it is that they’re actually doing.
- Managing team sentiment and morale – the challenges are designed to be, er, challenging; and as a result, some participants may experience frustration at times during the OpenHack. Coaches need to be sensitive to the mood of the team and help steer them towards a breakthrough by asking leading questions, proposing alternative avenues of exploration, or just suggesting a coffee break.
- Validating challenge solutions against the specified criteria, and approving team progress through the challenges; being sure to celebrate the team’s successes along the way!

## Preparing to Coach the Containers OpenHack

Before coaching the Containers OpenHack, you should ensure you are fully prepared.

### Build Foundational Knowledge

Coaches for the Containers OpenHack require a knowledge of the fundamentals of containers and Kubernetes, and familiarity with tools commonly used when working with Kubernetes clusters. [https://aka.ms/KubernetesFoundation](https://aka.ms/KubernetesFoundation) has some good resources.

For a quick resource to leverage at your tables, feel free to reference this great doc created by a previous coach, Julien Corioland: [https://github.com/jcorioland/k8s-fundamentals](https://github.com/jcorioland/k8s-fundamentals)

### Complete the OpenHack Challenges

Ideally, you should attend the Containers OpenHack as a participant before coaching it. If this is not possible, you should complete all the challenges on your own. You should try to complete the challenges using only the instructions that the OpenHack participants will have, but you can also use the notes in the rest of this guide for more detailed information and context that may help you coach your team during the OpenHack itself.

*Note: the `solutions-files` folder includes solutions for paths that we anticipate being the most common choices. As a coach, you must allow a team to choose alternative paths, if the success criteria are met. It is not expected that a coach will have deep expertise in all possible paths, nor expert level command of all possible syntax. Coaches can lean on each other for help if a team chooses a less familiar path.*

*If no coach has experience with the team’s chosen path, this is a growth opportunity for the coach to join in and learn with the team. As a coach, feel free to reference the contents of this folder to double check syntax when necessary.*

*If a solutions folder is provided for this OpenHack, these solutions were used to validate the challenges. Obviously, you might find this useful; but we encourage you to try to solve the challenges for yourself before referring to the solutions.*

### Prepare to Support Your Team

The guidance in the rest of this document incorporates insights from the content authors that describe the learning objectives for the challenges and how they are intended to be used, as well as hints and tips from previous coaches who have successfully helped customers as they work through the challenges. Be sure to read through these notes, as they will help you ensure your team has a positive and successful OpenHack experience.

## General Expectations

The OpenHack consists of a series of challenges that reflect a logical order for implementing a modernized architecture using Azure Kubernetes Service, while adopting and applying common scenarios. In general, the later challenges are more difficult than the earlier ones; but this is not always the case.

Most teams will **not** complete all the challenges within the time available. This is by-design (it’s better to have some stretch-goal challenges for experienced attendees who may get through the challenges unusually quickly than to run out of challenges partway through the event!)

As a general rule, the authors expect 80-90% of attendees to complete only the first 5 challenges within a 3-day event (an average of two challenges per-day) – if your team does that, they’ll have learned a great deal about implementing and operationalizing an AKS cluster! The remaining challenges represent additional scenarios that may be more advanced.

If your team does not reach the final challenge, at the end of the event you can unlock the remaining challenges and allow them to copy the challenge text and links. The OpenHack portal and associated Azure subscriptions will be deleted when the event ends, but attendees are welcome to use their own Azure subscription to continue working on the challenges on their own time provided they agree that *they will not publish the challenges or their solutions in any public location* (such as a GitHub repo or blog). We want future attendees to have a great OpenHack experience, and if it’s easy for them to find challenge solutions from previous attendees then they will not get the full benefit of having to work on the challenges for themselves.

## General Troubleshooting Tips

Teams are working with quite a few containers and different versions of containers. If something seems off, it may be a good idea to check if you have the most up to date image. When working locally, old versions of images, including base images, may be cached.

There are a few go-to kubectl commands when troubleshooting a Kubernetes cluster:

- `kubectl describe resourcetype/name` – Shows details of a specific resource. Good for troubleshooting resource specific problems. “Why is this deployment/pod failing to be created?”
- `kubectl logs running-podname` – Prints the logs for a container in a pod. Good for troubleshooting container-specific problems. “Is the container working as expected?” Use the -f option to steam the logs.
- `kubectl exec podname` – Execute a command in a container. Good to isolate behavior for a given container. “Can I access other containers from my container? What does the filesystem look like? Etc.”

## Tooling Prerequisites

Before participants get started with the challenges, you'll want to make sure their environment has the tools and setup to work with the environment. Review the [Getting Ready to Go](https://github.com/Microsoft-OpenHack/containers/blob/main/portal/en/Challenge-0.md). The **"Getting Ready to Go"** page shows the **two main methods for getting these tools in your environment**. You can either **install these tools on your local machine** or a machine in your environment; OR, you can **install via a Linux Virtual Machine (VM)**.

1. Make sure everyone has already setup their environment:
    a. [az-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) and they have run [az login](https://docs.microsoft.com/en-us/cli/azure/reference-index?view=azure-cli-latest#az-login)
    b. docker ([windows](https://docs.docker.com/docker-for-windows/install); [mac](https://docs.docker.com/docker-for-mac/install))
1. Installing `kubectx` and `kubens` (from [https://github.com/ahmetb/kubectx](https://github.com/ahmetb/kubectx)) on your path is *highly* recommended, especially for challenge 3 and later where switching namespaces becomes necessary

## Challenge 1

**Scenario goal:** Integration testing

The first challenge is designed to establish the docker images to be used for the remainder of the event. The goal of this challenge is to get the team to familiarize themselves with the containers they will be working with.

Team members may have questions about:

1. How [dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/) can be written and be compiled/run
1. How registries like [ACR](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task) work and how we can push/pull images from it

Users on domain-joined machines who experience issues switching to Docker for Linux (error trace shows unable to create DockerNAT Hyper-V virtual switch), need to allow Docker to initialize using a local account first. See instructions at [https://github.com/docker/for-win/issues/2090#issuecomment-553635614](https://github.com/docker/for-win/issues/2090#issuecomment-553635614)

Users who are trying to use the experimental WSLv2 integration need to enable the feature in the Docker settings as well as enable Docker WSLv2 integration for their specific distro.

### POI

POI needs to be deployed with the `Local` app development setting. This note is highlighted in the challenge.

### Docker Networking

- If attendees have issues with port permissions, make sure they are not mapping to system ports on the host (low numbers 0-1024, like 80) or trying to bind to a port already in use (by another docker container or something else like a tomcat server or proxy running locally). Note it's fine **and recommended** to map system ports like 80 on the **container side**, just don't map it to port 80 on the **host**. Docker ports are always `-p host_port:container_port`
- If attendees cannot connect to their container (except by IP address), read more about [docker bridge networking](https://docs.docker.com/network/bridge/) (name-based resolution) *hint: name-based resolution doesn't work on the default bridge network by design*

### SQL

[SQL Server on DockerHub](https://hub.docker.com/_/microsoft-mssql-server)

- Before running the `dataload` image, you *will* need to create a database in your local server
- If you're experiencing connection issues, double check:
    - SQL Server container is running (`docker ps`)
    - You can exec in & log in to the server (`sqlcmd`)
    - You have created the database
    - You are using the correct address / container name (run a `docker inspect` to get the container's properties)
    - the port, if specified, is formatted {name},{port} (**not** {name}:{port} on the `sqlcmd` command)

### Challenge 1 Follow Up Questions

Here are some examples of questions to ask to validate understanding of certain concepts that will be helpful for future challenges:

- What are some commands you can use to troubleshoot/debug a container?
- How do you get logs? Where do the logs come from?
- How does the POI and SQL containers communicate locally?
- How do you imagine this working in the cloud?
- What can running two local containers be used for? (Integration testing during build step)

## Challenge 2

**Scenario goal:** Implement a “proof of concept” to learn about basic kubernetes concepts (Deployment, Service, Secrets)

The second challenge is to familiarize participants with Kubernetes concepts by deploying services to a Kubernetes cluster. They are asked to deploy the containers from the previous challenge to a cluster and ensure connectivity between services.

Participants who are new to Kubernetes should familiarize themselves with fundamental concepts. It would be good to spend some time having a high-level discussion on how Kubernetes works.

Troubleshooting Tips and FAQs:

- A default AKS cluster should be sufficient for this challenge
- If you're hitting image pull errors, ensure that the cluster service principal has pull [access to the ACR](https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration?tabs=azure-cli) (ie: see `--attach-acr`).
- To test that APIs are reachable, you can use `kubectl port-forward`
- Refer to the TripViewer readme to see the environment variables needed for service communication
- If you are not seeing updated imaged being reflected in your cluster, set the `imagePullPolicy` to `Always` in the deployment and scale or delete the pod to repull the image
- Use [Kubernetes DNS resolution](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) to address your services (i.e. `my-api.svc.cluster.local`)

### Challenge 2 Follow Up Questions

Here are some examples of questions to ask to validate understanding of certain concepts that will be helpful for future challenges:

- Can you talk through the difference between a Pod, Deployment, and Service?
- What are some commands that are useful to troubleshoot/debug?

## Challenge 3

**Scenario goal:** Configuring user access to cluster and managing IP address space

In this challenge, the team is required to think about how members of a team will access the cluster while configuring a cluster to meet those security requirements.

The main activities in this challenge is deploying a cluster integrated with Azure Active Directory (AAD), planning network space in an existing network, and controlling access to the Kubernetes API server.  **You will need to deploy a new cluster, and cannot integrate AAD with your existing cluster**.

Once the AAD-enabled cluster is deployed, you will need admin credentials to configure the initial permissions (follow AKS+AAD-integration docs).
To obtain Cluster Admin credentials, use `az aks get-credentials -g resourceGroup -n clusterName --admin`

### AKS managed Azure Active Directory integration

AKS-managed Azure AD integration is designed to simplify the Azure AD integration experience, where users were previously required to create a client app, a server app, and required the Azure AD tenant to grant Directory Read permissions. In the new version, the AKS resource provider manages the client and server apps for you.

Cluster administrators can configure Kubernetes role-based access control (Kubernetes RBAC) based on a user's identity or directory group membership. Azure AD authentication is provided to AKS clusters with OpenID Connect. OpenID Connect is an identity layer built on top of the OAuth 2.0 protocol. For more information on OpenID Connect, see the [Open ID connect documentation](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-protocols-oidc).

Learn more about the Azure AD integration flow on the [Azure Active Directory integration concepts documentation](https://docs.microsoft.com/en-us/azure/aks/concepts-identity#azure-ad-integration).

### Legacy Azure AD Integration

#### AAD and Service Principals

Teams often find it difficult to keep track of the various service principals created and what they are used for. When running `az ad sp create-for-rbac`, consider guiding the team to use the `--name` flag to give tbe service principal a human-readable name for later (if you do not, `azure-cli-datestring` is used instead and you end up with many of those)

[This diagram of the device code protocol](https://docs.microsoft.com/azure/active-directory/develop/v2-oauth2-device-code#protocol-diagram) may be useful to help explain the auth flow.

Note that the following command will not work in Cloud Shell: `az ad app permission admin-consent --id $APPID`. Azure AD portal blade can be used instead to grant consent to the app.

#### Azure RBAC versus Kubernetes RBAC

In this and the following challenge, attendees will be managing both Azure RBAC rules and Kubernetes RBAC. It is important to understand the distinction and ensure that attendees get an understanding of which of these two sets of rules manages which scope.

##### Azure RBAC

Azure RBAC manages view, edit, and access management roles to the AKS resource in Azure. There are two AKS-specific roles in Azure in addition to standard Reader, Owner, Contributor, etc roles.

- `Azure Kubernetes Service Cluster User`: Can access the Kubernetes api-server after using `az aks get-credentials` to get user credentials
- `Azure Kubernetes Service Cluster Admin`: Can access the Kubernetes api-server *and bypass any authentication checks that are otherwise required*. Cluster Administrator role in Azure allows users to call `az aks get-credentials --admin`, where the admin flag is what allows for bypassing authentication.

##### Kubernetes RBAC

Kubernetes RBAC manages access within the cluster. In a "default" cluster, this applies largely to service accounts, since Kubernetes has no built-in concept of users. With AAD-integration, this applies to users and groups as well. **It is important to note that the cluster-admin ClusterRole in Kubernetes is entirely separate from the AKS Cluster Admin role in Azure.**

#### Ensuring Connectivity to an Existing VNET

Teams are required to demonstrate connectivity to an existing VM on the VNET. There are several ways to demonstrate connectivity to the internal vm, but the easiest is likely using the `kubectl exec` command to shell into a pod on your cluster and attempting to `ping` the VM's vnet-internal IP.

### Challenge 3 Follow Up Questions

Here are some examples of questions to ask to validate understanding of certain concepts that will be helpful for future challenges:

- What is the difference between Pod CIDR and Service CIDR?  Do Pods share IP space with the Nodes?
- What is the difference between a ClusterRole and Role? Between a Role the RoleBinding?

## Challenge 4

**Scenario goal:** Production deployment – Where to keep secrets, how to configure RBAC and set up ingress

Now that teams have a cluster with the necessary configuration, it’s time for them to deploy their application, secure their secrets, lock down user access, and appropriately configure ingress to simulate load onto the cluster.

### Ingress

There are several options when configuring the ingress of your controller as mentioned in the [provided reference](https://docs.microsoft.com/en-us/azure/aks/concepts-network#ingress-controllers). The most common ones are:

- NGINX (easily installed with helm)
- [HTTP application routing](https://docs.microsoft.com/en-us/azure/aks/http-application-routing)

If using the helm chart for nginx for ingress, the following values file will help sort out SSL redirect issues:

```yaml
controller:
  config:
    hsts: "false"
    ssl-redirect: "false"
```

### Helm

Helm chart issues? **`helm repo update`** before any more debugging

- Make sure to follow the steps to [install Helm on an RBAC-enabled cluster](https://docs.microsoft.com/en-us/azure/aks/kubernetes-helm#create-a-service-account)

### Secret Store CSI driver

- Make sure to follow the steps [Azure Key Vault Provider for Secrets Store CSI Driver](https://github.com/Azure/secrets-store-csi-driver-provider-azure)

### AAD Integration & RBAC

- There are built-in "view" and "edit" ClusterRoles that are worth utilizing for this
- If attendees already have cluster credentials in their kubeconfig file, they won't be prompted to authenticate on cluster access. Have them either wipe the whole file or any cluster/context information related to this project, then get fresh credentials with `az aks get-credentials -g resourceGroup -n clusterName` (**no `--admin` flag**)

### Challenge 4 Follow Up Questions

Here are some examples of questions to ask to validate understanding of certain concepts that will be helpful for future challenges:

- Why did we need to set up ingress?
- What are Kubernetes secrets? Discuss whether or not you think it’s truly secure.
- What are other use cases for locking down user access?

## Challenge 5

**Scenario goal:** Observability – Learn to identify where to find important metrics and learn to debug issues happening in cluster using metrics.

In this challenge teams are asked to get to know their clusters more deeply. They are required to deploy a foreign application into their cluster, observe and react accordingly. Teams are free to use the tools they are most comfortable with. We provide references for Container Insights or Prometheus and Grafana

Two of the most popular options are Container Insights and Prometheus

- Container Insights is good for those who are familiar and comfortable with Azure Monitor and the log analytics query language
- Prometheus and Grafana is a good option for those who may want to remain cloud agnostic.   This is the easier solution given the two options as there is a bigger community and dashboard for Grafana that solve most of the questions.

> NOTE: If using the helm chart for nginx for ingress, Prometheus-format metrics can be automatically exported by setting the value `controller.metrics.enabled=true`.

### Container Insights

- It may take some time before you start seeing metrics in the UI
- If your team wants to setup the livedata preview, follow the guidance here: [https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-livedata-setup#client-registration-reconfiguration](https://docs.microsoft.com/en-us/azure/azure-monitor/insights/container-insights-livedata-setup#client-registration-reconfiguration)

### Prometheus

- **You definitely do not need to set up Prometheus from scratch. You should not need to write any yaml beyond maybe a short values file for helm**
    - [Monitoring the Ingress Controller Using Prometheus](https://github.com/nginxinc/kubernetes-ingress/blob/master/docs/prometheus.md)
    - [Example of using Azure Monitor to scrape Prometheus metrics from NGINX](https://gist.github.com/vyta/d13151c7031054f998a7efc99ae706d0)
- There are multiple options for prometheus installation on kubernetes
    - [Kube-Prometheus-Stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
    - [Prometheus](https://github.com/prometheus-community/helm-charts)
- Both versions of Prometheus as well as Grafana can be installed via Helm

### Grafana

- [Grafana helm chart](https://github.com/grafana/helm2-grafana)
- Depending on your Prometheus install, Grafana may come with it (& may even come with your Prometheus install configured as a data source)
- make sure to set the admin password in the values - otherwise, any release upgrade will create a new password secret, which gets annoying

### Triggering alerts

This is one helpful one-liner to trigger the alarms on the insurance service:

```bash
seq 1 <numberofrequests> | xargs -n1 -P3 bash -c 'i=$0; url="http://<insurance-endpoint>"; curl -O -s $url'
```

Example:

```bash
seq 1 2000 | xargs -n1 -P3 bash -c 'i=$0; url="http://51.140.1.2/insurance"; curl -O -s $url'
```

### Challenge 5 Follow Up Questions

Here are some examples of questions to ask to validate understanding of certain concepts that will be helpful for future challenges:

- What is the difference between the pull and push models for Metrics?
- What are the key metrics do you should collect?

## Challenge 6

At this point, teams have done a lot to secure their cluster. This challenge allows teams to take a deeper look at the security of their cluster by further restricting access to the Kubernetes API server using IP whitelisting and service accounts, prevent unrelated pods from communicating with one another using pod security policies, restrict networking using network policies, and further lock down access to secrets using Managed Service Identities instead of Service Principals.

### Pod Identity

Take some time to understand the different components when configuring pod identity. Often, when participants see yaml or code, they start to copy and paste before reading any of the documentation, particularly during this challenge. If you see this, slow them down. There are a few moving pieces and it’s easy to miscopy something and paste it in the wrong place

- For user-assigned MSI, the cluster service principal needs to be granted the `Managed Identity Controller` role on the scope of the MSI.
- Pod ID installs two main components on the cluster - the managed identity controller (MIC) and the node managed identity (NMI) daemonset. looking on logs on those can help debug
- For more debugging, there's a [Debugging](https://github.com/Azure/aad-pod-identity/wiki/Debugging) page on the pod ID wiki

## Challenge 7

In this challenge, teams need to incorporate a Windows workload into their cluster. This means they will need multiple node pools enabled on their cluster, which requires the team to re-create their cluster. Teams may find this to be tedious, but since they’ve already done the bulk of the work in previous challenges, only minor tweaks to the previous commands are needed to create a new cluster. Redeployment of the app should largely be the same except for updating the container to tripviewer2 with new environment vars and creating the new windows deployment.

This challenge does not go into deeper Windows Container topics that might be of interest to customers looking to use containers as part of their "modernization/lift&shift/hybrid network" projects. Examples of topics that we aren't addressing directly but may come up are:

1. Differences between Windows container types (Core, Nano and Windows)
1. Granting Access to on-prem resources protected with Active Directory with Group Managed Service Accounts (GMSA)
1. Application functionality on Windows Core Containers, particularly around containerizing commonly used Windows Server Services.
1. Network planning for intergrating Kubernetes and AKS with existing VNETs, peered VNETs and Express Route.

## Challenge 8

In this challenge, teams are required to implement a service mesh solution. We give references to LinkerD and Istio. It is up to the team to decide which they’d like to go with.

LinkerD is simpler to set up and is lightweight in comparison to Istio, which requires a more involved setup but has a fuller suite of capabilities.
The challenge is solvable with either option, it’s up to your team to decide what they would like to spend time on.

### LinkerD

[Linkerd install and set up](https://linkerd.io/2/getting-started/)

Add linkerd annotations to all deployments in a namespace:

```bash
kubectl get -n {namespace} deploy -o yaml \
  | linkerd inject - \
  | kubectl apply -f -
```

Check mutual TLS: `linkerd edges` to see connections between resources.

[Using Linkerd with Ingress](https://linkerd.io/2/tasks/using-ingress/index.html)

Generating Service Profiles (Linkerd CRD for managing requests with more specificity):

[Setting up Service Profiles](https://linkerd.io/2/tasks/setting-up-service-profiles/)

All the APIs we use have Swagger documentation, which can be used to auto-generate a Service Profile - you can either find the link to where the Swagger file is hosted for each API, or use the local `swagger.json` file in each APIs folder in the OpenHack repo.

[Retries and Timeouts](https://linkerd.io/2/features/retries-and-timeouts/)

### Istio

After enabling sidecar injection, make sure all currently running pods get restarted. Sidecar injection kicks in on pod scheduling, so currently running pods won't be affected.

Using Istio with Nginx (or another ingress controller) is possible (?) but not recommended. Istio provides an Ingress solution with its Gateway CRD. You'll want to essentially re-define your ingress rules as a VirtualService (another Istio CRD), then create a Gateway.

Ensuring HTTP liveness/readiness checks still work with Istio & mutual TLS (do one of the following):

- Add this annotation to each deployments pod spec: `sidecar.istio.io/rewriteAppHTTPProbers: "true"`
- During helm install, use the following value:

```yaml
sidecarInjectorWebhook:
  rewriteAppHTTPProbe: "true"
```

- Directly edit the `istio-sidecar-injection` config map and change the field `rewriteAppHTTPProve` to true.

Also possible: w/ Gatekeeper - Policy Controller for Kubernetes, use the annotation above in a policy that adds it to a given namespace. Probably best in production as it doesn't pollute deployment/pod annotations, but keeps annotation explicitly clear.

[Documentation on liveness/readiness probes with Istio](https://istio.io/docs/ops/app-health-check/)

Mutual TLS: You need to change the MeshPolicy (*another* Istio CRD) - either remove PERMISSIVE or replace it with STRICT - and add a DestinationRule (**another** Istio CRD) that enforces mutual TLS on all local traffic.
