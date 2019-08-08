export ZDOTDIR=~/.zsh

# site-specific
[ -f $ZDOTDIR/.zshenv_`uname` ] && . $ZDOTDIR/.zshenv_`uname`
[ -f $ZDOTDIR/.zshenv_local ] && . $ZDOTDIR/.zshenv_local
