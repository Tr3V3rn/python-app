# Project Title

This code in this repo builds a simple 'hello jamf' python-app using Github actions.

## Description

An in-depth paragraph about your project and overview of use.

This code in this repo builds a simple 'hello jamf' python-app using Github actions. The application will be deployed using ArgoCD on a kubernetes cluster. 

### Prerequisites

Install
- Kind CLI using your favorite package manager
- Docker Desktop or Rancher Desktop

Create staging and production k8s clusters
```
kind create cluster --name staging --config kind/staging.yaml
kind create cluster --name production --config kind/production.yaml
```
Deploy an nginx ingress controller to each cluster
```
kubectl apply -f kind/nginx-ingress-controller.yaml
```

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