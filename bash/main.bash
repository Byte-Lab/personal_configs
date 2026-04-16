source "$PERSONAL_BASH_DIR/environ.bash"
source "$PERSONAL_BASH_DIR/fzf.bash"
source "$PERSONAL_BASH_DIR/init.bash"
source "$PERSONAL_BASH_DIR/mutt.bash"

# Host-specific config, not tracked by git. See local.bash.example for the
# template. Sourced last so it can override or extend anything above.
[ -f "$PERSONAL_BASH_DIR/local.bash" ] && source "$PERSONAL_BASH_DIR/local.bash"
