# KEYCHAIN
if keychain --agents ssh ~/.ssh/id_dsa ~/.ssh/id_exherbo ~/.ssh/id_github ~/.ssh/id_uni ~/.ssh/id_honei ; then
	for x in ~/.keychain/${HOSTNAME}-sh{,-*} ; do
		[[ -f ${x} ]] && source "${x}"
	done
fi

# ALIASES
alias ll="ls -l --color=auto"
man () {
    /usr/bin/man $* | col -b | /usr/bin/vim -c 'set ft=man nomod nolist' -;
}
diffgrep() {
	sed -ne 's/^--- \(.*\)\s(.*/In file \1:/p' -e "/${1}/p" ${2}
}

# SCM info
ps_scm_f() {
    local s=
    if [[ -d ".svn" ]] ; then
        local r=$(svn info | sed -n -e '/^Revision: \([0-9]*\).*$/s//\1/p' )
        s="(r$r$(svn status | grep -q -v '^?' && echo -n "*" ))"
    else
        local d=$(git rev-parse --git-dir 2>/dev/null ) b= r= a=
        if [[ -n "${d}" ]] ; then
            if [[ -d "${d}/../.dotest" ]] ; then
                if [[ -f "${d}/../.dotest/rebase" ]] ; then
                    r="rebase"
                elif [[ -f "${d}/../.dotest/applying" ]] ; then
                    r="am"
                else
                    r="???"
                fi
                b=$(git symbolic-ref HEAD 2>/dev/null )
            elif [[ -f "${d}/.dotest-merge/interactive" ]] ; then
                r="rebase-i"
                b=$(<${d}/.dotest-merge/head-name)
            elif [[ -d "${d}/../.dotest-merge" ]] ; then
                r="rebase-m"
                b=$(<${d}/.dotest-merge/head-name)
            elif [[ -f "${d}/MERGE_HEAD" ]] ; then
                r="merge"
                b=$(git symbolic-ref HEAD 2>/dev/null )
            elif [[ -f "${d}/BISECT_LOG" ]] ; then
                r="bisect"
                b=$(git symbolic-ref HEAD 2>/dev/null )"???"
            else
                r=""
                b=$(git symbolic-ref HEAD 2>/dev/null )
            fi

            if git status | grep -q '^# Changed but not updated:' ; then
                a="${a}*"
            fi

            if git status | grep -q '^# Changes to be committed:' ; then
                a="${a}+"
            fi

            if git status | grep -q '^# Untracked files:' ; then
                a="${a}?"
            fi

            b=${b#refs/heads/}
            b=${b// }
            [[ -n "${r}${b}${a}" ]] && s="(${r:+${r}:}${b}${a:+ ${a}})"
        fi
    fi
    s="${s}${ACTIVE_COMPILER}"
    s="${s:+${s} }"
    echo -n "$s"
}

# EXPORTS
export PS1='\[\033[01;32m\]\u@\h \[\033[01;33m\]\W $(ps_scm_f)\$ \[\033[00m\]'
export CFLAGS="-O2 -g -march=native"
export CXXFLAGS=$CFLAGS
