#!/bin/bash

set -euo pipefail
source functions.sh

# Do not change these.
ARGO_CD_NAMESPACE="argocd"
APPS_NAMESPACE="moonpie-apps"
INFRA_NAMESPACE="moonpie-infra"

bootstrap_cluster() {
    print_message "1 MoonPie coming up..."
    
    # Check if Minikube is installed
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
    check_command_installed "kubectl"

    # Create namespace for ArgoCD if it does not exist
    create_namespace $ARGO_CD_NAMESPACE

    # Deploy ArgoCD
    kubectl apply -n $ARGO_CD_NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml >/dev/null


    # Create NS for apps and infra
    create_namespace $APPS_NAMESPACE
    create_namespace $INFRA_NAMESPACE

}



destroy_cluster() {
    print_message "Destroying moonpie..."
    delete_namespace $ARGO_CD_NAMESPACE
    delete_namespace $APPS_NAMESPACE
    delete_namespace $INFRA_NAMESPACE

}

create_namespace() {
    local ns="$1"
    if ! (kubectl get namespace $ns > /dev/null); then 
      print_message "Creating namespace $ns."
      kubectl create namespace $ns > /dev/null
    else
      print_message "$ns already exists"
    fi

}


delete_namespace() {
  local ns="$1"
    if  (kubectl get namespace $ns > /dev/null); then 
      print_message "Deleting NS $ns"
      kubectl delete namespace $ns > /dev/null
    else
      print_message "$ns does not exist. Nothing to be cleaned up."
    fi

}


############# MAIN #############################
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


