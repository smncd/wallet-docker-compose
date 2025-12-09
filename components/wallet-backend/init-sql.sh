#!/bin/bash

SQL_DATA="""
INSERT INTO trusted_root_certificate (certificate) SELECT '${WALLET_BACKEND_TRUSTED_ROOT}' WHERE NOT EXISTS (SELECT 1 FROM trusted_root_certificate WHERE certificate = '${WALLET_BACKEND_TRUSTED_ROOT}');
INSERT INTO credential_issuer (credentialIssuerIdentifier, clientId, visible) SELECT '${WALLET_ISSUER_URL}', '1233', 1 WHERE NOT EXISTS (SELECT 1 FROM credential_issuer WHERE credentialIssuerIdentifier = '${WALLET_ISSUER_URL}');
INSERT INTO verifier (name, url) SELECT 'Friendly Demo Verifier', '${WALLET_VERIFIER_URL}' WHERE NOT EXISTS (SELECT 1 FROM verifier WHERE url = '${WALLET_VERIFIER_URL}');
"""

echo "Executing: $SQL_DATA"

echo "$SQL_DATA" | mariadb --skip-ssl-verify-server-cert --host=wallet-backend_db --user=$MARIADB_USER --password=$MARIADB_PASSWORD $MARIADB_DATABASE