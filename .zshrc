### zplug
[ ! -d ~/.zplug ] && curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
. ~/.zplug/init.zsh

zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
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
HISTFILE=~/.zsh/history
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
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:$(brew --prefix)/share/zsh-completions:$FPATH"
fi
autoload -Uz compinit; compinit
setopt list_packed
setopt noautoremoveslash
setopt complete_aliases

# ignore case in completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# cache the completions
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh

setopt auto_pushd
setopt pushd_ignore_dups
zstyle ':completion:*:cd:*' ignore-parents parent pwd

## Misc
setopt correctall
setopt magic_equal_subst
setopt prompt_subst
setopt notify
setopt extended_glob
setopt ignoreeof
setopt hist_ignore_dups
setopt hist_ignore_space
REPORTTIME=3

### PROMPT
## SSH?
[ -n "$SSH_CONNECTION" ] && SSH_PROMPT="%F{white}%m%f "

## VCS RPROMPT
# http://qiita.com/mollifier/items/8d5a627d773758dd8078
autoload -Uz vcs_info

zstyle ':vcs_info:*' formats '(%s)%b' '%c%u'
zstyle ':vcs_info:*' actionformats '(%s)%b' '%c%u' '<!%a>'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "+"
zstyle ':vcs_info:*' unstagedstr "-"

function __update_vcs_info_msg() {
  local -a messages
  local prompt

  LANG=en_US.UTF-8 vcs_info

  if [[ -z ${vcs_info_msg_0_} ]]; then
    # vcs_info で何も取得していない場合はプロンプトを表示しない
    prompt=""
  else
    # vcs_info で情報を取得した場合
    # $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
    # それぞれ緑、黄色、赤で表示する
    [[ -n "$vcs_info_msg_0_" ]] && messages+=("%F{green}${vcs_info_msg_0_}%f")
    [[ -n "$vcs_info_msg_1_" ]] && messages+=("%F{yellow}${vcs_info_msg_1_}%f")
    [[ -n "$vcs_info_msg_2_" ]] && messages+=("%F{red}${vcs_info_msg_2_}%f")

    # 間にスペースを入れて連結する
    prompt="${(j: :)messages} "
  fi

  echo "$prompt"
}


PROMPT='${SSH_PROMPT}[%{$fg_bold[yellow]%}%D{%D %r}%{$reset_color%}] %F{cyan}%B%~%b%f
%(?.%F{green}.%F{red})%?%f${PROMPT_ADDITION} %#%f%b '
RPROMPT='[`__update_vcs_info_msg`%F{green}%n%f@%m]'

## kubernetes

alias ku=kubectl

# completion for kubernetes
# original: https://github.com/petitviolet/dotfiles/blob/f7fde53ebea10ec9b7b4d19d167490396a89876a/_zshrc.alias

function __kubernetes_pod() {
  local SELECTED=$(kubectl get pod -a | fzf | awk '{print $1}')
  LBUFFER+=$SELECTED
}
zle -N __kubernetes_pod
bindkey "^x^kp" __kubernetes_pod

function __kubernetes_namespace() {
  local SELECTED=$(kubectl get namespace | awk '{print $1}' | fzf | tr -d '\n')
  LBUFFER+=$SELECTED
}
zle -N __kubernetes_namespace
bindkey "^x^kn" __kubernetes_namespace

function __kubernetes_use_context()
{
  local SELECTED=$(kubectl config get-contexts | awk '{print $2}' | fzf | tr -d '\n')
  LBUFFER="kubectl config use-context ${SELECTED}"
  zle accept-line
}
zle -N __kubernetes_use_context
bindkey "^x^k^uc" __kubernetes_use_context

function __kubernetes_use_ns()
{
  local SELECTED=$(kubectl get namespace | awk '{print $1}' | fzf | tr -d '\n')
  LBUFFER="kubectl config set-context $(kubectl config current-context) --namespace=${SELECTED}"
  zle accept-line
}
zle -N __kubernetes_use_ns
bindkey "^x^k^un" __kubernetes_use_ns

## site-specific
[ -f $ZDOTDIR/.zshrc_`uname` ] && . $ZDOTDIR/.zshrc_`uname`
[ -f $ZDOTDIR/.zshrc_local ] && . $ZDOTDIR/.zshrc_local || return 0
