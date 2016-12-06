### zplug
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "b4b4r07/enhancd", use:init.sh

## fzf
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

zplug load --verbose


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
autoload -Uz colors; colors
setopt correctall
setopt magic_equal_subst
setopt prompt_subst
setopt notify
setopt extended_glob
setopt ignoreeof
REPORTTIME=3

## PROMPT
PROMPT_ADDITION=''
PROMPT='${SSH_PROMPT}[%{$fg_bold[yellow]%}%D{%D %r}%{$reset_color%}] %F{cyan}%B%~%b%f
%(?.%F{green}.%F{red})%?%f${PROMPT_ADDITION} %#%f%b '
RPROMPT='[%F{green}%n%f@%m]'

## site-specific
[ -f $ZDOTDIR/.zshrc_`uname` ] && . $ZDOTDIR/.zshrc_`uname`
[ -f $ZDOTDIR/.zshrc_local ] && . $ZDOTDIR/.zshrc_local
