#!/bin/bash

EMAIL="void@manifault.com"
CLIENT_ID="${MANIFAULT_CLIENT_ID}"
CLIENT_SECRET="$(gpg --batch -q --decrypt -r $GPG_USER_ID ~/.local/gpg/oauth_secret_manifault.gpg)"
REFRESH_TOKEN="${MANIFAULT_ACCESS_TOKEN}"

oauth2.py --quiet --user=${EMAIL} \
	  --client_id=${CLIENT_ID} --client_secret=${CLIENT_SECRET} \
	  --refresh_token=${REFRESH_TOKEN}
