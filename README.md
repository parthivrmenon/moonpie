# MoonPie
A local k8s playground for your exploration!

## Setup (via Bootstap script) [experimental]
```bash
cd moonpie
chmod +x moonpie-bootstrap.sh
./moonpie-bootstrap.sh up
```
## To destroy
```bash
./moonpie-bootstrap.sh down
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






