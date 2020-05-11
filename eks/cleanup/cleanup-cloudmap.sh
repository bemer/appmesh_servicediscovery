#!/bin/bash

NAMESPACE=$(aws servicediscovery list-namespaces | \
  jq -r ' .Namespaces[] | 
    select ( .Properties.HttpProperties.HttpName == "mydomain.pvt.local" ) | .Id ');

echo "Deleting Cloud Map Service..."

aws servicediscovery list-services \
  --filters Name="NAMESPACE_ID",Values=$NAMESPACE,Condition="EQ" | \
jq -r ' .Services[] | [ .Id ] | @tsv ' | \
  while IFS=$'\t' read -r serviceId; do 
    aws servicediscovery delete-service \
      --id $serviceId
  done
  

echo "Deleting Cloud Map Namespace..."
  
OPERATION_ID=$(aws servicediscovery delete-namespace \
    --id $NAMESPACE | \
  jq -r ' .OperationId ')
_operation_status() {
  aws servicediscovery get-operation \
    --operation-id $OPERATION_ID | \
  jq -r '.Operation.Status '
}
until [ $(_operation_status) != "PENDING" ]; do
  echo "Namespace is deleting ..."
  sleep 10s
  if [ $(_operation_status) == "SUCCESS" ]; then
    echo "Namespace deleted"
    break
  fi
done