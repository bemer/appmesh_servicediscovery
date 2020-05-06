#!/bin/bash


echo "Setting up environment variables..."

ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)


echo "Deploying CloudFormation template..."

aws cloudformation deploy \
--template-file infrastructure_eks/vpc_infrastructure.yaml \
--stack-name appmesh-service-discovery \
--capabilities CAPABILITY_IAM

echo "Getting CloudFormation outputs..."

aws cloudformation describe-stacks \
    --stack-name appmesh-service-discovery | \
jq -r '[.Stacks[0].Outputs[] | {key: .OutputKey, value: .OutputValue}] | from_entries' > cfn-output.json 