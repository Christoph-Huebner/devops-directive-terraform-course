#!/bin/bash
set -euo pipefail

# Change directory to example
cd ../../examples/hello-world

# Create the resources
terraform init
terraform apply -auto-approve

# Wait while the instance boots up
# (Could also use a provisioner in the TF config to do this)
sleep 60

# Query the output, extract the IP and make a request
# terraform output -json |\
# jq -r '.instance_ip_addr.value' |\
# xargs -I {} curl http://{}:8080 -m 10

# Fix for Windoof
curl "$(terraform output -raw url)"

# Show result for 10 seconds
sleep 10

# If request succeeds, destroy the resources
terraform destroy -auto-approve

# Clean up the Terraform state
rm -r .terraform
rm .terraform.lock.hcl
