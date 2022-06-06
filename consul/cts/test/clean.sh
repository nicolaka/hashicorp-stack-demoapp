#!/bin/bash

set -e

POD=$(kubectl get pod -l app=consul-terraform-sync -o jsonpath="{.items[0].metadata.name}")

kubectl delete -f product-api.yaml --ignore-not-found
vault lease revoke -force -prefix database/product/creds
kubectl exec -c consul-terraform-sync -it ${POD} -- /bin/consul-terraform-sync task disable products-database
kubectl exec -c consul-terraform-sync -it ${POD} -- /bin/sh -c 'cd /consul-terraform-sync/sync-tasks/products-database && VAULT_TOKEN=$(cat /vault/secrets/token) /consul-terraform-sync/terraform destroy'
kubectl exec -c consul-terraform-sync -it ${POD} -- /bin/consul-terraform-sync task delete products-database
kubectl delete -f cts.yaml --ignore-not-found

cd terraform && terraform init
cd terraform && terraform apply

cd ..

kubectl delete -f database.yaml --ignore-not-found
helm del vault
helm del consul
kubectl delete pvc --all
kubectl delete secrets tfstate-default-state tfstate-products-database-state --ignore-not-found