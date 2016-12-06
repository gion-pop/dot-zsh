# site-specific
[ -f $ZDOTDIR/.zprofile_local ] && . $ZDOTDIR/.zprofile_local

[ ! -d ~/.zplug ] && curl -sL zplug.sh/installer | zsh

. ~/.zplug/init.zsh

# https://github.com/riywo/anyenv
if [ -d ${HOME}/.anyenv ]; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
fi
