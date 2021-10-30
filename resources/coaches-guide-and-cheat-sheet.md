# Coaches Guide – Containers

This guide is only meant to be a reference. Please **do not** rely on this guide in place of completing the challenges before coaching.

1. [OpenHack Introduction for Coaches](#OpenHack---An-Introduction-for-Coaches)
    1. [Coach Expectations](#Coach-Expectations)
1. [Preparing to Coach the Containers OpenHack](#Preparing-to-Coach-the-Containers-OpenHack)
    1. [Build Foundational Knowledge](#Build-Foundational-Knowledge)
    1. [Complete the OpenHack Challenges](#Complete-the-OpenHack-Challenges)
    1. [Prepare to Support Your Team](#Prepare-to-Support-Your-Team)
1. [General Expectations](#General-Expectations)
1. [General Troubleshooting Tips](#General-Troubleshooting-Tips)
    1. [Kubernetes Troubleshooting](#Kubernetes-Troubleshooting)
    1. [Make Your Work Repeatable](#Make-Your-Work-Repeatable)
1. [Tooling Prerequisites](#Tooling-Prerequisites)
1. [Challenge 1](#Challenge-1)
    1. [POI](#POI)
    1. [Docker Networking](#Docker-Networking)
    1. [SQL](#SQL)
    1. [Challenge 1 Follow Up Questions](#Challenge-1-Follow-Up-Questions)
1. [Challenge 2](#Challenge-2)
    1. [AKS and Azure](#AKS-and-Azure)
    1. [Kubernetes Networking Basics](#Kubernetes-Networking-Basics)
    1. [YAML and Deployed Resources](#YAML-and-Deployed-Resources)
    1. [Challenge 2 Follow Up Questions](#Challenge-2-Follow-Up-Questions)
1. [Challenge 3](#Challenge-3)
    1. [Working with Existing Address Space](#Working-with-Existing-Address-Space)
    1. [Enabling Azure AD](#Enabling-Azure-AD)
    1. [Azure RBAC versus Kubernetes RBAC](#Azure-RBAC-versus-Kubernetes-RBAC)
        1. [Azure RBAC](#Azure-RBAC)
        1. [Kubernetes RBAC](#Kubernetes-RBAC)
    1. [Ensuring Connectivity to an Existing VNET](#Ensuring-Connectivity-to-an-Existing-VNET)
    1. [Challenge 3 Follow Up Questions](#Challenge-3-Follow-Up-Questions)
1. [Challenge 4](#Challenge-4)
    1. [Ingress](#Ingress)
    1. [Helm](#Helm)
    1. [Secrets Store CSI Driver](#Secrets-Store-CSI-Driver)
    1. [Challenge 4 Follow Up Questions](#Challenge-4-Follow-Up-Questions)
1. [Challenge 5](#Challenge-5)
    1. [Setting Expectations for Challenge Completion](#Setting-Expectations-for-Challenge-Completion)
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
    1. [OSM](#OSM)

## OpenHack - An Introduction for Coaches

OpenHack is a hands-on experience in which participants work in team to solve a series of coding challenges based on the requirements and resources provided. It is *not* designed to be delivered as a traditional training session or hands-on lab.

Your role as a coach is to encourage your team to work together to solve the challenges for themselves. You may provide critical assessment of their ideas and suggest potential avenues of exploration when they get stuck, but you should *not* provide solutions to the challenges. The outcome that customers value most from OpenHack is the satisfaction of having solved the challenges for themselves, and the in-depth learning that comes from that experience.

### Coach Expectations

So what *is* expected of a coach?

- **Facilitating intra- (and inter-) team work** to solve the challenges. Lead team discussions, being sure to include all team members. Act as a 'sounding board' for team brainstorming while helping the team focused on the challenges and their success criteria. If you have team members with a wide range of skill levels, work to keep the more experienced members in sync with and talking to the less experienced members rather than leaving some people out of the loop.
- **Unblocking technical issues that are not directly related to the challenges** (for example, command line syntax or network authentication issues).
- **Explaining underlying concepts** where necessary. Participants can often find the code they need in documentation or on sites like StackOverflow, but they may have difficulty understanding what it is that they’re actually doing.
- **Managing team sentiment and morale** – the challenges are designed to be, er, challenging, and as a result, some participants may experience frustration at times during the OpenHack. Coaches need to be sensitive to the mood of the team and help steer them towards a breakthrough by asking leading questions, proposing alternative avenues of exploration, or just suggesting a coffee break.
- **Unblocking issues and concepts that have significantly stalled out the team**. Again, your role isn't to give them solutions, but if there's a significant block one on topic or problem, don't leave them to throw themselves against the same problem over and over! Guide them towards a helpful link, ask questions that lead them to see where there might be an error, or walk through some debugging to test out what's going wrong.
- **Validating challenge solutions** against the specified criteria and approving team progress through the challenges, being sure to celebrate the team’s successes along the way!
- **Helping the team regroup and look back** - at the end of every challenge, it can help to ask questions about core concepts from that challenge, walk through their solution together and look for areas for improvements, and generally make sure that every team member has a solid understanding of the concepts covered and the work done so far (this also helps keep the whole team in sync!). You can even do a quick retrospective after each challenge, or at the end of each day.

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

Most teams will **not** complete all the challenges within the time available. This is by design (it’s better to have some stretch-goal challenges for experienced attendees who may get through the challenges unusually quickly than to run out of challenges partway through the event!)

As a general rule, the authors expect 80-90% of attendees to complete only the first 5 challenges within a 3-day event (an average of two challenges per-day) – if your team does that, they’ll have learned a great deal about implementing and operationalizing an AKS cluster! The remaining challenges represent additional scenarios that may be more advanced.

If your team does not reach the final challenge, at the end of the event you can unlock the remaining challenges and allow them to copy the challenge text and links. The OpenHack portal and associated Azure subscriptions will be deleted when the event ends, but attendees are welcome to use their own Azure subscription to continue working on the challenges on their own time provided they agree that *they will not publish the challenges or their solutions in any public location* (such as a GitHub repo or blog). We want future attendees to have a great OpenHack experience, and if it’s easy for them to find challenge solutions from previous attendees then they will not get the full benefit of having to work on the challenges for themselves.

## General Troubleshooting Tips

Teams are working with quite a few containers and different versions of containers. If something seems off, it may be a good idea to check if you have the most up to date image. When working locally, old versions of images, including base images, may be cached.

### Kubernetes Troubleshooting

There are a few go-to kubectl commands when troubleshooting a Kubernetes cluster:

- `kubectl describe resourceType/name` – Shows details of a specific resource. Good for troubleshooting resource specific problems. “Why is this deployment/pod failing to be created?”
- `kubectl logs runningPodName` – Prints the logs for a container in a pod. Good for troubleshooting container-specific problems. “Is the container working as expected?” Use the -f option to stream the logs.
- `kubectl exec podName` – Execute a command in a container. Good to isolate behavior for a given container. “Can I access other containers from my container? What does the filesystem look like? Etc.”
- `kubectl port-forward resourceType/name localPort:remotePort` forwards a port from a cluster resource to your local machine. Good for troubleshooting network issues. "Can I view the UI from the pod's port? What about the service's? Or the ingress?"

### Make Your Work Repeatable

There are multiple points in the hack where attendees will want or need to create a new AKS cluster. **Recommend that they script out their actions, particularly Azure resource deployment/interaction.** This gives them a reference point if they need to backtrack and allows them to repeat previous work much more easily. This also means it's preferable to work with the Azure CLI and **not the portal**. The portal can be useful for *finding* resources, but it limits creation and manipulation to manual, hard to document processes.

## Tooling Prerequisites

Before participants get started with the challenges, you'll want to make sure their environment has the tools needed to complete the hack and interact with Azure, Docker, Kubernetes, and more. Review the Getting Ready to Go section (Challenge 0) which has **multiple methods for setting up a development environment**.

Some additional tips:

1. Installing `kubectx` and `kubens` (from [https://github.com/ahmetb/kubectx](https://github.com/ahmetb/kubectx)) on your path is *highly* recommended, especially for challenge 3 and later where switching namespaces becomes commonplace.
1. For attendees using VS Code, the [Kubernetes extension](https://code.visualstudio.com/docs/azure/kubernetes) can help scaffold out YAML files for deployments, services, etc. This can speed up the initial microservice deployment. Make sure your team is still thinking about what they're putting in place, though! Walk through a deployment or service YAML file and talk about the fields that have been filled in by the auto-creation tool.

It's heavily recommended that the team share a git repo in order to collaborate. They can fork the source code repo for the hack or create a new repo, but in either case you should recommend they make it **private** in order to align with the requirement that solutions not be shared publicly.

## Challenge 1

**Scenario goal:** Integration testing

The first challenge is designed to establish the docker images to be used for the remainder of the event. The goal of this challenge is to get the team to familiarize themselves with the containers they will be working with.

Team members may have questions about:

1. How [dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/) can be written and be compiled/run
1. How registries like [ACR](https://docs.microsoft.com/en-us/azure/container-registry/container-registry-tutorial-quick-task) work and how we can push/pull images from it

Users on domain-joined machines who experience issues switching to Docker for Linux (error trace shows unable to create DockerNAT Hyper-V virtual switch), need to allow Docker to initialize using a local account first. See instructions at [https://github.com/docker/for-win/issues/2090#issuecomment-553635614](https://github.com/docker/for-win/issues/2090#issuecomment-553635614)

Users who are trying to use Docker's WSL2 integration need to enable the feature in the Docker settings as well as enable Docker WSL2 integration for their specific distro.

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

### AKS and Azure

- A default AKS cluster should be sufficient for this challenge
- If you're hitting image pull errors, ensure that the AKS cluster has [pull access to the ACR](https://docs.microsoft.com/en-us/azure/aks/cluster-container-registry-integration) (ie: see `--attach-acr`).

### Kubernetes Networking Basics

- To test that APIs are reachable, you can use `kubectl port-forward`
- Refer to the TripViewer readme to see the environment variables needed for service communication
- Use [Kubernetes DNS resolution](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/) to address your services (i.e. `my-api.svc.cluster.local`)
- For this challenge, it can be easier to deploy all of the components in the default namespace as it makes cluster DNS addressing easier (i.e. `trips` instead of `trips.api` or `trips.api.svc.cluster.local`)

### YAML and Deployed Resources

- If you are not seeing updated images being reflected in your cluster, set the `imagePullPolicy` to `Always` in the deployment and scale the deployment or delete the pod to force another pull of the image
- For this challenge, minimal YAML files are ok. Many of these components are nice to have, and can be a good discussion to have with the team, but are not essential:
    - Liveness and readiness probes
    - Resource limits (relevant in Challenge 5)
    - Service accounts (relevant in Challenge 6)
- The deployments and services can be set up to support both http (port 80) and https (port 443) traffic for the microservices, but it's not a key focus at this point.
- We'll use Kubernetes Secrets here not because they are secure (by default they offer very limited security) but because they help ramp attendees up to the secret management and access concepts introduced later

### Challenge 2 Follow Up Questions

Here are some examples of questions to ask to validate understanding of certain concepts that will be helpful for future challenges:

- Can you talk through the difference between a Pod, Deployment, and Service?
- What are some commands that are useful to troubleshoot/debug?
- What are Kubernetes secrets? Discuss whether or not you think it’s truly secure.

## Challenge 3

**Scenario goal:** Configuring user access to cluster and managing IP address space

In this challenge, the team is required to think about how members of a team will access the cluster while configuring a cluster to meet security requirements.

The main activities in this challenge is deploying a cluster with Azure AD enabled, planning network space in an existing network, and controlling access to the Kubernetes API server. **It's highly likely you will need to deploy a new cluster to meet networking requirements.**

### Working with Existing Address Space

Some teams may run into the following snag: the sample address spaces used for the cluster service CIDR in the Azure CNI documentation conflict with the VNet and `vm-subnet` deployed into their hack environment. This may cause immediate errors, or confusing issues later on. If they don't realize this on their own, it's highly recommended to walk them through the conflict and the sections of documentation that note that this is inadvisable.

### Enabling Azure AD

After enabling Azure AD on your cluster, you may find yourself with limited access after a standard `az aks get-credentials` command. You'll need admin access (read below about the `--admin` flag) to the cluster in order to set up the Kubernetes RBAC necessary to give yourself and your team access.

Part of setting up AAD authentication for the cluster involves creating an AAD group which will be granted admin access. If every member of the team is added to this group, they should not face access problems and should not need to use the admin flag.

### Azure RBAC versus Kubernetes RBAC

In this and the following challenge, attendees will be managing both Azure RBAC and Kubernetes RBAC. It is important to understand the distinction and ensure that attendees get an understanding of which of these two sets of rules manages which scope.

#### Azure RBAC

Azure RBAC manages view, edit, and access management roles to the AKS resource in Azure. There are two AKS-specific roles in Azure in addition to standard Reader, Owner, Contributor, etc roles.

- `Azure Kubernetes Service Cluster User`: Can access the Kubernetes api-server after using `az aks get-credentials` to get user credentials
- `Azure Kubernetes Service Cluster Admin`: Can access the Kubernetes api-server *and bypass any authentication checks that are otherwise required*. Cluster Administrator role in Azure allows users to call `az aks get-credentials --admin` - the admin flag is the piece of the command that allows for bypassing authentication. **Use this sparingly.**

If attendees already have cluster credentials in their kubeconfig file, they won't be prompted to authenticate on cluster access. Have them either wipe the whole file or any user/context information related to this project, then get fresh credentials with `az aks get-credentials` **with no `--admin` flag**.

#### Kubernetes RBAC

Kubernetes RBAC manages access *within* the cluster. In a "default" cluster, this applies largely to service accounts, since Kubernetes has no built-in concept of users. With Azure AD enabled, this applies to Azure users and groups as well. **It is important to note that the cluster-admin ClusterRole in Kubernetes is entirely separate from the Azure Kubernetes Service Cluster Admin role in Azure.**

- There are built-in "view" and "edit" ClusterRoles that are worth utilizing for web- and api- dev access - no need to write your own!
- When testing out web- and api-dev access, attendees may have granted these users access via Kubernetes RBAC (ability to interact with resources *within* the cluster) without additionally giving them access via Azure RBAC (ability to view and get credentials for the cluster via Azure CLI or Portal). Similarly to what's mentioned above, test access by removing any credentials in the kubeconfig file and rerunning `az aks get-credentials` *while logged in as the web- or api-dev user*.

#### Ensuring Connectivity to an Existing VNET

Teams are required to demonstrate connectivity to an existing VM on the VNET. There are several ways to demonstrate connectivity to the internal vm, but the easiest is likely using the `kubectl exec` command to shell into a pod on your cluster and attempting to `ping` the VM's vnet-internal IP.

### Challenge 3 Follow Up Questions

Here are some examples of questions to ask to validate understanding of certain concepts that will be helpful for future challenges:

- What is the difference between Pod CIDR and Service CIDR? Do pods share IP space with the nodes?
- What is the difference between a ClusterRole and Role? Between a Role and a RoleBinding?
- Which parts of cluster access are managed by Azure RBAC? Kubernetes RBAC?
- What are other use cases for locking down user access?

## Challenge 4

**Scenario goal:** Production deployment – Where to keep secrets, how to set up ingress

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

### Secrets Store CSI Driver Azure Provider

- Follow the linked Microsoft documentation; the standalone github pages docs offer more options than are necessary and may be confusing
- Use managed identities, **not** Service Principals or Pod Identity
    - Service Principal requires a secret stored on the cluster - challenge requirements should push attendees away from this
    - Pod Identity adds complexity for minimal gain at the moment, and will be utilized later (Challenge 6) in a clearer use
- If your team is having trouble with this, there's lots of small details that need to match:
    - KeyVault secret names can't contain underscores, so the `objectAlias` field needs to be set in the SecretProviderClass yaml to map the secrets to their expected names
    - The SecretProviderClass yaml needs to be in the same namespace as the API microservices
    - The volume mount point in each microservice yaml should be set to the expected value (`/secrets`), or that value should be customized via environment variables
    - The volume mount name should match the volume name
    - The volumeAttributes secretProviderClass field should match the SecretProviderClass name (despite the slightly misleading docs examples, this *doesn't* have to be the keyvault name)

### Challenge 4 Follow Up Questions

Here are some examples of questions to ask to validate understanding of certain concepts that will be helpful for future challenges:

- Why did we need to set up ingress?
- Are there still security risks to the new Secret management solution? Compare it to secrets written directly as environment variables in deployment yaml and Kubernetes Secrets

## Challenge 5

**Scenario goal:** Observability – Learn to identify where to find important metrics and learn to debug issues happening in cluster using metrics.

In this challenge teams are asked to get to know their clusters more deeply. They are required to deploy a foreign application into their cluster, observe and react accordingly. Teams are free to use the tools they are most comfortable with. Two of the most popular options are Container Insights or Prometheus and Grafana.

- Container Insights is good for those who are familiar and comfortable with Azure Monitor and the log analytics query language
- Prometheus and Grafana is a good option for those who may want to remain cloud agnostic. This is the easier solution given the two options as there is a bigger community and number of available dashboards for Grafana that solve most of the questions.

### Setting Expectations for Challenge Completion

This challenge can feel very open-ended for both teams and coaches. A good approach is to focus on understanding and ability to find answers. The quality of the resulting dashboard isn't the most important, but rather that it's populated with data that allows them to answer the questions presented in the challenge quickly and with minimal effort.

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

> NOTE: If using the helm chart for nginx for ingress, Prometheus-format metrics can be automatically exported by setting the value `controller.metrics.enabled=true`.

### Grafana

- [Grafana helm chart](https://github.com/grafana/helm-charts/tree/main/charts/grafana)
- Depending on your Prometheus install, Grafana may come with it (& may even come with your Prometheus install configured as a data source)

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
- What are the key metrics you should collect?

## Challenges 6 through 8

Moving on from Challenge 5, you will notice *3* new Challenges unlock. Challenges 6, 7, and 8 are unordered and can be tackled according to team preference. Pick the topic or topics of most interest and go from there - though be aware that if your team attempts to split up and tackle two challenges at once that they will likely want to work on separate clusters. Aspects of these challenges can cause conflicts with each other if they're being updated simultaneously.

## Challenge 6

At this point, teams have done a lot to secure their cluster. This challenge allows teams to take a deeper look at the security of their cluster by further restricting access to the Kubernetes API server using IP whitelisting and service accounts, prevent unrelated pods from communicating with one another using pod security policies, restrict networking using network policies, and further lock down access to secrets using Managed Service Identities instead of Service Principals.

### Pod Identity

Take some time to understand the different components when configuring pod identity. Often, when participants see yaml or code, they start to copy and paste before reading any of the documentation, particularly during this challenge. If you see this, slow them down. There are a few moving pieces and it’s easy to copy something and paste it in without fully comprehending its actions.

- There are multiple documentation paths, if attendee follow the MSFT docs path. It should be smooth sailing, and this is the desirable path, however if attendee follow repo docs, there will be some inconsistency and more configuration.

    - [Microsoft Docs Pod Id](https://docs.microsoft.com/en-us/azure/aks/use-azure-ad-pod-identity)
    - eb sure attendees adjust the deployment yaml to include the label `aadpodidbinding`, it should be placed under `spec.template.metadata.labels`. [Example](https://azure.github.io/aad-pod-identity/docs/best-practices/deploymenthttpskubernetesiodocsconceptsworkloadscontrollersdeployment)

    - _Noticeable problem area_: knowing to create an identity in the SQL DB that corresponds to the managed identity utilized by the Pod Identity. [Add identity to SQL DB](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/tutorial-windows-vm-access-sql)

- Trip service has been modified to take in 2 new `env` variables; `CREDENTIAL_METHOD` & `IDENTITY_CLIENT_ID`.

    - `CREDENTIAL_METHOD` should be set to `managed_identity` to complete the challenge

## Challenge 7

In this challenge, teams need to incorporate a Windows workload into their cluster. This means they will need multiple node pools enabled on their cluster, which requires the team to re-create their cluster. Teams may find this to be tedious, but since they’ve already done the bulk of the work in previous challenges, only minor tweaks to the previous commands are needed to create a new cluster. Redeployment of the app should largely be the same except for updating the container to tripviewer2 with new environment vars and creating the new windows deployment.

This challenge does not go into deeper Windows Container topics that might be of interest to customers looking to use containers as part of their "modernization/lift&shift/hybrid network" projects. Examples of topics that we aren't addressing directly but may come up are:

1. Differences between Windows container types (Core, Nano and Windows)
1. Granting Access to on-prem resources protected with Active Directory with Group Managed Service Accounts (GMSA)
1. Application functionality on Windows Core Containers, particularly around containerizing commonly used Windows Server Services.
1. Network planning for intergrating Kubernetes and AKS with existing VNETs, peered VNETs and Express Route.

## Challenge 8

In this challenge, teams are required to implement a service mesh solution. We give references to LinkerD, Istio and OSM. It is up to the team to decide which they’d like to go with.

LinkerD is simpler to set up and is lightweight in comparison to Istio, which requires a more involved setup but has a fuller suite of capabilities.
OSM is azure supported with an az aks addon available. [OSM](https://docs.microsoft.com/en-us/azure/aks/open-service-mesh-deploy-add-on)
The challenge is solvable with all options, it’s up to your team to decide what they would like to spend time on.

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

### OSM

The Azure OSM add-on is the preferred method, however, there is also an OSM standalone path. (Which should also be viable, but with more process and setup).
Refer to solutions files for more.

[Grafana dashboards for use with OSM](https://github.com/openservicemesh/osm/tree/main/charts/osm/grafana/dashboards)
