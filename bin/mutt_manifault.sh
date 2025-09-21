#!/bin/bash

EMAIL="void@manifault.com"
CLIENT_ID="${MANIFAULT_CLIENT_ID}"
CLIENT_SECRET="$(gpg --batch -q --decrypt -r $GPG_USER_ID $PERSONAL_CONFIGS_DIR/secrets/oauth_secret_manifault.gpg)"
REFRESH_TOKEN="$(gpg --batch -q --decrypt -r $GPG_USER_ID $PERSONAL_CONFIGS_DIR/secrets/oauth_manifault_refresh_token.gpg)"

${PERSONAL_CONFIGS_DIR}/bin/oauth2.py --quiet --user=${EMAIL} \
	  --client_id=${CLIENT_ID} --client_secret=${CLIENT_SECRET} \
	  --refresh_token=${REFRESH_TOKEN}
