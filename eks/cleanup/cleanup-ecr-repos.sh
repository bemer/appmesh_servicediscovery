#!/bin/bash

# Cleanup ECR Repositories
FRONTEND_REPO=$(jq < cfn-output.json -r '.FrontendEcrRepo' | cut -d'/' -f2)
BACKEND_REPO=$(jq < cfn-output.json -r '.BackendEcrRepo' | cut -d'/' -f2)

aws ecr list-images \
 --repository-name $FRONTEND_REPO | \
jq -r ' .imageIds[] | [ .imageDigest ] | @tsv ' | \
 while IFS=$'\t' read -r imageDigest; do
  aws ecr batch-delete-image \
  --repository-name $FRONTEND_REPO \
  --image-ids imageDigest=$imageDigest
done

aws ecr list-images \
 --repository-name $BACKEND_REPO | \
jq -r ' .imageIds[] | [ .imageDigest ] | @tsv ' | \
 while IFS=$'\t' read -r imageDigest; do
  aws ecr batch-delete-image \
  --repository-name $BACKEND_REPO \
  --image-ids imageDigest=$imageDigest
done