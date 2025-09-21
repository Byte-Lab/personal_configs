#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

set -o vi
export EDITOR=vim
export GPG_TTY=$(tty)

# Wayland variant:
alias flipkeys="set org.gnome.desktop.input-sources xkb-options \[\'caps:escape\'\]s"

# X variant:
# alias flipkeys="setxkbmap -option caps:swapescape"
export PATH="$PATH:/snap/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/intel/oneapi/vtune/latest/bin64"
export PATH="$PATH:$UPSTREAM_DIR/sched_ext/tools/perf"
export PATH="$PATH:$UPSTREAM_DIR/dbench"
export PATH="$PATH:$UPSTREAM_DIR/schedgraph"
export PATH="$PATH:$UPSTREAM_DIR/trace-cmd/tracecmd"
#export PATH="$PATH:$UPSTREAM_DIR/virtme-ng"
#export PATH="$PATH:$UPSTREAM_DIR/virtme-ng/virtme/guest/bin"
export PATH="$PATH:$UPSTREAM_DIR/perfetto/out/linux"
export PATH="$PATH:$UPSTREAM_DIR/vapormark/bin"
export PATH="$PATH:$PERSONAL_CONFIGS_DIR/bin"

#export GPG_USER_ID="David Vernet <void@manifault.com>"
export GPG_USER_ID="F5504C7B7B8107B40EF9E97AA1148BB3207BCC33"
export MYGKEY="F5504C7B7B8107B40EF9E97AA1148BB3207BCC33"

function ls() {
	exa --color=always $@
}
alias claer=clear
alias clare=clear
alias clera=clear
alias clrea=clear
alias clerr=clear
alias clere=clear
alias clra=clear
alias clr=clear

alias ucd="cd $UPSTREAM_DIR"
alias scd="cd $UPSTREAM_DIR/sched_ext"
alias sscd="cd $UPSTREAM_DIR/sched_ext/tools/sched_ext"
export SCX_ST_DIR="$UPSTREAM_DIR/sched_ext/tools/testing/selftests/sched_ext"
alias sctcd="cd $SCX_ST_DIR"
alias scxcd="cd $UPSTREAM_DIR/scx"
alias scccd="cd $UPSTREAM_DIR/scx/rust/scx_utils/src"
alias sckcd="cd $UPSTREAM_DIR/scx-kernel-releases"
alias sktcd="cd $UPSTREAM_DIR/scx-kernel-releases/tools/testing/selftests/scx"
alias scrcd="cd $UPSTREAM_DIR/scx/scheds/rust/scx_rusty/src"
alias scbcd="cd $UPSTREAM_DIR/scx/scheds/rust/scx_bolt"
alias scbrcd="cd $UPSTREAM_DIR/scx/scheds/rust/scx_bolt/src"
alias sclcd="cd $UPSTREAM_DIR/scx/scheds/rust/scx_lavd/src"
alias sclrcd="cd $UPSTREAM_DIR/scx/scheds/rust/scx_layered/src"
alias smcd="cd $UPSTREAM_DIR/scx_baremetal/"
alias sbmcd="cd $UPSTREAM_DIR/scx_baremetal/tools/sched_ext"
alias sncd="cd $UPSTREAM_DIR/sched_ext"
alias ssncd="cd $UPSTREAM_DIR/sched_ext/tools/sched_ext"
alias licd="cd $UPSTREAM_DIR/linus"
alias stcd="cd $UPSTREAM_DIR/stable"
alias dcd="cd $UPSTREAM_DIR/decave-linux"
alias bncd="cd $UPSTREAM_DIR/bpf-next"
alias bcd="cd $UPSTREAM_DIR/bpf"
alias bntcd="cd $UPSTREAM_DIR/bpf-next/tools/testing/selftests/bpf"
alias rcd="cd $UPSTREAM_DIR/rhone"
alias doccd="cd $UPSTREAM_DIR/linux-docs"
alias mocd="cd $UPSTREAM_DIR/monocle"
alias tcd="cd $UPSTREAM_DIR/tip"
alias vcd="cd $UPSTREAM_DIR/virtme-ng"
alias vpcd="cd $UPSTREAM_DIR/vapormark"
alias pcd="cd $UPSTREAM_DIR/linux-pm"

alias swapscreen="xrandr --output DP-5 --right-of DP-7"

alias editrc="nvim $PERSONAL_BASH_DIR/init.bash"
alias showrc="bat $PERSONAL_BASH_DIR/init.bash"
alias gb="git branch"

#export PATH="/home/void/upstream/in_path/llvm/latest/bin:$PATH"
#export PATH="/home/void/upstream/pahole/build:$PATH"
export PATH="/opt/clang/latest/bin:$PATH"
export PATH="$PATH:$HOME/.local/bin:$UPSTREAM_DIR/decave-linux/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:$HOME/intel/oneapi/vtune/latest/bin64"
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:/usr/share/bcc/tools"
export VMPY="$UPSTREAM_DIR/decave-osandov-linux/bin/vm.py"

# Perfetto
export PERFETTO_DIR="$UPSTREAM_DIR/perfetto/test/configs"

export VMLINUX="/usr/lib/modules/`uname -r`/build/vmlinux"

function vm() {
	$UPSTREAM_DIR/decave-osandov-linux/bin/vm.py $@
}
function runvm() {
	vm run -k $PWD $@ -- arch
}
function runvm2() {
	vm run -k $PWD $@ -- arch2
}
function editvm() {
	vim $UPSTREAM_DIR/decave-osandov-linux/bin/vm.py
}
alias sshvm="sshpass -p 1 ssh vm"
alias sshvm2="sshpass -p 1 ssh vm2"
flipkeys

function copy() {
	echo "$@" | xclip -selection clipboard -i
}

function lmake() {
	make LD=ld.lld LLVM=1 CC=clang $@
}
alias lmkae=lmake
alias kmake="lmake -j14 $@"
alias kmkae="lmake -j14 $@"
alias bigtest="lmake -j W=1 > /tmp/build.out 2> /tmp/build.out"

function vi() {
	vim $@
}

function bpfmail() {
	git send-email --to bpflist \
		--cc ast --cc dborkmann --cc andrii --cc martin \
		--cc song --cc yhs -cc jfastabend --cc kp \
		--cc sdf --cc hao --cc jiri --cc kernellist \
		--cc kernelteam $@ ~/patches/
}

function scxmail() {
	git send-email --to tj --cc kernellist --cc kernelteam  $@ ~/patches/
}

function llcmake() {
	cmake \
		-G Ninja \
		-DLLVM_TARGETS_TO_BUILD="BPF;X86" \
		-DCMAKE_INSTALL_PREFIX="/home/void/llvm/$(date +%Y%m%d)" \
		-DBUILD_SHARED_LIBS=OFF \
		-DLIBCLANG_BUILD_STATIC=ON \
		-DCMAKE_BUILD_TYPE=Release \
		-DLLVM_ENABLE_TERMINFO=OFF \
		-DLLVM_ENABLE_PROJECTS="clang;lld" \
		../llvm
}

function docmake() {
	rm -rf Documentation/output/*
	lmake -j SPHINXDIRS="$@" htmldocs
}
alias makedoc="docmake $@"
alias makedocs="docmake $@"
alias docsmake="docmake $@"
alias bpfdoc="docmake bpf"
export KERNEL_PATCHES_DIR="$HOME/patches"

function makepatch() {
	git format-patch -o $KERNEL_PATCHES_DIR $@
}

function bpfpatch() {
	git format-patch -o $KERNEL_PATCHES_DIR --subject-prefix='PATCH bpf-next' $@
}
function bpfspatch() {
	git format-patch -o $KERNEL_PATCHES_DIR --subject-prefix='PATCH bpf' $@
}
function refdocs() {
	git branch -D docs
	git checkout -b docs
}

function refrev() {
	git checkout for-6.13
	git branch -D review
	git checkout -b review
}

function poweroff() {
  echo "Calling poweroff on $HOSTNAME :-) ... ignoring"
}
function shutdown() {
  echo "Calling shutdown on $HOSTNAME :-) ... ignoring"
}
alias s3cd="cd /home/void/vms/s390"

export ARMCC_PATH=/home/void/crossc/aarch64/gcc-12.2.0-nolibc/aarch64-linux
function makearm() {
	make ARCH=aarch64 CROSS_COMPILE=aarch-64-linux- PATH=$ARMCC_PATH/bin:$PATH $@
}

export S390CC_PATH=/home/void/crossc/s390/gcc-12.2.0-nolibc/s390-linux
function makes390() {
	make ARCH=s390 CROSS_COMPILE=s390-linux- PATH=$S390CC_PATH/bin:$PATH $@
}
function makeibm() {
	makes390 $@
}
function runs390() {
	qemu-system-s390x \
		-cpu max,zpci=on \
		-smp 2 \
		-m 4G \
		-kernel $HOME/upstream/bpf-next/vmlinux \
		-drive file=$HOME/vms/s390/s390.img,if=virtio,format=raw \
		-nographic \
		-append 'root=/dev/vda rw console=ttyS1' \
		-virtfs local,path=$HOME/upstream/bpf-next,security_model=none,mount_tag=linux \
		-object rng-random,filename=/dev/urandom,id=rng0 \
		-device virtio-rng-ccw,rng=rng0 \
		-netdev user,id=net0 \
		-device virtio-net-ccw,netdev=net0
}

# Needed to run zoom
export QT_QPA_PLATFORM=wayland

export SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS=0

alias time="/usr/bin/time"
function prboost() {
	echo "echo 0 > /sys/devices/system/cpu/cpufreq/boost"
}

# Stop chef temporarily for 4 hours:
alias stopchef="/usr/facebook/ops/scripts/chef/stop_chef_temporarily -t 4"

# perf report --no-children -g "graph,0.2,callee"
# perf record -g -a

# opam configuration
#test -r /home/void/.opam/opam-init/init.sh && . /home/void/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
function tracerun() {
	trace-cmd record -e sched -v -e sched_stat_runtime $@
}
function resetb() {
	git branch -D last_checkout
	git branch -D bisecting 
	git branch last_checkout
	git checkout -b bisecting
}
alias sshfed="distrobox enter fedora"

function mbld() {
	meson compile -C build scx_bolt $@
	meson install -C build --no-rebuild
}

function mbld2() {
	meson compile -C build scx_rusty scx_layered $@
	meson install -C build --no-rebuild
}
function mbld3() {
	meson compile -C build scx_joule $@
	meson install -C build --no-rebuild
}
function msetup() {
	meson setup build --prefix ~ -D systemd=disabled --buildtype=debugoptimized $@
}
function mwsetup() {
	meson setup build --prefix ~ -D systemd=disabled --buildtype=debugoptimized --werror $@
}
function mdsetup() {
	meson setup build --prefix ~ -D systemd=disabled --buildtype=debug --werror $@
}

function btmux() {
	tmux -u -2 $@
}
alias makevng="BUILD_VIRTME_NG_INIT=1 pip install --break-system-packages ."
function vngbuild() {
	vng --verbose --build --config $SCX_ST_DIR/config $@
}
alias vngb="vngbuild --compiler=clang"
function vngr() {
	vng --verbose $@
}
function vngrt() {
	vngr --user root $@
}
function vngbpf() {
	vngrt -- tools/testing/selftests/bpf/test_progs $@
}
function vngbbpf() {
	vng --verbose --build --config tools/testing/selftests/bpf/config --compiler=clang $@
}
function vnggbbpf() {
	vng --verbose --build --config tools/testing/selftests/bpf/config $@
}
function vngscx() {
	vng --verbose -- tools/testing/selftests/sched_ext/runner $@
}
function vngrusty() {
	vng --verbose -- /home/void/bin/scx_rusty
}
function vngbscx() {
	vng --verbose --build --config tools/testing/selftests/sched_ext/config --compiler=clang $@
}

function sshagent() {
	eval `ssh-agent`
	ssh-add ~/.ssh/id_ed25519
}
function rusty() {
	sudo /home/void/bin/scx_rusty $@
}
export BOLT_DIR=$UPSTREAM_DIR/scx/scheds/rust/scx_bolt
function bolt() {
	sudo $BOLT_DIR/build/release/scx_bolt $@
}
function dbolt() {
	sudo $BOLT_DIR/build/debug/scx_bolt $@
}
#function bolt() {
	#sudo ~/bin/scx_bolt $@
#}
function bbolt() {
	cd $BOLT_DIR
	cargo build --release --target-dir "$BOLT_DIR/build"
	cd -
}
function bdbolt() {
	cd $BOLT_DIR
	cargo build --target-dir "$BOLT_DIR/build"
	cd -
}
function runepic() {
	flatpak run com.heroicgameslauncher.hgl $@
}

function vim() {
	nvim $@
}

function gpt() {
	chatgpt --api-key "$(gpg --batch -q --decrypt -r $GPG_USER_ID $PERSONAL_CONFIGS_DIR/secrets/chatgpt.gpg)" $@
}
