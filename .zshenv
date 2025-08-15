export ZDOTDIR=~/.zsh

# uncommet to use zprof
# zmodload zsh/zprof && zprof

# site-specific
[ -f $ZDOTDIR/.zshenv_`uname` ] && . $ZDOTDIR/.zshenv_`uname`
[ -f $ZDOTDIR/.zshenv_local ] && . $ZDOTDIR/.zshenv_local
