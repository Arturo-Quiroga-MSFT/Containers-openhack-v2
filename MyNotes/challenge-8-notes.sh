# Install LINKERD following this page, but use version 2.8.1 of the linkerd cli
https://linkerd.io/2/edge/
curl -sL https://run.linkerd.io/install | sh
export PATH=$PATH:$HOME/.linkerd2/bin


#for MACOS, good instructions are here, you can alos install linkerd via homebrew
https://linkerd.io/2/getting-started/


# other good links are:
https://github.com/linkerd/linkerd2




                ARTUROs-MacBook-Pro:~ arturoquiroga$ linkerd check --pre
                kubernetes-api
                --------------
                √ can initialize the client
                √ can query the Kubernetes API

                kubernetes-version
                ------------------
                √ is running the minimum Kubernetes API version
                √ is running the minimum kubectl version

                pre-kubernetes-setup
                --------------------
                √ control plane namespace does not already exist
                √ can create non-namespaced resources
                √ can create ServiceAccounts
                √ can create Services
                √ can create Deployments
                √ can create CronJobs
                √ can create ConfigMaps
                √ can create Secrets
                √ can read Secrets
                √ can read extension-apiserver-authentication configmap
                √ no clock skew detected

                pre-kubernetes-capability
                -------------------------
                ‼ has NET_ADMIN capability
                    found 2 PodSecurityPolicies, but none provide NET_ADMIN, proxy injection will fail if the PSP admission controller is running
                    see https://linkerd.io/checks/#pre-k8s-cluster-net-admin for hints
                ‼ has NET_RAW capability
                    found 2 PodSecurityPolicies, but none provide NET_RAW, proxy injection will fail if the PSP admission controller is running
                    see https://linkerd.io/checks/#pre-k8s-cluster-net-raw for hints

                linkerd-version
                ---------------
                √ can determine the latest version
                √ cli is up-to-date

                Status check results are √
                ARTUROs-MacBook-Pro:~ arturoquiroga$ 

# view the dashboard
linkerd dashboard


# TO INJECT linkerd to a deployment, use this: (do this to all yaml files of the web and api services)
https://linkerd.io/2/tasks/adding-your-service/

cat tripviewer.yaml | linkerd inject - | kubectl apply -f -



# securing your services
https://linkerd.io/2/tasks/securing-your-service/
https://linkerd.io/2/features/automatic-mtls/

# Not all traffic can be automatically mTLS'd, but it's easy to verify which traffic is. 
# See Caveats and future work for details on which traffic cannot currently be automatically encrypted.
https://linkerd.io/2/tasks/securing-your-service/

# show the metrics (first create some traffic), to porove traffic is using mTLS.
        linkerd stat deployments -n web
        linkerd stat deployments -n api
        linkerd -n linkerd tap deploy

# validating mTLS with tshark
https://linkerd.io/2/tasks/securing-your-service/#validating-mtls-with-tshark

        curl -sL https://run.linkerd.io/emojivoto.yml \
        | linkerd inject --enable-debug-sidecar - \
        | kubectl apply -f -

        kubectl -n emojivoto exec -it \
            $(kubectl -n emojivoto get po -o name | grep voting) \
            -c linkerd-debug -- /bin/bash

        tshark -i any -d tcp.port==8080,ssl | grep -v 127.0.0.1



# See the OPEN SERVICE MESH open source project at :
# this is in ALPHA stage, and is not supported by Microsoft.
https://openservicemesh.io

