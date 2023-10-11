# MoonPie
A micro developer platform running on k8s.

## Setup
```bash
cd moonpie
chmod +x moonpie-bootstrap.sh
sudo ./moonpie-bootstrap.sh up
```
## To destroy
```bash
sudo ./moonpie-bootstrap.sh down
```


## Infra
```bash
# Postgres
moonpie-postgres.com:30100

```
## ArgoCD
```bash
# Install ArgoCD and ArgoCD CLI
➜ kubectl create namespace argocd
➜ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml


# The default username is 'admin' and password is stored as a secret which can be retrieved using:

kubectl -n argocd get secret argocd-initial-admin-secret  --template={{.data.password}} | base64 --decode

```



## ArgoCD UI
```bash
# Port forward service argocd-server on 8080
➜ kubectl port-forward -n argocd svc/argocd-server 8080:443

# You can now access the argoCD UI at:
https://127.0.0.1:8080/ 
```


## App of Apps Pattern
```bash
# App of apps..
kubectl config set-context --current --namespace=argocd
kubectl apply -f app-of-apps.yaml

```

## MoonPie Postgres
```bash
# apply postgres manifest
kubectl -n moonpie-infra apply -f templates/postgres

#
kubectl -n moonpie-infra exec -it moonpie-postgres-879877b65-6mfbk -- psql -h localhost -U postgres --password -p 5432 postgres




```

## MoonPie MySQL
```bash

helm install moonpie-mysql oci://registry-1.docker.io/bitnamicharts/mysql

```

## Prometheus
https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack






