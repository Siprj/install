alias vim="nvim"
export EDITOR=nvim
export ZK_NOTEBOOK_DIR=/home/yrid/Dropbox/notes
alias hx="helix"
alias ls="ls --color=tty"
alias ll="ls --color=tty -lah"

function check_install_or_update() {
    if [[ ! -e "${HOME}/.zsh/update_time" ]]; then 
        install_or_update
        touch "${HOME}/.zsh/update_time"
    else
        let last_touch_time=$(date +%Y%m%d -r "${HOME}/.zsh/update_time")
        let current_time=$(date +%Y%m%d)
        let "diff = $current_time - $last_touch_time"
        if [[ ${diff} -gt 5 ]]; then
            install_or_update
            touch "${HOME}/.zsh/update_time"
        fi
    fi
}

function install_or_update() {
    if [ -d "${HOME}/.zsh/catppuccin-zsh-syntax-highlighting" ]; then
        (cd "${HOME}/.zsh/catppuccin-zsh-syntax-highlighting" && git pull --rebase)
    else
        git clone https://github.com/catppuccin/zsh-syntax-highlighting \
            "${HOME}/.zsh/catppuccin-zsh-syntax-highlighting"
    fi
    if [ -d "${HOME}/.zsh/zsh-completions" ]; then
        (cd "${HOME}/.zsh/zsh-completions" && git pull --rebase)
    else
        git clone https://github.com/zsh-users/zsh-completions \
            "${HOME}/.zsh/zsh-completions"
    fi
    if [ -d "${HOME}/.zsh/zsh-syntax-highlighting" ]; then
        (cd "${HOME}/.zsh/zsh-syntax-highlighting" && git pull --rebase)
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting \
            "${HOME}/.zsh/zsh-syntax-highlighting"
    fi
}

check_install_or_update

autoload -U select-word-style
select-word-style bash

setopt correct_all

autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit
compinit -C -i

zmodload -i zsh/complist

fpath+="${HOME}/.zsh/zsh-completions/src"

# Look at more completion tricks
# https://thevaluable.dev/zsh-completion-guide-examples/
#
setopt auto_list # automatically list choices on ambiguous completion
#setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "${HOME}/.zsh/cache/"

alias history="builtin fc -l -i"
HISTSIZE=50000
SAVEHIST=10000
HISTFILE="${HOME}/.zsh_history"
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt share_history          # share command history data

# Key binds (mostly stolen from oh-my-zsh)
bindkey -e

autoload zsh/terminfo
# Important for terminfo to be populated correctly.
function zle-line-init () {
    echoti smkx
}
function zle-line-finish () {
    echoti rmkx
}
zle -N zle-line-init
zle -N zle-line-finish

#
# Some of the terminfo codes are based on
# https://github.com/kovidgoyal/kitty/issues/1220
#

# [PageUp] - Up a line of history
if [[ -n "${terminfo[kpp]}" ]]; then
    bindkey -M emacs "${terminfo[kpp]}" up-line-or-history
else
    echo "Can't bind terminfo[kpp]"
fi

# [PageDown] - Down a line of history
if [[ -n "${terminfo[knp]}" ]]; then
    bindkey -M emacs "${terminfo[knp]}" down-line-or-history
else
    echo "Can't bind terminfo[knp]"
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search
#    bindkey -M emacs "${terminfo[kcuu1]}" history-beginning-search-backward
    bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
else
    echo "Can't bind terminfo[kcuu1]"
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search

#    bindkey -M emacs "${terminfo[kcud1]}" history-beginning-search-forward
    bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
else
    echo "Can't bind terminfo[kcud1]"
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
    bindkey -M emacs "${terminfo[khome]}" beginning-of-line
else
    echo "Can't bind terminfo[khome]"
fi

# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
    bindkey -M emacs "${terminfo[kend]}"  end-of-line
else
    echo "Can't bind terminfo[kend]"
fi

# [Shift-Tab] - move through the completion menu backwards
if [[ -n "${terminfo[kcbt]}" ]]; then
    bindkey -M emacs "${terminfo[kcbt]}" reverse-menu-complete
else
    echo "Can't bind terminfo[kcbt]"
fi

# [Backspace] - delete backward
if [[ -n "${terminfo[kbs]}" ]]; then
    bindkey -M emacs "${terminfo[kbs]}" backward-delete-char
else
    echo "Can't bind terminfo[kbs]"
fi

# [Delete] - delete forward
if [[ -n "${terminfo[kdch1]}" ]]; then
    bindkey -M emacs "${terminfo[kdch1]}" delete-char
else
    echo "Can't bind terminfo[kdch1]"
fi

# [Ctrl-Delete] - delete whole forward-word
if [[ -n "${terminfo[kDC5]}" ]]; then
    bindkey -M emacs "${terminfo[kDC5]}" kill-word
else
    echo "Can't bind terminfo[kDC5]"
fi

# [Ctrl-RightArrow] - move forward one word
if [[ -n "${terminfo[kRIT5]}" ]]; then
    bindkey -M emacs "${terminfo[kRIT5]}" forward-word
else
    echo "Can't bind terminfo[kRIT5]"
fi

# [Ctrl-LeftArrow] - move backward one word
if [[ -n "${terminfo[kLFT5]}" ]]; then
    bindkey -M emacs "${terminfo[kLFT5]}" backward-word
else
    echo "Can't bind terminfo[kLFT5]"
fi

bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space                               # [Space] - don't do history expansion

# Edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

source "${HOME}/.zsh/terminal-title.zsh"

source "${HOME}/.zsh/catppuccin-zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh"

# This one needs to be the last one according to the documentation.
source "${HOME}/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

eval "$(oh-my-posh init zsh --config ${HOME}/install/headline-base.omp.json)"
