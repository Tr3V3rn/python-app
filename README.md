# Project Title

This code in this repo builds a simple 'hello jamf' python-app using Github actions to two (2) Kubernetes clusters (staging and production)

## Description

An in-depth paragraph about your project and overview of use.

This code in this repo builds a simple 'hello world' python-app using Github actions. We can deploy the app to one or many Kubernetes clusters if necessary. We can create two (2) Kind clusters using the staging and production manifests in the kind folder. An ingress is added to each cluster to allow external access. We will also use self hosted runners for deploying applications to k8s clusters. The CICD pipeline can target either the production or staging cluster.

ArgoCD is installed onto each cluster using Helm charts. The values files are located in the charts/argocd folder. 

I chose to install ArgoCD on both clusters separately due to networking issues between Kind clusters. Originally, I planned to run ArgoCD only on the staging cluster and manage the production cluster remotely using external cluster authentication. However, cross-cluster communication between Kind clusters proved VERY problematic, being on a Windows box using WSL doesn't help. The kind/ArgoExternalAuth folder contains the configurations I attempted for this single ArgoCD setup.

The SonarQube Scan step in the ci job is commented out as I did not set up a SONAR Server but I  captured the coverage and unit tests report

### Prerequisites

Install
- Kind CLI using your favorite package manager
- Docker Desktop or Rancher Desktop
- Helm CLI
- curl

Create staging and production k8s clusters
```
kind create cluster --name staging --config kind/staging.yaml
kind create cluster --name production --config kind/production.yaml
```
Deploy an nginx ingress controller to each cluster (production,staging)

```
kubectl config use-context kind-<environment>
kubectl apply -f kind/nginx-ingress-controller.yaml
```


Deploy ArgoCD onto the k8s clusters (staging and prod)
```
helm repo add argo https://argoproj.github.io/argo-helm
helm upgrade --install argocd argo/argo-cd -n argocd --create-namespace -f charts/argocd/<environment>-values.yaml
Update your local host file
127.0.0.1 argocd.production.local
Access the ArgoCD UI from https://argocd.production.local:8443/
```

Create an app in the production environment
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
Create an app in the staging environment
```
argocd app create python-app-production \
  --repo https://github.com/Tr3V3rn/python-app.git \
  --path charts/python-app \
  --revision develop \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace staging \
  --values values.yaml \
  --sync-option CreateNamespace=true
```

Get ArgoCD admin password
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Use self-hosted runners to avoid exposing Kubernetes API endpoints publicly
```
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.8.2/cert-manager.yaml

Generate a Personal Access Token (PAT) for ARC to authenticate with GitHub.

helm repo add actions-runner-controller https://actions-runner-controller.github.io/actions-runner-controller

helm upgrade --install --namespace actions-runner-system --create-namespace\
  --set=authSecret.create=true\
  --set=authSecret.github_token="REPLACE_YOUR_PAT_HERE"\
  --wait actions-runner-controller actions-runner-controller/actions-runner-controller

kubectl apply -f kind/runnerdeployment.yaml

Verify you see the self hosted runner in GitHub under Actions
```




### Installing

* How/where to download your program
* Any modifications needed to be made to files/folders

### Accessing the application

* How to acces the application
```
curl http://myapp.example.com/api/v1/info (staging)
curl http://myapp.example.com:8080/api/v1/info (production)
```

## Help

Any advise for common problems or issues.
```
command to run if program contains helper info
```

## Authors

Contributors names and contact info

Trestian Stewart
[@DomPizzie](https://twitter.com/dompizzie)


## Resources Used
* [GitHub Self-hosted runners](https://github.com/actions/actions-runner-controller/blob/master/docs/quickstart.md)
* [Writing Unit Test](https://docs.python.org/3/library/unittest.html)
* [SonarQube Scan Action](https://github.com/SonarSource/sonarqube-scan-action)
* [Python Generate test Reports](https://github.com/SonarSource/sonar-scanning-examples/tree/master/sonar-scanner/src/python)
* [Argocd External Authentication](https://medium.com/pickme-engineering-blog/how-to-connect-an-external-kubernetes-cluster-to-argo-cd-using-bearer-token-authentication-d9ab093f081d)