#!/bin/bash
#
# Unified OAuth2 token refresh for mutt/msmtp.
# Usage: mutt_oauth.sh <account_name>
#
# Reads account config from accounts/<name>/account.conf,
# decrypts secrets from secrets/, and returns an access token.

ACCOUNT="$1"
if [ -z "$ACCOUNT" ]; then
	echo "Usage: mutt_oauth.sh <account_name>" >&2
	exit 1
fi

source "$PERSONAL_CONFIGS_DIR/accounts/$ACCOUNT/account.conf"

CLIENT_SECRET="$(gpg --batch -q --decrypt -r $GPG_USER_ID $PERSONAL_CONFIGS_DIR/secrets/oauth_secret_${ACCOUNT}.gpg)"
REFRESH_TOKEN="$(gpg --batch -q --decrypt -r $GPG_USER_ID $PERSONAL_CONFIGS_DIR/secrets/oauth_${ACCOUNT}_refresh_token.gpg)"

${PERSONAL_CONFIGS_DIR}/bin/oauth2.py --quiet \
	--user="${EMAIL}" \
	--client_id="${CLIENT_ID}" \
	--client_secret="${CLIENT_SECRET}" \
	--refresh_token="${REFRESH_TOKEN}"
