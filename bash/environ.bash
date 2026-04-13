#
# environ.bash
#
# Defines the environment variables that are used by the rest of the personal
# configs system.
#

export UPSTREAM_DIR="$HOME/upstream"
export PERSONAL_CONFIGS_DIR="$HOME/.personal_configs"
export PERSONAL_TMUX_DIR="$PERSONAL_CONFIGS_DIR/tmux"
export PERSONAL_MUTT_DIR="$PERSONAL_CONFIGS_DIR/mutt"
export PERSONAL_BASH_DIR="$PERSONAL_CONFIGS_DIR/bash"

# Set timestamp format of `history` command to e.g. 2025-12-12 21:11:54 history
export HISTTIMEFORMAT='%F %T '
