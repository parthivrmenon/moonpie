#!/bin/bash

source functions.sh

# Do not change these.
ARGO_CD_NAMESPACE="moonpie-argocd"
APPS_NAMESPACE="moonpie-apps"
INFRA_NAMESPACE="moonpie-infra"


bootstrap_cluster() {
    print_message "Bootstrapping moonpie..."
    
    # Check if Minikube is installed
    print_message "checking if minikube installed..."
    check_command_installed "minikube"

    # Check if Minikube is running
    if minikube status | grep -q "Running"; then
        print_message "Minikube is running."
    else
        print_message "Minikube is not running."
        print_message "Starting Minikube"
        minikube start --interactive=False > /dev/null
        minikube addons enable ingress > /dev/null
    fi

    # Check if kubectl is installed
    print_message "checking if kubectl installed correctly.."
    check_command_installed "kubectl"

    # Install argoCD
    print_message "Installing argoCD"
    print_message "Creating namespace $ARGO_CD_NAMESPACE"
    kubectl create namespace $ARGO_CD_NAMESPACE > /dev/null
    print_message "Deploying argocd"
    kubectl apply -n $ARGO_CD_NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml >/dev/null
    print_message "Default username is : admin"
    default_password=`kubectl -n $ARGO_CD_NAMESPACE get secret argocd-initial-admin-secret  --template={{.data.password}} | base64 --decode`
    print_message "Default password is : $default_password"

    print_message "Setting context to argocd"
    kubectl config set-context --current --namespace=$ARGO_CD_NAMESPACE
    print_message "Deploying app of apps.."
    kubectl apply -f app-of-apps.yaml

    print_message "Creating namespace $APPS_NAMESPACE for applications."
    kubectl create namespace $APPS_NAMESPACE > /dev/null

    print_message "Creating namespace $INFRA_NAMESPACE"
    kubectl create namespace $INFRA_NAMESPACE > /dev/null
}

destroy_cluster() {
    print_message "Destroying moonpie..."
    kubectl delete namespace ingress-nginx
    kubectl delete namespace $ARGO_CD_NAMESPACE
    kubectl delete namespace $APPS_NAMESPACE
    kubectl delete namespace $INFRA_NAMESPACE


}


# Check if the script is called with an argument
if [ $# -ne 1 ]; then
  echo "Usage: $0 <action>"
  echo "  Available actions: up, down"
  exit 1
fi

action="$1"

# Check the provided action and perform the corresponding tasks
case "$action" in
  "up")
    bootstrap_cluster
    ;;
  "down")
    destroy_cluster
    ;;
  *)
    echo "Invalid action: $action"
    echo "Available actions: up, down"
    exit 1
    ;;
esac

# Optionally, you can add error handling or additional steps as needed.
