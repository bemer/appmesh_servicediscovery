#!/bin/bash

echo "Deleting Virtual Services..."

aws appmesh delete-virtual-service\
 --mesh-name appmesh-service-discovery \
 --virtual-service-name python.mydomain.pvt.local
 
aws appmesh delete-virtual-service\
 --mesh-name appmesh-service-discovery \
 --virtual-service-name curl-app.mydomain.pvt.local

echo "Deleting python route..." 
aws appmesh delete-route\
 --mesh-name appmesh-service-discovery \
 --virtual-router-name python-router\
 --route-name python-sd-route

echo "Deleting Virtual Router..."
aws appmesh delete-virtual-router\
 --mesh-name appmesh-service-discovery \
 --virtual-router-name python-router
 
 echo "Deleting Virtual Nodes..."
aws appmesh delete-virtual-node\
 --mesh-name appmesh-service-discovery \
 --virtual-node-name curl-app
 
aws appmesh delete-virtual-node\
 --mesh-name appmesh-service-discovery \
 --virtual-node-name python-sd
 
echo "Deleting Mesh..."
aws appmesh delete-mesh\
 --mesh-name appmesh-service-discovery