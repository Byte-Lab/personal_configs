#!/bin/bash
#
# Bootstrap a fresh machine to use the personal configs.
#
# Safe to re-run — skips steps that are already done.
#
# Usage: ./bin/bootstrap.sh [module ...]
#
# With no arguments, sets up everything. Pass module names to set up
# only those:
#
#   ./bin/bootstrap.sh shell git tmux       # skip mutt
#   ./bin/bootstrap.sh shell                # shell only
#
# Available modules: shell, git, tmux, mutt

set -euo pipefail

CONFIGS_DIR="$(cd "$(dirname "$0")/.." && pwd)"

ALL_MODULES=(shell git tmux gpg mutt)

info()  { echo "  [+] $*"; }
skip()  { echo "  [-] $* (already done)"; }
warn()  { echo "  [!] $*" >&2; }

# ---------------------------------------------------------------------------
# Parse arguments — no args means all modules.
# ---------------------------------------------------------------------------
if [ $# -eq 0 ]; then
	MODULES=("${ALL_MODULES[@]}")
else
	MODULES=("$@")
fi

# Validate module names.
for mod in "${MODULES[@]}"; do
	found=0
	for valid in "${ALL_MODULES[@]}"; do
		[ "$mod" = "$valid" ] && found=1 && break
	done
	if [ "$found" -eq 0 ]; then
		echo "Unknown module: $mod" >&2
		echo "Available modules: ${ALL_MODULES[*]}" >&2
		exit 1
	fi
done

has_module() {
	local target="$1"
	for mod in "${MODULES[@]}"; do
		[ "$mod" = "$target" ] && return 0
	done
	return 1
}

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
echo "Modules: ${MODULES[*]}"
echo ""

# ---------------------------------------------------------------------------
# Shell — append source lines to ~/.bashrc
# ---------------------------------------------------------------------------
if has_module shell; then
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
fi

# ---------------------------------------------------------------------------
# Git
# ---------------------------------------------------------------------------
if has_module git; then
	echo "=== Git ==="
	link_config "$CONFIGS_DIR/gitconfig" "$HOME/.gitconfig"
	echo ""
fi

# ---------------------------------------------------------------------------
# Tmux
# ---------------------------------------------------------------------------
if has_module tmux; then
	echo "=== Tmux ==="
	link_config "$CONFIGS_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"
	echo ""
fi

# ---------------------------------------------------------------------------
# GPG
# ---------------------------------------------------------------------------
if has_module gpg; then
	echo "=== GPG ==="

	GNUPG_DIR="$HOME/.gnupg"
	if [ ! -d "$GNUPG_DIR" ]; then
		mkdir -m 700 "$GNUPG_DIR"
		info "created $GNUPG_DIR"
	fi

	link_config "$CONFIGS_DIR/gpg/gpg-agent.conf" "$GNUPG_DIR/gpg-agent.conf"

	echo ""
fi

# ---------------------------------------------------------------------------
# Mutt / msmtp
# ---------------------------------------------------------------------------
if has_module mutt; then
	echo "=== Mutt ==="

	link_config "$CONFIGS_DIR/mutt/muttrc"  "$HOME/.muttrc"
	link_config "$CONFIGS_DIR/mutt/msmtprc" "$HOME/.msmtprc"
	link_config "$CONFIGS_DIR/mutt/mailcap" "$HOME/.mailcap"

	for dir in "$HOME/.mutt/hcache" "$HOME/.mutt/mcache"; do
		if [ -d "$dir" ]; then
			skip "directory $dir"
		else
			mkdir -p "$dir"
			info "created $dir"
		fi
	done

	echo ""
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo "=== Done ==="
echo ""
echo "  Restart your shell or run:  source ~/.bashrc"
if has_module mutt; then
	echo "  Then try:                   pickmutt"
fi
echo ""
