# Project Title

This code in this repo builds a simple 'hello jamf' python-app using Github actions to two (2) Kubernetes clusters (staging and production)

## Description

An in-depth paragraph about your project and overview of use.

This code in this repo builds a simple 'hello world' python-app using Github actions. We can deploy the app to one or many Kubernetes clusters if necessary. We can create two (2) Kind clusters using the staging and production manifests in the kind folder. An ingress is added to each cluster to allow external access. We will also use self hosted runners for deploying applications to k8s clusters. The CICD pipeline can target either the production or staging cluster.

ArgoCD is installed onto each cluster using Helm charts. The respective values files are located in the charts/argocd folder. 

I chose to install ArgoCD on both clusters separately due to networking issues between Kind clusters. Originally, I planned to run ArgoCD only on the staging cluster and manage the production cluster remotely using external cluster authentication. However, cross-cluster communication between Kind clusters proved VERY problematic, being on a Windows box using WSL doesn't help. The kind/ArgoExternalAuth folder contains the configurations I attempted for this single ArgoCD setup.

The SonarQube Scan step in the ci job is commented out as I did not set up a SONAR Server but I  captured the coverage and unit tests report

### Installation

Pre-Requisities
- kind CLI 
- kubectl CLI
- git CLI
- helm CLI
- curl CLI
- Docker/Rancher Desktop
- VsCode IDE
- Docker Hub account

Create staging and production Kind clusters
```
kind create cluster --name staging --config kind/createcluster/staging.yaml
kind create cluster --name production --config kind/createcluster/production.yaml
```
Deploy an nginx ingress controller onto each Kind clusters

```
kubectl config use-context kind-<environment>
kubectl apply -f kind/controllers/nginx-ingress-controller.yaml
```


Deploy ArgoCD application onto each Kind clusters
```
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argocd argo/argo-cd -n argocd --version 9.1.0 --create-namespace -f charts/argocd/<environment>-values.yaml

Update your local host file
127.0.0.1 argocd.production.local
127.0.0.1 argocd.staging.local

Access the Production ArgoCD UI from https://argocd.production.local:8443/
Access the Staging ArgoCD UI from https://argocd.staging.local/
```

Create an ArgoCD app in the production environment via UI or CLI
```
argocd app create python-app-production \
  --repo https://github.com/Tr3V3rn/python-app.git \
  --path charts/python-app \
  --revision main \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace production \
  --values values-production.yaml \
  --sync-option CreateNamespace=true
```
Create an ArgoCD app in the staging environment via UI or CLI
```
argocd app create python-app-production \
  --repo https://github.com/Tr3V3rn/python-app.git \
  --path charts/python-app \
  --revision develop \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace staging \
  --values values-staging.yaml \
  --sync-option CreateNamespace=true
```

Get the ArgoCD admin password
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Use self-hosted runners for each cluster to avoid exposing Kubernetes API endpoints publicly
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.yaml

Generate a Personal Access Token (PAT) for ARC to authenticate with GitHub.
Select **repo ** scope for the access

helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller

helm upgrade --install --namespace actions-runner-system --create-namespace\
  --set=authSecret.create=true\
  --set=authSecret.github_token="REPLACE_YOUR_PAT_HERE"\
  --wait actions-runner-controller actions-runner-controller/actions-runner-controller --version 0.23.7

kubectl apply -f kind/resources/prodrunnerdeployment.yaml (on production cluster)
kubectl apply -f kind/resources/stagingrunnerdeployment.yaml (on staging cluster)

Verify the self-hosted runners appear in GitHub UI under Actions
```
Add Repository Secrets to Github Actions
```
create secret with name ARGOCD_PROD_PASSWORD and add the ArgoCD admin password recorded earlier from the production cluster

create secret with name ARGOCD_PASSWORD and add the ArgoCD admin password recorded earlier from the staging cluster

create secret with name DOCKERHUB_USERNAME, add your docker hub username
create secret with name DOCKERHUB_TOKEN, add your docker hub token
```

### Accessing the application

* Access the Python application from the browser or CLI
```
Add the entries to your host file
127.0.0.1 jamf.production.local
127.0.0.1 jamf.staging.local

curl http://jamf.staging.local/api/v1/info (staging)
curl http://jamf.production.local:8080/api/v1/info (production)

Sample expected output:
{
  "deployed_on": "kubernetes",
  "hostname": "python-app-staging-7fb97cb4d-kmjhm",
  "message": "Hello jamFStagingBaby",
  "time": "05:20:16PM  on November 14, 2025"
}

```

## Help

```
If things do not work as expected PRESS & HOLDthe Power button for 3 seconds!
```

## Authors

Contributors names and contact info

Trestian Stewart
[email me](trestian.stewart@gmail.com)


## Resources Used
* [GitHub Self-hosted runners](https://github.com/actions/actions-runner-controller/blob/master/docs/quickstart.md)
* [Writing Unit Test](https://docs.python.org/3/library/unittest.html)
* [SonarQube Scan Action](https://github.com/SonarSource/sonarqube-scan-action)
* [Python Generate test Reports](https://github.com/SonarSource/sonar-scanning-examples/tree/master/sonar-scanner/src/python)
* [Argocd External Authentication](https://medium.com/pickme-engineering-blog/how-to-connect-an-external-kubernetes-cluster-to-argo-cd-using-bearer-token-authentication-d9ab093f081d)