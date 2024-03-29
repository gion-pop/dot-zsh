# http://blog.manaten.net/entry/ssh-agent-forward
AGENT_SOCK_FILE="/tmp/ssh-agent-$USER"
SSH_AGENT_FILE="$HOME/.ssh-agent-info"
if test $SSH_AUTH_SOCK ; then
  if [ $SSH_AUTH_SOCK != $AGENT_SOCK_FILE ] ; then
    ln -sf $SSH_AUTH_SOCK $AGENT_SOCK_FILE
    export SSH_AUTH_SOCK=$AGENT_SOCK_FILE
  fi
else
  test -f $SSH_AGENT_FILE && source $SSH_AGENT_FILE
  if ! ssh-add -l >& /dev/null ; then
    ssh-agent > $SSH_AGENT_FILE
    source $SSH_AGENT_FILE
    ssh-add
  fi
fi

# site-specific
[ -f $ZDOTDIR/.zprofile_`uname` ] && . $ZDOTDIR/.zprofile_`uname`
[ -f $ZDOTDIR/.zprofile_local ] && . $ZDOTDIR/.zprofile_local

# https://github.com/anyenv/anyenv
if type anyenv > /dev/null; then
  eval "$(anyenv init -)"
fi

if type direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi
