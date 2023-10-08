#!/bin/bash

set -euo pipefail

ARGO_CD_NAMESPACE="argocd"
APPS_NAMESPACE="moonpie-apps"
INFRA_NAMESPACE="moonpie-infra"

main() {
    # Check if the script is called with an argument
    if [ $# -ne 1 ]; then
        echo "Usage: $0 <action>"
        echo "  Available actions: up, down"
        exit 1
    fi

    action="$1"
    # Check the provided action and perform the corresponding command
    case "$action" in
        "up")
            moonpie_up
        
        ;;
        "down")
            moonpie_down
        ;;
        *)
            echo "Invalid action: $action"
            echo "Available actions: up, down"
            exit 1
        ;;
    esac
}

############### COMMANDS #################
moonpie_up() {

    # Check if docker and minikube are installed & that docker is running.
    assert_command_is_installed docker
    assert_command_is_installed minikube
    assert_docker_is_running

    # Start minikube if needed
    start_minikube

    # Minkube comes with kubectl packaged but check anyway
    assert_command_is_installed "kubectl"

    # create a namespace for argoCD
    create_namespace $ARGO_CD_NAMESPACE

    # deploy argoCD into the namespace
    deploy_argocd


    # Create NS for apps and infra
    create_namespace $APPS_NAMESPACE
    create_namespace $INFRA_NAMESPACE

    # Link MoonPie repository
    link_repo
   
}

moonpie_down() {
    delete_namespace $ARGO_CD_NAMESPACE
    delete_namespace $APPS_NAMESPACE
    delete_namespace $INFRA_NAMESPACE
}

############# HELPER FUNCTIONS ####################

# Assert Docker is running...
assert_docker_is_running() {
  print_message "Checking if Docker is running..."
  if ! docker info &> /dev/null; then
    echo "Docker is not running. Please start Docker before proceeding."
    exit 1
  else 
    print_message "Docker is running."
  fi
}

# Start Minikube up...
start_minikube() {
    if minikube status | grep -q "Running"; then
        print_message "Minikube is running."
    else
        print_message "Minikube is not running."
        print_message "Starting Minikube"
        minikube start --interactive=False > /dev/null
        minikube addons enable ingress > /dev/null
    fi
}

# Deploy argoCD from manifest
deploy_argocd(){
    kubectl apply -n $ARGO_CD_NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml >/dev/null
}

# Link Repository
link_repo() {
    kubectl -n argocd apply -f templates/argocd/repositories.yaml 
}

# Create a NS
create_namespace() {
    local ns="$1"
    if ! (kubectl get namespace $ns > /dev/null); then 
      print_message "Creating namespace $ns."
      kubectl create namespace $ns > /dev/null
    else
      print_message "$ns already exists"
    fi
}

# Delete a NS
delete_namespace() {
  local ns="$1"
    if  (kubectl get namespace $ns > /dev/null); then 
      print_message "Deleting NS $ns"
      kubectl delete namespace $ns > /dev/null
    else
      print_message "$ns does not exist. Nothing to be cleaned up."
    fi

}

# A standard print
print_message() {
  local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local prefix="[Moonp!e]"
  echo -e "$timestamp $prefix ${@:1}"
}

# Assert a command is installed...
assert_command_is_installed() {
  local command_name="$1"
  print_message "Checking if $command_name is installed."
  if command -v "$command_name" >/dev/null 2>&1; then
    print_message "$command_name is installed."
  else
    print_message "$command_name is not installed."
    exit 1
  fi
}


main "$@"