#!/bin/bash

set -e

workspace_prefix=wsc-cnd-dev-k8s
dns_prefix=cnd
NB_PROJECTS=1 # can go to the value defined in https://gitlab.com/wescalefr/bootstrap-gcp-kube-training
ACTION=$1   # Action à lancer, passée en option

ROOT_DIR=$(pwd)
mkdir -p  "${ROOT_DIR}/config"

function provision(){
  local project_id=0
  rm -rf "${ROOT_DIR}/config/ips" "${ROOT_DIR}/config/adresses"
  echo "First Name [Required],Last Name [Required],Email Address [Required],Password [Required],Password Hash Function [UPLOAD ONLY],Org Unit Path [Required],New Primary Email [UPLOAD ONLY],Recovery Email,Home Secondary Email,Work Secondary Email,Recovery Phone [MUST BE IN THE E.164 FORMAT],Work Phone,Home Phone,Mobile Phone,Work Address,Home Address,Employee ID,Employee Type,Employee Title,Manager Email,Department,Cost Center,Building ID,Floor Name,Floor Section,Change Password at Next Sign-In,New Status [UPLOAD ONLY],Advanced Protection Program enrollment" > "${ROOT_DIR}/config/users.csv"
  while [ $project_id -lt $NB_PROJECTS ];do
    echo "Create content for project ${project_id}"
    set +e
    terraform workspace new "${workspace_prefix}-${project_id}"
    set -e
    terraform workspace select "${workspace_prefix}-${project_id}"
    terraform apply -auto-approve -var "dns_prefix=${dns_prefix}"

    mkdir -p "${ROOT_DIR}/config/${w}"   
    terraform output -json bastion_ip |jq -r . >> "${ROOT_DIR}/config/ips"
    terraform output -json bastion_dns |jq -r . >> "${ROOT_DIR}/config/adresses"
    gcloud_password=$(terraform output -raw password)
    echo "k8s-fund-trainee-${project_id},k8s-fund-trainee-${project_id},k8s-fund-trainee-${project_id}@wecontrol.cloud,${gcloud_password},,/kube-niv1-trainee,,,,,,,,,,,,,,,,,,,,,," >> "${ROOT_DIR}/config/users.csv"
    project_id=$[$project_id+1]
  done
}

function prepare_troubleshooting(){
  local project_id=0
  while [ $project_id -lt $NB_PROJECTS ];do
    echo "Create troubleshooting application for project ${project_id}"
    # Clear bastion fingerprint that may have changed
    ssh-keygen -R bastion.${dns_prefix}-${project_id}.wescaletraining.fr
    
    scp -i kubernetes-formation -o StrictHostKeyChecking=no k8s-troubleshooting.yml training@bastion.${dns_prefix}-${project_id}.wescaletraining.fr:/tmp/k8s-troubleshooting.yml
    ssh -i kubernetes-formation -o StrictHostKeyChecking=no training@bastion.${dns_prefix}-${project_id}.wescaletraining.fr "USE_GKE_GCLOUD_AUTH_PLUGIN=True /tmp/get-credential-cluster-0.sh"
    ssh -i kubernetes-formation -o StrictHostKeyChecking=no training@bastion.${dns_prefix}-${project_id}.wescaletraining.fr "kubectl apply -f /tmp/k8s-troubleshooting.yml"

    project_id=$[$project_id+1]
  done
}

function clean_troubleshooting(){
  local project_id=0
  while [ $project_id -lt $NB_PROJECTS ];do
    echo "Clean troubleshooting application for project ${project_id}"
    # Clear bastion fingerprint that may have changed
    ssh-keygen -R bastion.${dns_prefix}-${project_id}.wescaletraining.fr
    
    ssh -i kubernetes-formation -o StrictHostKeyChecking=no training@bastion.${dns_prefix}-${project_id}.wescaletraining.fr "kubectl delete ns application"

    project_id=$[$project_id+1]
  done
}

function refresh_git_repo(){
  local project_id=0
  while [ $project_id -lt $NB_PROJECTS ];do
    echo "Copy content for project ${project_id}"
    set +e
    w="wsc-kubernetes-adv-training-${project_id}"
    set -e
    # Clear bastion fingerprint that may have changed
    ssh-keygen -R bastion.${dns_prefix}-${project_id}.wescaletraining.fr
    
    ssh -i kubernetes-formation -o "StrictHostKeyChecking no" training@bastion.${dns_prefix}-${project_id}.wescaletraining.fr sudo rm -rf /home/training/kubernetes-formation
    ssh -i kubernetes-formation -o "StrictHostKeyChecking no" training@bastion.${dns_prefix}-${project_id}.wescaletraining.fr git clone https://github.com/WeScale/kubernetes-formation/

    #ssh -F "${ROOT_DIR}/config/${w}/provided_ssh_config" bastion "cd creds && rke up"
    # Kubeconfig, storage class
    project_id=$[$project_id+1]
  done
}

function clean() {
  local project_id=0
  while [ $project_id -lt $NB_PROJECTS ];do
    echo "Destroy content of project ${project_id}"
    set +e
    terraform workspace new "${workspace_prefix}-${project_id}"
    set -e
    terraform workspace select "${workspace_prefix}-${project_id}"
    terraform destroy -auto-approve
    terraform workspace select "default"
    terraform workspace delete "${workspace_prefix}-${project_id}"
    project_id=$[$project_id+1]
  done
}

terraform init -get

case $ACTION in
   "provision") provision;;
   "clean") clean;;
   "refresh_git_repo") refresh_git_repo;;
   "prepare_troubleshooting") prepare_troubleshooting;;
   "clean_troubleshooting") clean_troubleshooting;;
   *)
    echo "Bad argument!"
    echo "Usage: \`$0 provision\` or \`$0 clean\` or \`$0  refresh_git_repo\` or \`$0  prepare_troubleshooting\` or \`$0  clean_troubleshooting\`"
    exit 1
    ;;
esac
