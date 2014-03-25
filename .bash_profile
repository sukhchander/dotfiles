export DISPLAY=:0.0
export EDITOR=/usr/local/bin/vim
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

`keychain -q ~/.ssh/sukhchander-macbook-air-kp`
. ~/.keychain/$HOSTNAME-sh

test -e ~/.dircolors && eval `dircolors -b ~/.dircolors`

export RBENV_ROOT=/usr/local/var/rbenv
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
fi
source $(brew --prefix)/etc/bash_completion.d/git-prompt.sh

export GREP_COLOR=31
alias grep="grep --color=auto"
alias ll="ls -lha --color=auto"
alias l="ls -lh --color=auto"
alias b="cd .."
alias vi="vim"
alias mysql="`which mysql` -u root"
alias listen="netstat -atn | grep LISTEN"

# http://henrik.nyh.se/2008/12/git-dirty-prompt
# http://www.simplisticcomplexity.com/2008/03/13/show-your-git-branch-name-in-your-prompt/
#   username@Machine ~/dev/dir[master]$   # clean working directory
#   username@Machine ~/dev/dir[master*]$  # dirty working directory

gitStatus() {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*";
}
gitBranch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(gitStatus)]/" ;
}

function prompt {
  local RED="\[\033[0;31m\]"
  local LIGHT_RED="\[\033[1;31m\]"

  export PS1="\u@\h \[\e[32m\]\w\[\e[0m\]\n\[\e[0;31m\] \a\[\e[37;44;1m\]\t\[\e[0m\]$LIGHT_RED\$(gitBranch) \[\e[0m\]"
    PS2='> '
    PS4='+ '
}
prompt