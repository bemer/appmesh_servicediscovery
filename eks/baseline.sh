#!/bin/bash


echo "Setting up environment variables..."

ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)


echo "Deploying CloudFormation template..."

aws cloudformation deploy \
--template-file infrastructure/vpc_infrastructure.yaml \
--stack-name appmesh-service-discovery-eks \
--capabilities CAPABILITY_IAM

echo "Getting CloudFormation outputs..."

aws cloudformation describe-stacks \
    --stack-name appmesh-service-discovery-eks | \
jq -r '[.Stacks[0].Outputs[] | {key: .OutputKey, value: .OutputValue}] | from_entries' > cfn-output.json 

echo "Building Docker images..."

cd applications/backend/ && docker build -t backend .
cd ../..
cd applications/frontend/ && docker build -t frontend .
cd ../..

$(aws ecr get-login --no-include-email)

BackendEcrRepo=$(jq < cfn-output.json -r '.BackendEcrRepo');
FrontendEcrRepo=$(jq < cfn-output.json -r '.FrontendEcrRepo');

docker tag backend:latest $BackendEcrRepo:latest
docker push $BackendEcrRepo:latest

docker tag frontend:latest $FrontendEcrRepo:latest
docker push $FrontendEcrRepo:latest
