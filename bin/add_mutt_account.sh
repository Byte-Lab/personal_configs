#!/bin/bash
#
# Add a new mutt/msmtp email account.
#
# Creates account config, encrypts OAuth2 secrets with GPG,
# performs the OAuth2 token dance, and appends to msmtprc.
#
# Usage: add_mutt_account.sh <account_name>

set -euo pipefail

ACCOUNT="${1:-}"
if [ -z "$ACCOUNT" ]; then
	echo "Usage: add_mutt_account.sh <account_name>" >&2
	exit 1
fi

ACCOUNT_DIR="$PERSONAL_CONFIGS_DIR/accounts/$ACCOUNT"
SECRETS_DIR="$PERSONAL_CONFIGS_DIR/secrets"

if [ -d "$ACCOUNT_DIR" ]; then
	echo "Error: account '$ACCOUNT' already exists at $ACCOUNT_DIR" >&2
	exit 1
fi

read -rp "Email address: " EMAIL
read -rp "Real name [David Vernet]: " REALNAME
REALNAME="${REALNAME:-David Vernet}"
read -rp "IMAP URL [imap.gmail.com:993]: " IMAP_URL
IMAP_URL="${IMAP_URL:-imap.gmail.com:993}"
read -rp "SMTP URL [smtp.gmail.com:587]: " SMTP_URL
SMTP_URL="${SMTP_URL:-smtp.gmail.com:587}"
read -rp "OAuth2 Client ID: " CLIENT_ID
read -rsp "OAuth2 Client Secret: " CLIENT_SECRET
echo

# Encrypt client secret
echo -n "$CLIENT_SECRET" | gpg --batch -q --encrypt -r "$GPG_USER_ID" \
	-o "$SECRETS_DIR/oauth_secret_${ACCOUNT}.gpg"
echo "Encrypted client secret to secrets/oauth_secret_${ACCOUNT}.gpg"

# Run the OAuth2 token dance to get a refresh token
echo ""
echo "Starting OAuth2 authorization flow..."
REFRESH_TOKEN=$("$PERSONAL_CONFIGS_DIR/bin/oauth2.py" \
	--generate_oauth2_token \
	--client_id="$CLIENT_ID" \
	--client_secret="$CLIENT_SECRET" \
	| grep "Refresh Token:" | sed 's/Refresh Token: //')

if [ -z "$REFRESH_TOKEN" ]; then
	echo "Error: failed to obtain refresh token" >&2
	rm -f "$SECRETS_DIR/oauth_secret_${ACCOUNT}.gpg"
	exit 1
fi

# Encrypt refresh token
echo -n "$REFRESH_TOKEN" | gpg --batch -q --encrypt -r "$GPG_USER_ID" \
	-o "$SECRETS_DIR/oauth_${ACCOUNT}_refresh_token.gpg"
echo "Encrypted refresh token to secrets/oauth_${ACCOUNT}_refresh_token.gpg"

# Create account directory and config
mkdir -p "$ACCOUNT_DIR"

cat > "$ACCOUNT_DIR/account.conf" <<EOF
EMAIL="$EMAIL"
REALNAME="$REALNAME"
CLIENT_ID="$CLIENT_ID"
AUTH_METHOD="oauth2"
IMAP_URL="$IMAP_URL"
SMTP_URL="$SMTP_URL"
EOF

cat > "$ACCOUNT_DIR/muttrc.rc" <<EOF
# vim: syntax=neomuttrc
# $ACCOUNT account — $EMAIL

set realname = "$REALNAME"
set from = "$EMAIL"
set imap_user = "$EMAIL"
set imap_oauth_refresh_command = "$PERSONAL_CONFIGS_DIR/bin/mutt_oauth.sh $ACCOUNT"
set imap_authenticators = "oauthbearer"
EOF

# Append msmtp account block
cat >> "$PERSONAL_CONFIGS_DIR/mutt/msmtprc" <<EOF

account $ACCOUNT
	host $(echo "$SMTP_URL" | cut -d: -f1)
	port $(echo "$SMTP_URL" | cut -d: -f2)
	auth xoauth2
	user $EMAIL
	from $EMAIL
	from_full_name  $REALNAME
	tls_certcheck off
	tls_starttls on
	passwordeval $PERSONAL_CONFIGS_DIR/bin/mutt_oauth.sh $ACCOUNT
EOF

echo ""
echo "Account '$ACCOUNT' created successfully."
echo "  Config:  $ACCOUNT_DIR/"
echo "  Secrets: $SECRETS_DIR/oauth_secret_${ACCOUNT}.gpg"
echo "           $SECRETS_DIR/oauth_${ACCOUNT}_refresh_token.gpg"
echo "  msmtprc: block appended"
echo ""
echo "Launch with: MUTT_MAILBOX=$ACCOUNT neomutt"
echo "Or use:      pickmutt"
