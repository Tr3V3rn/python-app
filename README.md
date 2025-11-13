# Project Title

This code in this repo builds a simple 'hello jamf' python-app using Github actions to two (2) Kubernetes clusters (staging and production)

## Description

An in-depth paragraph about your project and overview of use.

This code in this repo builds a simple 'hello world' python-app using Github actions. We can deploy the app to one or many Kubernetes clusters if necessary. We can create two (2) Kind clusters using the staging and production manifests in the kind folder. An ingress is added to each cluster to allow external access.

ArgoCD is installed onto each cluster using Helm charts. The values files are located in the charts/argocd folder. 

I chose to install ArgoCD on both clusters separately due to networking issues between Kind clusters. Originally, I planned to run ArgoCD only on the staging cluster and manage the production cluster remotely using external cluster authentication. However, cross-cluster communication between Kind clusters proved VERY problematic, being on a Windows box using WSL doesn't help. The kind/ArgoExternalAuth folder contains the configurations I attempted for this single ArgoCD setup.

The SonarQube Scan step in the ci job is commented out as I did not set up a SONAR Server but I have captured the coverage and unit tests report

### Prerequisites

Install
- Kind CLI using your favorite package manager
- Docker Desktop or Rancher Desktop
- Helm CLI

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

Get ArgoCD admin password
```
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```






```
kubectl config use-context kind-production
kubectl apply -f kind/ArgoExternalAuth/production/serviceaccount.yaml
kubectl apply -f kind/ArgoExternalAuth/production/clusterrolebinding.yaml
kubectl apply -f kind/ArgoExternalAuth/production/secret.yaml
```

Obtain the Bearer Token and client certificate for authentication
```
kubectl -n kube-system get secret argocd -o yaml
Follow the instructions below for updating the kind/ArgoExternalAuth/staging/argocdsecret.yaml
https://medium.com/pickme-engineering-blog/how-to-connect-an-external-kubernetes-cluster-to-argo-cd-using-bearer-token-authentication-d9ab093f081d
Apply the updated secret to the staging cluster
kubectl apply -f 
```

kubectl config use-context kind-staging
kubectl apply -f argocdsecret.yaml

### Installing

* How/where to download your program
* Any modifications needed to be made to files/folders

### Executing program

* How to run the program
* Step-by-step bullets
```
code blocks for commands
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

* [Writing Unit Test](https://docs.python.org/3/library/unittest.html)
* [SonarQube Scan Action](https://github.com/SonarSource/sonarqube-scan-action)
* [Python Generate test Reports](https://github.com/SonarSource/sonar-scanning-examples/tree/master/sonar-scanner/src/python)
* [Argocd External Authentication](https://medium.com/pickme-engineering-blog/how-to-connect-an-external-kubernetes-cluster-to-argo-cd-using-bearer-token-authentication-d9ab093f081d)