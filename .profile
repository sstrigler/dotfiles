export DISPLAY=:0.0

if [ -e ~/.aliases ]; then
	. ~/.aliases
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

#export CLICOLOR=true
export LANG=en_US.UTF-8
#export EDITOR=vi
#export NODE_PATH=/usr/local/lib/node_modules

#export LESS_TERMCAP_mb=$'\E[01;35m'
#export LESS_TERMCAP_md=$'\E[01;35m'
#export LESS_TERMCAP_me=$'\E[0m'
#export LESS_TERMCAP_se=$'\E[0m'
#export LESS_TERMCAP_so=$'\E[01;44;33m'
#export LESS_TERMCAP_ue=$'\E[0m'
#export LESS_TERMCAP_us=$'\E[01;32m'

#export PATH=$PATH:/usr/local/share/npm/bin
ulimit -n 1024

export ERL_AFLAGS="+pc unicode -kernel shell_history enabled"
