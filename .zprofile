# antigen
. $ZDOTDIR/antigen/antigen.zsh

# site-specific
[ -f $ZDOTDIR/.zprofile_local ] && . $ZDOTDIR/.zprofile_local

# https://github.com/riywo/anyenv
if [ -d ${HOME}/.anyenv ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
fi
