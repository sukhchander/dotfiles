export DISPLAY=:0.0
export EDITOR=/usr/local/bin/vim
export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

`keychain ~/.ssh/sukhchander@gmail`
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
  st=$(git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]; then
      echo ''
  elif [[ $st == "nothing to commit (working directory clean)" ]]; then
      echo ''
  elif [[ $st == 'nothing added to commit but untracked files present (use "git add" to track)' ]]; then
      echo '?'
  else
      echo '*'
  fi
}
gitBranch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(gitStatus)]/" ;
}

function prompt {
  local RED="\[\033[0;31m\]"
  local LIGHT_RED="\[\033[1;31m\]"

  export PS1='\[\e[01;30m\]\t`if [ $? = 0 ]; then echo "\[\e[32m\] ✔ "; else echo "\[\e[31m\] ✘ "; fi`\[\e[00;37m\]\u\[\e[01;37m\]:`[[ $(git status 2> /dev/null | head -n2 | tail -n1) != "# Changes to be committed:" ]] && echo "\[\e[31m\]" || echo "\[\e[33m\]"``[[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] || echo "\[\e[32m\]"`$(__git_ps1 "(%s)\[\e[00m\]")\[\e[01;34m\]\w\[\e[00m\]\$ '
  #export PS1="\n\[\033[35m\]\$(/bin/date)\n\[\033[32m\]\w\n\[\033[1;31m\]\u@\h: \[\033[1;34m\]\$(/usr/bin/tty | /bin/sed -e 's:/dev/::'): \[\033[1;36m\]\$(/bin/ls -1 | /usr/bin/wc -l | /bin/sed 's: ::g') files \[\033[1;33m\]\$(/bin/ls -lah | /bin/grep -m 1 total | /bin/sed 's/total //')b\[\033[0m\] -> \[\033[0m\]"
}
prompt
alias pg="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log"
