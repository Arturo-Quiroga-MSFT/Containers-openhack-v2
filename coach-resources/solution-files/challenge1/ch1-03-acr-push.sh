#!/bin/bash

# ACR connection details
export ACR=CHANGEME
export ACR_URL=$ACR.azurecr.io

# Push up to ACR
# You could also do this by running `az acr build` for each image instead of using docker push
images=(
    "tripinsights/poi:1.0"
    "tripinsights/trips:1.0"
    "tripinsights/tripviewer:1.0"
    "tripinsights/user-java:1.0"
    "tripinsights/userprofile:1.0"
    )

for image in "${images[@]}"; do
    docker tag $image $ACR_URL/$image
    docker push $ACR_URL/$image
done
