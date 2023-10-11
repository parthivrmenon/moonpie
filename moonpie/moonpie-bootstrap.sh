#!/bin/bash

set -euo pipefail

ARGO_CD_NAMESPACE="argocd"
APPS_NAMESPACE="moonpie-apps"
INFRA_NAMESPACE="moonpie-infra"
IP_ADDRESS="127.0.0.1"

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

    # assert_is_root

    # Check if pre-requisites are installed & docker is running
    assert_command_is_installed docker
    assert_command_is_installed minikube
    assert_command_is_installed helm
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

    # Add moonpie.com dns to hosts
    #moonpie_ip_address="$(minikube ip)"
    add_to_hosts $IP_ADDRESS "moonpie.com"

    # Install helm
    #install_helm

    # Start services
    # minikube service --all
   
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
        minikube start --interactive=False  > /dev/null
        minikube addons enable ingress > /dev/null
    fi
}

# Deploy argoCD from manifest
deploy_argocd(){
    kubectl apply -n $ARGO_CD_NAMESPACE -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml >/dev/null
}

# Install helm
install_helm() {
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh
}

# Link Repository
link_repo() {
    print_message "Linking MoonPie repo to argoCD"
    kubectl -n argocd apply -f templates/argocd/repositories.yaml > /dev/null
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

# Function to add an entry to /etc/hosts
add_to_hosts() {
    local ip_address="$1"
    local hostname="$2"

    # Check if the entry already exists in /etc/hosts
    if grep -q "$ip_address[[:space:]]*$hostname" /etc/hosts; then
        print_message "Entry already exists in /etc/hosts for $hostname:$ip_address"
    else
        # Add the entry to /etc/hosts
        print_message "$ip_address $hostname" >> /etc/hosts
        print_message "Entry added to /etc/hosts for $hostnane:$ip_address"
    fi
}

# Function to assert that the script is run as root
assert_is_root() {
    if [[ $EUID -ne 0 ]]; then
       echo "This script must be run as root" 
       exit 1
    fi
}


main "$@"