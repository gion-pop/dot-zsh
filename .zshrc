if type mise > /dev/null; then
  eval "$(mise activate zsh)"
  eval "$(mise activate --shims)"
fi

if type direnv > /dev/null; then
  eval "$(direnv hook zsh)"
fi

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
# ignore case in completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# cache the completions
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.cache/zsh

if type brew &>/dev/null; then
  FPATH="${BREW_PREFIX}/share/zsh/site-functions $FPATH"
fi

autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

setopt list_packed
setopt noautoremoveslash
setopt complete_aliases

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
autoload -Uz colors && colors

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

if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

## site-specific
[ -f $ZDOTDIR/.zshrc_`uname` ] && . $ZDOTDIR/.zshrc_`uname`
[ -f $ZDOTDIR/.zshrc_local ] && . $ZDOTDIR/.zshrc_local

if (which zprof > /dev/null 2>&1) ;then
  zprof
fi
