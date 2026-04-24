#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

set -o vi
export EDITOR=nvim
export GPG_TTY=$(tty)

# Wayland variant:
alias flipkeys="set org.gnome.desktop.input-sources xkb-options \[\'caps:escape\'\]s"

# X variant:
# alias flipkeys="setxkbmap -option caps:swapescape"
export PATH="$PATH:/snap/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$PERSONAL_CONFIGS_DIR/bin"

#export GPG_USER_ID="David Vernet <void@manifault.com>"
export GPG_USER_ID="F5504C7B7B8107B40EF9E97AA1148BB3207BCC33"
export MYGKEY="F5504C7B7B8107B40EF9E97AA1148BB3207BCC33"

function ls() {
	eza --color=always $@
}
alias claer=clear
alias clare=clear
alias clera=clear
alias clrea=clear
alias clerr=clear
alias clere=clear
alias clra=clear
alias clr=clear

alias editrc="nvim $PERSONAL_BASH_DIR/init.bash"
alias showrc="batcat $PERSONAL_BASH_DIR/init.bash"
alias gb="git branch"

#export PATH="/home/void/upstream/in_path/llvm/latest/bin:$PATH"
#export PATH="/home/void/upstream/pahole/build:$PATH"
export PATH="/opt/clang/latest/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/bin"

flipkeys

function copy() {
	echo "$@" | xclip -selection clipboard -i
}

function unlock_pgp() {
	gpg --batch -q --decrypt -r $GPG_USER_ID $PERSONAL_CONFIGS_DIR/secrets/claude_api_key.gpg > /dev/null
}

function vi() {
	vim $@
}

function poweroff() {
  echo "Calling poweroff on $HOSTNAME :-) ... ignoring"
}
function shutdown() {
  echo "Calling shutdown on $HOSTNAME :-) ... ignoring"
}

# Needed to run zoom
export QT_QPA_PLATFORM=wayland

export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

alias time="/usr/bin/time"

# perf report --no-children -g "graph,0.2,callee"
# perf record -g -a

# opam configuration
#test -r /home/void/.opam/opam-init/init.sh && . /home/void/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

function btmux() {
	tmux -u -2 $@
}

function sshagent() {
	eval `ssh-agent`
	ssh-add ~/.ssh/id_ed25519
}

function vim() {
	nvim $@
}
