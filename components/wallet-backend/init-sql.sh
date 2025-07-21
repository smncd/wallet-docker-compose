#!/bin/bash

SQL_DATA="""
DELETE FROM trusted_root_certificate; INSERT INTO trusted_root_certificate (certificate) VALUES ('${WALLET_BACKEND_TRUSTED_ROOT}');
DELETE FROM credential_issuer; INSERT INTO credential_issuer (credentialIssuerIdentifier, clientId, visible) VALUES ('${WALLET_ISSUER_URL}', '1233', 1);
DELETE FROM verifier; INSERT INTO verifier (name, url) VALUES ('Friendly Demo Verifier', '${WALLET_VERIFIER_URL}');
"""

echo "Executing: $SQL_DATA"

echo "$SQL_DATA" | mariadb --skip-ssl-verify-server-cert --host=wallet-backend_db --user=$MARIADB_USER --password=$MARIADB_PASSWORD $MARIADB_DATABASE