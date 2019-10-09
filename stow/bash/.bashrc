# Bash config 
export OSH=/home/ashia/.oh-my-bash

OSH_THEME="sexy"

# oh my bash plugins
plugins=(core git bashmarks progress)

if tty -s
then
  source $OSH/oh-my-bash.sh
fi

# autocomplete
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Ensure a ssh-agent is running so you only have to enter keys once
if [ ! -S ~/.ssh/ssh_auth_sock ]; then
    eval $(ssh-agent)
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock

# set history
HISTFILESIZE=1000000
HISTSIZE=1000000
shopt -s histappend
PROMPT_COMMAND="history -a;history -c;history -r;$PROMPT_COMMAND"

# for pet snippets
function pet-select() {
  BUFFER=$(pet search --query "$READLINE_LINE")
  READLINE_LINE=$BUFFER
  READLINE_POINT=${#BUFFER}
}
bind -x '"\C-x\C-r": pet-select'

# Less config
export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\e[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\e[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\e[0m'           # end underline
export LESS_TERMCAP_us=$'\e[04;38;5;146m' # begin underline

# set default editor
export EDITOR=nvim

# tmuxp configure template folder
export TMUXP_CONFIGDIR=$HOME/.tmux/templates

# Aliases
alias vim='nvim'
alias vimdiff='nvim -d'
alias copy='xclip -sel clip'
alias xp='xsel -i -b'

# docker get network address
dip () {
    docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$1"
}

# forward port from remote to local
sl () {
    if [ $# -eq 0 ]
    then
            echo 'Usage: sl $host $port $bindingaddress(optional)'
    else
            while true
            do
                    if [ -z "$3"]
                    then
                            ssh -nNT -L "$2":localhost:"$2" "$1"
                    else
                            ssh -nNT -L "$2":"$3":"$2" "$1"
                    fi
                    sleep 10
            done &
    fi
}
