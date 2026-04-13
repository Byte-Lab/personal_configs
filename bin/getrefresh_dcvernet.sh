#!/bin/bash

# Replace these with your actual values
CLIENT_ID="$DCVERNET_CLIENT_ID"
CLIENT_SECRET="$(gpg --batch -q --decrypt -r $GPG_USER_ID ~/.personal_configs/secrets/oauth_secret_dcvernet.gpg)"
#REDIRECT_URI="urn:ietf:wg:oauth:2.0:oob"
REDIRECT_URI="http://127.0.0.1:53682"
SCOPE="https://mail.google.com/"
AUTH_URL="https://accounts.google.com/o/oauth2/v2/auth"
TOKEN_URL="https://oauth2.googleapis.com/token"

# Step 1: Build the authorization URL
AUTH_REQUEST_URL="${AUTH_URL}?client_id=${CLIENT_ID}&redirect_uri=${REDIRECT_URI}&response_type=code&scope=${SCOPE}&access_type=offline&prompt=consent"

echo
echo "🔗 Visit the following URL in your browser to authorize:"
echo "$AUTH_REQUEST_URL"

# Optional: open browser automatically if on Linux with GUI
if command -v xdg-open &>/dev/null; then
  xdg-open "$AUTH_REQUEST_URL"
fi

# Step 2: Prompt user to paste authorization code
echo
read -p "📥 Enter the authorization code: " AUTH_CODE

# Step 3: Exchange authorization code for refresh/access tokens
RESPONSE=$(curl -s -X POST "$TOKEN_URL" \
  -d "code=${AUTH_CODE}" \
  -d "client_id=${CLIENT_ID}" \
  -d "client_secret=${CLIENT_SECRET}" \
  -d "redirect_uri=${REDIRECT_URI}" \
  -d "grant_type=authorization_code")

# Step 4: Extract tokens
ACCESS_TOKEN=$(echo "$RESPONSE" | jq -r .access_token)
REFRESH_TOKEN=$(echo "$RESPONSE" | jq -r .refresh_token)

# Step 5: Output
echo
echo "✅ Access Token:"
echo "$ACCESS_TOKEN"
echo
echo "🔒 Refresh Token (save this!):"
echo "$REFRESH_TOKEN"
