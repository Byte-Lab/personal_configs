export MUTT_IMAP_URL="imap.gmail.com:993"
export MUTT_SMTP_URL="smtp.gmail.com:587"
export MUTT_MAILBOX=manifault

pickmutt() {
	local account
	account=$(ls "$PERSONAL_CONFIGS_DIR/accounts" | fzf --prompt="Mail account: ")
	[[ -z "$account" ]] && return 1

	# Ensure GPG key is unlocked before neomutt tries to decrypt
	# secrets in --batch mode (which suppresses pinentry).
	if ! gpg --decrypt -q -r "$GPG_USER_ID" \
		"$PERSONAL_CONFIGS_DIR/secrets/oauth_secret_${account}.gpg" \
		> /dev/null 2>&1; then
		echo "Failed to unlock GPG key — aborting." >&2
		return 1
	fi

	MUTT_MAILBOX="$account" neomutt
}
