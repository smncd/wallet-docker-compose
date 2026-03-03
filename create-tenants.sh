#!/usr/bin/env bash
set -e

# Configure go-wallet-backend with test tenant, issuer and verifier
ADMIN_TOKEN="change-me-NOW"

ISSUER='''
{
  "credential_issuer_identifier": "https://apigw.dev-didrik.app.siros.org",  
  "client_id": "1337",    
  "visible": true
}
'''
   
VERIFIER='''
{
  "name": "University Portal",
  "url": "http://verifier.localhost"      
}
'''

TENANT_DEFAULT='''
{
  "id": "default",
  "name": "Default",
  "display_name": "SIROS ID Wallet",
  "enabled": true
}
'''
docker compose exec frontend-default curl -X PUT -d "$TENANT_DEFAULT" -H "Accept: application/json" -H "Authorization: Bearer $ADMIN_TOKEN"  http://go-wallet-backend:8081/admin/tenants/default


TENANT_SUNET='''
{
  "id": "sunet",
  "name": "SUNET",
  "display_name": "SUNET Wallet",
  "enabled": true
}
'''
docker compose exec frontend-default curl -d "$TENANT_SUNET" -H "Accept: application/json" -H "Authorization: Bearer $ADMIN_TOKEN"  http://go-wallet-backend:8081/admin/tenants
docker compose exec frontend-default curl -d "$ISSUER" -H "Accept: application/json" -H "Authorization: Bearer $ADMIN_TOKEN"  http://go-wallet-backend:8081/admin/tenants/sunet/issuers
docker compose exec frontend-default curl -d "$VERIFIER" -H "Accept: application/json" -H "Authorization: Bearer $ADMIN_TOKEN"  http://go-wallet-backend:8081/admin/tenants/sunet/verifiers

TENANT_GUNET='''
{
  "id": "gunet",
  "name": "Greek Universities Network",
  "display_name": "GUnet Wallet",
  "enabled": true
}
'''   
docker compose exec frontend-default curl -d "$TENANT_GUNET" -H "Accept: application/json" -H "Authorization: Bearer $ADMIN_TOKEN"  http://go-wallet-backend:8081/admin/tenants
docker compose exec frontend-default curl -d "$VERIFIER" -H "Accept: application/json" -H "Authorization: Bearer $ADMIN_TOKEN"  http://go-wallet-backend:8081/admin/tenants/gunet/verifiers

