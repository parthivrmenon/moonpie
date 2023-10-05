# MoonPie
A local k8s playground for your exploration!


## Setup (via Bootstap script) [experimental]
```bash
chmod +x moonpie.sh
./moonpie.sh up
```
## To destroy
```bash
./moonpie.sh down
```

## Setup manually [probably safer]

* [Step 1: Install 'minikube' for your platform](https://minikube.sigs.k8s.io/docs/start/)
* [Step 2: Start minikube](#minikube)
* [Step 3: Install ArgoCD](#argocd)
* [Step 4: App of Apps Pattern](#app-of-apps-pattern)


## Minikube
```bash
# Start minikube and Enable Ingress
➜  minikube start
➜  minikube addons enable ingress

# Ensure everything started up fine..
➜  minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

# Minikube includes kubectl
➜  kubectl version

```

## ArgoCD
```bash
# Install ArgoCD and ArgoCD CLI
➜ kubectl create namespace argocd
➜ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# The default username is 'admin' and password is stored as a secret which can be retrieved using:

kubectl -n argocd get secret argocd-initial-admin-secret  --template={{.data.password}} | base64 --decode

```

## App of Apps Pattern
```bash
# App of apps..
kubectl config set-context --current --namespace=argocd

kubectl apply -f app-of-apps.yaml

```

## ArgoCD UI
```bash
# Port forward service argocd-server on 8080
➜ kubectl port-forward -n argocd svc/argocd-server 8080:443

# You can now access the argoCD UI at:
https://127.0.0.1:8080/ 
```






