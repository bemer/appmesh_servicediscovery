#!/bin/bash

echo "Cleaning up python-app and curl-app services..."

aws ecs delete-service \
 --cluster appmesh-service-discovery \
 --service python-app \
 --force
 
 aws ecs delete-service \
 --cluster appmesh-service-discovery \
 --service curl-app \
 --force

 echo "Unregistering Task Definitions..."

 aws ecs deregister-task-definition \
 --task-definition curl-app:1
 
aws ecs deregister-task-definition \
 --task-definition python-app:1

echo "Cleaning up ECR repositories..."

PYTHON_APP_REPO=$(jq < cfn-output.json -r '.PythonEcrRepo' | cut -d'/' -f2)
CURL_APP_REPO=$(jq < cfn-output.json -r '.CurlEcrRepo' | cut -d'/' -f2)

aws ecr list-images \
 --repository-name $PYTHON_APP_REPO | \
jq -r ' .imageIds[] | [ .imageDigest ] | @tsv ' | \
 while IFS=$'\t' read -r imageDigest; do
  aws ecr batch-delete-image \
  --repository-name $PYTHON_APP_REPO \
  --image-ids imageDigest=$imageDigest
done

aws ecr list-images \
 --repository-name $CURL_APP_REPO | \
jq -r ' .imageIds[] | [ .imageDigest ] | @tsv ' | \
 while IFS=$'\t' read -r imageDigest; do
  aws ecr batch-delete-image \
  --repository-name $CURL_APP_REPO \
  --image-ids imageDigest=$imageDigest
done