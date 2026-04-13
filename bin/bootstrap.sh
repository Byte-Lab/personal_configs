#!/bin/bash
#
# Bootstrap a fresh machine to use the personal configs.
#
# Safe to re-run — skips steps that are already done.
#
# Usage: ./bin/bootstrap.sh

set -euo pipefail

CONFIGS_DIR="$(cd "$(dirname "$0")/.." && pwd)"

info()  { echo "  [+] $*"; }
skip()  { echo "  [-] $* (already done)"; }
warn()  { echo "  [!] $*" >&2; }

# ---------------------------------------------------------------------------
# Symlink helper: backs up existing file, then creates symlink.
# ---------------------------------------------------------------------------
link_config() {
	local src="$1" dst="$2"
	if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
		skip "$dst -> $src"
		return
	fi
	if [ -e "$dst" ] || [ -L "$dst" ]; then
		mv "$dst" "${dst}.bk.$(date +%s)"
		warn "backed up existing $dst"
	fi
	mkdir -p "$(dirname "$dst")"
	ln -s "$src" "$dst"
	info "$dst -> $src"
}

echo "Setting up personal configs from $CONFIGS_DIR"
echo ""

# ---------------------------------------------------------------------------
# 1. Shell — append source lines to ~/.bashrc
# ---------------------------------------------------------------------------
echo "=== Shell ==="

BASHRC="$HOME/.bashrc"

add_to_bashrc() {
	local line="$1"
	if grep -qF "$line" "$BASHRC" 2>/dev/null; then
		skip "bashrc already has: $line"
	else
		echo "$line" >> "$BASHRC"
		info "appended to ~/.bashrc: $line"
	fi
}

add_to_bashrc "export PERSONAL_CONFIGS_DIR=\"$CONFIGS_DIR\""
add_to_bashrc "source \"\$PERSONAL_CONFIGS_DIR/bash/environ.bash\""
add_to_bashrc "source \"\$PERSONAL_CONFIGS_DIR/bash/main.bash\""

echo ""

# ---------------------------------------------------------------------------
# 2. Git
# ---------------------------------------------------------------------------
echo "=== Git ==="

link_config "$CONFIGS_DIR/gitconfig" "$HOME/.gitconfig"

echo ""

# ---------------------------------------------------------------------------
# 3. Tmux
# ---------------------------------------------------------------------------
echo "=== Tmux ==="

link_config "$CONFIGS_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

echo ""

# ---------------------------------------------------------------------------
# 4. Mutt / msmtp
# ---------------------------------------------------------------------------
echo "=== Mutt ==="

link_config "$CONFIGS_DIR/mutt/muttrc"  "$HOME/.muttrc"
link_config "$CONFIGS_DIR/mutt/msmtprc" "$HOME/.msmtprc"
link_config "$CONFIGS_DIR/mutt/mailcap" "$HOME/.mailcap"

# Mutt cache directories
for dir in "$HOME/.mutt/hcache" "$HOME/.mutt/mcache"; do
	if [ -d "$dir" ]; then
		skip "directory $dir"
	else
		mkdir -p "$dir"
		info "created $dir"
	fi
done

echo ""

# ---------------------------------------------------------------------------
# 5. Summary
# ---------------------------------------------------------------------------
echo "=== Done ==="
echo ""
echo "  Restart your shell or run:  source ~/.bashrc"
echo "  Then try:                   pickmutt"
echo ""
