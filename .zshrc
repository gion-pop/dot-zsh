## antigen
# Load the oh-my-zsh's library.
#antigen use oh-my-zsh

# Bundles from the default app.
antigen-bundles <<EOBUNDLES
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-completions
b4b4r07/enhancd
EOBUNDLES

# Tell antigen that you're done.
antigen-apply

## history
HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_save_nodups
setopt share_history

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

## completion
autoload -Uz compinit; compinit
autoload -Uz predict-on; predict-on
setopt list_packed
setopt noautoremoveslash
setopt complete_aliases

# ignore case in completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# cache the completions
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh

## misc
setopt correctall
setopt magic_equal_subst
setopt prompt_subst
setopt notify
setopt extended_glob
setopt ignoreeof
REPORTTIME=3

## enhancd filter
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## site-specific
[ -f $ZDOTDIR/.zshrc_`uname` ] && . $ZDOTDIR/.zshrc_`uname`
[ -f $ZDOTDIR/.zshrc_local ] && . $ZDOTDIR/.zshrc_local
