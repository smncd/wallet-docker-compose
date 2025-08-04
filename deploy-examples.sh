#!/usr/bin/env bash
set -e
SCRIPT_DIR=$(dirname "$0")

###
# This script is used to deploy the example configurations for the entire wallet ecosystem
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
