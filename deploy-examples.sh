#!/usr/bin/env bash
set -e
SCRIPT_DIR=$(dirname "$0")

###
# This script is used to deploy the example configurations for the entire wallet ecosystem
# Use `git clean -Xdi` to clean up the examples
###

## Copy examples to the correct location, by removing the .example extension on copy
copy_examples() {
    local component="$1"
    local examples="$2"
    echo "Copying examples for $component"
    for example in $examples; do
        cp -r "$SCRIPT_DIR"/components/"$component"/"$example" "$SCRIPT_DIR"/components/"$component"/"${example%.example}"
    done
}

## Deploy .env override
OVERRIDE_EXAMPLES=".env.example"
copy_examples ".." "$OVERRIDE_EXAMPLES"

## Deploy for caddy
CADDY_EXAMPLES=".env.example"
copy_examples "caddy" "$CADDY_EXAMPLES"

## Deploy for wallet-frontend
WALLET_FRONTEND_EXAMPLES=".env.example"
copy_examples "wallet-frontend" "$WALLET_FRONTEND_EXAMPLES"

## Deploy for wallet-backend
WALLET_BACKEND_EXAMPLES=".env.example config.js.example keys.example"
copy_examples "wallet-backend" "$WALLET_BACKEND_EXAMPLES"

## Deploy for wallet-issuer
WALLET_ISSUER_EXAMPLES=".env.example config.js.example keys.example dataset.example"
copy_examples "wallet-issuer" "$WALLET_ISSUER_EXAMPLES"

## Deploy for wallet-verifier
WALLET_VERIFIER_EXAMPLES=".env.example config.js.example keys.example"
copy_examples "wallet-verifier" "$WALLET_VERIFIER_EXAMPLES"

docker compose up wallet-backend wallet-backend_db -d --no-deps
docker compose exec wallet-backend yarn migration:run:prod
docker compose down wallet-backend wallet-backend_db

# Configure go-wallet-backend with test tenant, issuer and verifier
ADMIN_TOKEN="change-me-NOW"
TENANT='''
{
  "id": "acme-corp",
  "name": "ACME Corporation",
  "display_name": "ACME Corp Wallet",
  "enabled": true
}
'''
   
ISSUER='''
{
  "credential_issuer_identifier": "http://issuer.localhost",  
  "client_id": "CLIENT123",    
  "visible": true
}
'''
   
VERIFIER='''
{
  "name": "University Portal",
  "url": "http://verifier.localhost"      
}
'''

docker compose up go-wallet-backend wallet-frontend -d --no-deps
docker compose exec wallet-frontend curl -d "$TENANT" -H "Accept: application/json" -H "Authorization: Bearer $ADMIN_TOKEN"  http://go-wallet-backend:8081/admin/tenants
docker compose exec wallet-frontend curl -d "$ISSUER" -H "Accept: application/json" -H "Authorization: Bearer $ADMIN_TOKEN"  http://go-wallet-backend:8081/admin/tenants/acme-corp/issuers
docker compose exec wallet-frontend curl -d "$VERIFIER" -H "Accept: application/json" -H "Authorization: Bearer $ADMIN_TOKEN"  http://go-wallet-backend:8081/admin/tenants/acme-corp/verifiers
docker compose down go-wallet-backend wallet-frontend