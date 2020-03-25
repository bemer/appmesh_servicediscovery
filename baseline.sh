#!/bin/bash


echo "Setting up environment variables..."

ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)


echo "Deploying CloudFormation template..."

aws cloudformation deploy \
--template-file infrastructure/vpc_infrastructure.yaml \
--stack-name appmesh-service-discovery \
--capabilities CAPABILITY_IAM

echo "Getting CloudFormation outputs..."

aws cloudformation describe-stacks \
    --stack-name appmesh-service-discovery | \
jq -r '[.Stacks[0].Outputs[] | {key: .OutputKey, value: .OutputValue}] | from_entries' > cfn-output.json 


echo "Building Docker images..."

cd applications/python-app/ && docker build -t python-app .
cd ../..
cd applications/curl-app/ && docker build -t curl-app .
cd ../..

$(aws ecr get-login --no-include-email)

PythonEcrRepo=$(jq < cfn-output.json -r '.PythonEcrRepo');
CurlEcrRepo=$(jq < cfn-output.json -r '.CurlEcrRepo');

docker tag python-app:latest $PythonEcrRepo:latest
docker push $PythonEcrRepo:latest

docker tag curl-app:latest $CurlEcrRepo:latest
docker push $CurlEcrRepo:latest

echo "Creating Task Definition files..."
ECSServiceRole=$(jq < cfn-output.json -r '.ECSServiceRole');
ECSTaskRole=$(jq < cfn-output.json -r '.ECSTaskRole');
PythonAppImage=$(jq < cfn-output.json -r '.PythonEcrRepo')':latest';
CurlAppImage=$(jq < cfn-output.json -r '.CurlEcrRepo')':latest';
AwsStackRegion=$(jq < cfn-output.json -r '.StackRegion');

jq --arg ECSServiceRole "$ECSServiceRole" '.executionRoleArn = $ECSServiceRole' infrastructure/python-task-def.json|sponge infrastructure/python-task-def.json
jq --arg ECSTaskRole "$ECSTaskRole" '.taskRoleArn = $ECSTaskRole' infrastructure/python-task-def.json|sponge infrastructure/python-task-def.json
jq --arg PythonAppImage "$PythonAppImage" '.containerDefinitions[0].image = $PythonAppImage' infrastructure/python-task-def.json|sponge infrastructure/python-task-def.json
jq --arg AwsStackRegion "$AwsStackRegion" '.containerDefinitions[].logConfiguration.options["awslogs-region"] = $AwsStackRegion' infrastructure/python-task-def.json|sponge infrastructure/python-task-def.json

jq --arg ECSServiceRole "$ECSServiceRole" '.executionRoleArn = $ECSServiceRole' infrastructure/curl-task-def.json|sponge infrastructure/curl-task-def.json
jq --arg ECSTaskRole "$ECSTaskRole" '.taskRoleArn = $ECSTaskRole' infrastructure/curl-task-def.json|sponge infrastructure/curl-task-def.json
jq --arg CurlAppImage "$CurlAppImage" '.containerDefinitions[0].image = $CurlAppImage' infrastructure/curl-task-def.json|sponge infrastructure/curl-task-def.json
jq --arg AwsStackRegion "$AwsStackRegion" '.containerDefinitions[].logConfiguration.options["awslogs-region"] = $AwsStackRegion' infrastructure/curl-task-def.json|sponge infrastructure/python-task-def.json
