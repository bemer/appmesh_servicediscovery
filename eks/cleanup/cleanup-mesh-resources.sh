#!/bin/bash

# Delete App Mesh resources
kubectl delete -f /tmp/eks-scripts/frontend-virtual-service.yml
kubectl delete -f /tmp/eks-scripts/frontend-virtual-node.yml
kubectl delete -f /tmp/eks-scripts/backend-virtual-service.yml
kubectl delete -f /tmp/eks-scripts/backend-virtual-node.yml
kubectl delete -f /tmp/eks-scripts/mesh.yml