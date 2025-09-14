#!/bin/bash

EMAIL="void@manifault.com"
CLIENT_ID="${MANIFAULT_CLIENT_ID}"
CLIENT_SECRET="$(gpg --batch -q --decrypt -r $GPG_USER_ID ~/.local/gpg/oauth_secret_manifault.gpg)"
REFRESH_TOKEN="${MANIFAULT_ACCESS_TOKEN}"

ACCESS_TOKEN=$(curl -s \
  -d client_id="${CLIENT_ID}" \
  -d client_secret="${CLIENT_SECRET}" \
  -d refresh_token="${REFRESH_TOKEN}" \
  -d grant_type=refresh_token \
  https://oauth2.googleapis.com/token | jq -r .access_token)

printf "user=${EMAIL}\x01auth=Bearer ${ACCESS_TOKEN}\x01\x01"
