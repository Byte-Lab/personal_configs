# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
	local files
	IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
	[[ -n "$files" ]] && ${EDITOR:-nvim} "${files[@]}"
}

# fh - repeat history
fh() {
	eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}

# fdr - cd to selected parent directory
fdr() {
	local declare dirs=()
	get_parent_dirs() {
		if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
		if [[ "${1}" == '/' ]]; then
			for _dir in "${dirs[@]}"; do echo $_dir; done
		else
			get_parent_dirs $(dirname "$1")
		fi
	}
	local DIR=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
	cd "$DIR"
}

# fman - search man pages
fman() {
	local manpage
	manpage=$(man -k . | sort | fzf --preview='echo {} | awk '\''{print($2," ",$1)}'\'' | sed "s/[\(|\)]//g" | xargs man')
	echo "$manpage" | awk '{print($2," ",$1)}' | sed 's/[\(|\)]//g' | xargs man
}

# pid symbol search
pidsymbol () {
	local pid
	pid="$1"
	cat /proc/$pid/maps | cut -c 74- | sort | uniq | sort -n | while read line; do nm /proc/$pid/root$line 2>/dev/null; done| fzf -m
}

# perf trace program
pstat () {
	sudo ls >/dev/null
	local debugfs
	debugfs=$(mount | grep debugfs | cut -d ' ' -f3)
	local tracepoints
	tracepoints=$(sudo cat "${debugfs}/tracing/available_events" | fzf -m --preview='echo {} | sed "s/\:/\//g" | xargs -IX sudo cat "'${debugfs}'/tracing/events/X/format"')
	sudo perf stat -d -d -d -a -v -e $(echo ${tracepoints} | tr -s ' ' ',')  "$@"
}

# fkill - kill process
fkill() {
	local pid
	pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')

	if [ "x$pid" != "x" ]
	then
		echo $pid | xargs kill -${1:-9}
	fi
}

# perf trace pid
ppid () {
	sudo ls >/dev/null
	local debugfs
	debugfs=$(mount | grep debugfs | cut -d ' ' -f3)
	local tracepoints
	tracepoints=$(sudo cat "${debugfs}/tracing/available_events" | fzf -m --preview='echo {} | sed "s/\:/\//g" | xargs -IX sudo cat "'${debugfs}'/tracing/events/X/format"')
	if [ -z "$2" ]; then
		sudo perf stat -a -v -e $(echo ${tracepoints} | tr -s ' ' ',') -p $1
	else
		sudo perf record -s -n --group -a -v -e $(echo ${tracepoints} | tr -s ' ' ',') -p $1 -o $2
	fi
}

# ngrep tcp port
t4port () {
	local tport
	tport=$(sudo ss -tlpn4 | sed '1d' | tr -s ' ' | fzf --preview='echo {} | cut -d ":" -f2 | cut -d " " -f1 | sudo xargs -IX ngrep -W byline -d any -q "" "tcp port X"' | cut -d ':' -f2 | cut -d ' ' -f1)
	sudo ngrep -W byline -d any -q '' "tcp port $tport"
}

# ungrep- ngrep udp sockets
ungrep () {
	local filter
	filter=$(ss -au | grep -vi state | fzf -m | tr -s ' ' | cut -d ' ' -f4 | cut -d ':' -f1)
	ngrep -W byline -d any "$filter"
}

# pid trace per second using bpftrace
pidtrace () {
	local pid
	pid="$1"
	if [ -z "${pid}" ]; then
		echo "Usage: pidtrace <pid>"
		return 1
	fi
	sudo ls >/dev/null || true
	local tracepoints
	tracepoints=$(sudo bpftrace -l | sed 's/[:]$//g' | fzf -m --preview='echo {} | xargs -IX sudo bpftrace -p '${pid}' -e "X { @counts = count(); } interval:s:1 { exit(); }"')
	sudo bpftrace -lv "$tracepoints"
	sudo bpftrace -p "${pid}" -e "${tracepoints}  { @counts = count(); } interval:s:1 { print(@counts); clear(@counts); }"
}
