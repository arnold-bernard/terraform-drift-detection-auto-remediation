#!/bin/bash

set -e

terraform init
terraform plan -detailed-exitcode -out=tfplan || exit_code=$?

# Exit codes:
# 0 = no changes
# 2 = drift detected

if [ "$exit_code" -eq 2 ]; then
  echo "Drift detected!"

  terraform show -json tfplan > plan.json

  # Check if critical resources changed
  if grep -q '"aws_iam"' plan.json || grep -q '"aws_vpc"' plan.json; then
    echo "Critical drift detected!"
    
    # Create GitHub Issue
    curl -X POST -H "Authorization: token $GITHUB_TOKEN" \
    -d '{"title":"Critical Terraform Drift Detected","body":"Check Terraform plan output"}' \
    https://api.github.com/repos/$GITHUB_REPOSITORY/issues

  else
    echo "Non-critical drift. Auto-remediating..."
    terraform apply -auto-approve tfplan
  fi
else
  echo "No drift detected."
fi