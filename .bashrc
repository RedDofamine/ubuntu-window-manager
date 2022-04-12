# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi
#gen_prompt() {
    ## Looks like:
    ## ╭─┤pty0├─╢mark@bender:~/src╟─┤(✿◠‿◠)├─╮
    ## ╰>
#    local __last_exit=$?
#    [[ -f ~/.colors ]] && source ~/.colors

#    local __line_color=${Red}
#    local __prompt_color=${White}
#    local __text_color=${White}

#    local __success_string="${Green}(✿◠‿◠)"
#    local __failure_string="${Red}(◡﹏◡✿)"
#    local __exit_string=$(if [[ $__last_exit -ne 0 ]]; then echo $__failure_string; else echo $__success_string; fi)
#    local __prompt="> "

#    PS1="\n${__line_color}╭─┤${__text_color}\l${__line_color}├─╢${__text_color}\u@\h:\w${__line_color}╟─┤${__exit_string}${__line_color}├─╮\n╰${__prompt}\[$(tput sgr0)\]"
#}
#export PROMPT_COMMAND=gen_prompt
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}
case "$TERM" in
xterm*|rxvt*)
    #PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    #PS1="\[\e[32m\][\[\e[m\]\[\e[31m\]\u\[\e[m\]\[\e[33m\]@\[\e[m\]\[\e[32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32;47m\]\\$\[\e[m\]$(parse_git_branch) "
    PS1="╭─╼[\[\e[1;36m\]\w\[\e[0m\]]-(\`if [ \$? = 0 ]; then echo \[\e[32m\]1\[\e[0m\]; else echo \[\e[31m\]0\[\e[0m\]; fi\`)-[\[\e[1;32m\]\h\[\e[0m\]]\n╰─ \u\$(if git rev-parse --git-dir > /dev/null 2>&1; then echo '@git:('; fi)\[\e[1;34m\]\$(parse_git_branch)\[\e[0m\]\$(if git rev-parse --git-dir > /dev/null 2>&1; then echo ')'; fi) >> "
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


### ARCHIVE EXTRACTION
# usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case $1 in
      *.tar.bz2)   sudo tar xjf $1   ;;
      *.tar.gz)    sudo tar xzf $1   ;;
      *.bz2)       sudo bunzip2 $1   ;;
      *.rar)       sudo unrar x $1   ;;
      *.gz)        sudo gunzip $1    ;;
      *.tar)       sudo tar xf $1    ;;
      *.tbz2)      sudo tar xjf $1   ;;
      *.tgz)       sudo tar xzf $1   ;;
      *.zip)       sudo unzip $1     ;;
      *.Z)         sudo uncompress $1;;
      *.7z)        sudo 7z x $1      ;;
      *.deb)       sudo ar x $1      ;;
      *.tar.xz)    sudo tar xf $1    ;;
      *.tar.zst)   sudo unzstd $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

#alias lf='exa --color=always --ignore-'
alias ls='exa -lh --no-time --no-filesize --no-permissions --group-directories-first --color=always'
alias ll='exa -lahg --git --color=always --group-directories-first' # long format
alias llg='exa -lahg --git --git-ignore --color=always --group-directories-first'
alias gt='exa -lhgT --git --color=always'
alias gtig='exa -lhgT --git --color=always'
alias lt="exa -lhgT --no-time --no-filesize --color=always -L" # list tree format

#alias ls='exa -al --color=always --group-directories-first' # my preferred listing
#alias la='exa -a --color=always --group-directories-first'  # all files and dirs
#alias ll='exa -l --color=always --group-directories-first'  # long format
#alias lt='exa -aT --color=always --group-directories-first' # tree listing
#alias l.='exa -a | egrep "^\."'


# some more ls aliases
#alias ll='ls -alF'
#alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ "$TERM" = "linux" ]; then
        printf %b '\e[40m' '\e[8]' # set default background to color 0 'dracula-bg'
        printf %b '\e[37m' '\e[8]' # set default foreground to color 7 'dracula-fg'
        printf %b '\e]P0282a36'    # redefine 'black'          as 'dracula-bg'
        printf %b '\e]P86272a4'    # redefine 'bright-black'   as 'dracula-comment'
        printf %b '\e]P1ff5555'    # redefine 'red'            as 'dracula-red'
        printf %b '\e]P9ff7777'    # redefine 'bright-red'     as '#ff7777'
        printf %b '\e]P250fa7b'    # redefine 'green'          as 'dracula-green'
        printf %b '\e]PA70fa9b'    # redefine 'bright-green'   as '#70fa9b'
        printf %b '\e]P3f1fa8c'    # redefine 'brown'          as 'dracula-yellow'
        printf %b '\e]PBffb86c'    # redefine 'bright-brown'   as 'dracula-orange'
        printf %b '\e]P4bd93f9'    # redefine 'blue'           as 'dracula-purple'
        printf %b '\e]PCcfa9ff'    # redefine 'bright-blue'    as '#cfa9ff'
        printf %b '\e]P5ff79c6'    # redefine 'magenta'        as 'dracula-pink'
        printf %b '\e]PDff88e8'    # redefine 'bright-magenta' as '#ff88e8'
        printf %b '\e]P68be9fd'    # redefine 'cyan'           as 'dracula-cyan'
        printf %b '\e]PE97e2ff'    # redefine 'bright-cyan'    as '#97e2ff'
        printf %b '\e]P7f8f8f2'    # redefine 'white'          as 'dracula-fg'
        printf %b '\e]PFffffff'    # redefine 'bright-white'   as '#ffffff'
        clear
fi