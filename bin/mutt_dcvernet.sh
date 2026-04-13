#!/bin/bash

EMAIL="dcvernet@gmail.com"
CLIENT_ID="${DCVERNET_CLIENT_ID}"
CLIENT_SECRET="$(gpg --batch -q --decrypt -r $GPG_USER_ID $PERSONAL_CONFIGS_DIR/secrets/oauth_secret_dcvernet.gpg)"
REFRESH_TOKEN="$(gpg --batch -q --decrypt -r $GPG_USER_ID $PERSONAL_CONFIGS_DIR/secrets/oauth_dcvernet_refresh_token.gpg)"

${PERSONAL_CONFIGS_DIR}/bin/oauth2.py --quiet --user=${EMAIL} \
	  --client_id=${CLIENT_ID} --client_secret=${CLIENT_SECRET} \
	  --refresh_token=${REFRESH_TOKEN}
