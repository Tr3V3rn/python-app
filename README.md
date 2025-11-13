# Project Title

This code in this repo builds a simple 'hello jamf' python-app using Github actions to two (2) Kubernetes clusters (staging and production)

## Description

An in-depth paragraph about your project and overview of use.

This code in this repo builds a simple 'hello world' python-app using Github actions. We can deploy the app to one or many Kubernetes clusters if necessary. In this repo we have two Kind cluster deployment manifest (staging and production).

### Prerequisites

Install
- Kind CLI using your favorite package manager
- Docker Desktop or Rancher Desktop

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

ex. Dominique Pizzie  
ex. [@DomPizzie](https://twitter.com/dompizzie)

## Version History

* 0.2
    * Various bug fixes and optimizations
    * See [commit change]() or See [release history]()
* 0.1
    * Initial Release

## License

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details

## Acknowledgments

Inspiration, code snippets, etc.
* [awesome-readme](https://github.com/matiassingers/awesome-readme)
* [PurpleBooth](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
* [dbader](https://github.com/dbader/readme-template)
* [zenorocha](https://gist.github.com/zenorocha/4526327)
* [fvcproductions](https://gist.github.com/fvcproductions/1bfc2d4aecb01a834b46)