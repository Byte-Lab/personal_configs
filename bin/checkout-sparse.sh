#!/bin/bash
#
# Sparse-checkout the personal configs repo, materializing only the
# modules you need. Secrets and email configs never touch disk unless
# you opt in.
#
# Usage:
#   curl -sL <raw-url>/bin/checkout-sparse.sh | bash -s -- [module ...]
#
#   ./checkout-sparse.sh                     # shell, git, tmux, gpg, nvim (no mutt/secrets)
#   ./checkout-sparse.sh shell git           # only shell and git
#   ./checkout-sparse.sh all                 # full checkout, same as normal clone
#
# Available modules: shell, git, tmux, gpg, nvim, mutt
# "mutt" pulls in mutt/, accounts/, and secrets/.

set -euo pipefail

REPO="git@github.com:Decave/personal_configs.git"
DEST="$HOME/.personal_configs"

ALL_MODULES=(shell git tmux gpg nvim mutt)
DEFAULT_MODULES=(shell git tmux gpg nvim)

die() { echo "Error: $*" >&2; exit 1; }

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
if [ $# -eq 0 ]; then
	MODULES=("${DEFAULT_MODULES[@]}")
elif [ "$1" = "all" ]; then
	MODULES=()
else
	MODULES=("$@")
	for mod in "${MODULES[@]}"; do
		found=0
		for valid in "${ALL_MODULES[@]}"; do
			[ "$mod" = "$valid" ] && found=1 && break
		done
		[ "$found" -eq 0 ] && die "Unknown module: $mod (available: ${ALL_MODULES[*]}, all)"
	done
fi

# ---------------------------------------------------------------------------
# Map modules to sparse-checkout paths
# ---------------------------------------------------------------------------
PATHS=(CLAUDE.md .gitignore)

add_paths() {
	case "$1" in
		shell) PATHS+=(bash bin/bootstrap.sh) ;;
		git)   PATHS+=(gitconfig.example) ;;
		tmux)  PATHS+=(tmux) ;;
		gpg)   PATHS+=(gpg) ;;
		nvim)  PATHS+=(nvim) ;;
		mutt)  PATHS+=(mutt accounts secrets bin/oauth2.py bin/mutt_oauth.sh bin/add_mutt_account.sh) ;;
	esac
}

for mod in "${MODULES[@]}"; do
	add_paths "$mod"
done

# ---------------------------------------------------------------------------
# Clone and configure sparse-checkout
# ---------------------------------------------------------------------------
if [ -d "$DEST" ]; then
	die "$DEST already exists — remove it first or use 'git sparse-checkout set' inside it"
fi

if [ ${#MODULES[@]} -eq 0 ]; then
	echo "Cloning full repo to $DEST"
	git clone "$REPO" "$DEST"
else
	echo "Sparse-cloning to $DEST"
	echo "Modules: ${MODULES[*]}"
	echo ""

	git clone --no-checkout "$REPO" "$DEST"
	cd "$DEST"
	git sparse-checkout set --no-cone "${PATHS[@]}"
	git checkout
fi

echo ""
echo "Done. Next steps:"
echo "  cd $DEST"
echo "  ./bin/bootstrap.sh ${MODULES[*]}"
echo ""
