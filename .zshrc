# Coreys zsh shell config

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[green]%}[%{$fg[blue]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[blue]%}%~%{$fg[green]%}]%{$fg[blue]%}$%b "
# PS1="%B%{$fg[red]%~ $fg[blue]>>>$reset_color%}%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# change font size
alias bf="big-font"
alias sf="small-font"

# some general aliases
alias vi="nvim"
alias hx="helix"
alias d="sudo"
alias doas="sudo"
alias dvi="sudo nvim"
alias novi="nvim -u NONE"
alias p="sudo pacman"
alias y="yay"
alias cp="cp -r"
alias mkdir="mkdir -pv"
alias g="git"
alias py="python3"
alias msi="make && sudo make install"
alias t="tmux"
alias tka="tmux kill-session -a"
alias e="exit"

# window swallowing
alias i="devour nsxiv -a"
alias m="devour mpv"
alias z="devour zathura"

# add colour
alias ls="exa -lh --color=auto --group-directories-first --icons"
alias la="exa -lah --color=auto --group-directories-first --icons"
alias grep="grep --color=auto"
alias ccat="highlight --out-format=ansi --force"

# other things
# alias dmenu='dmenu_run -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15"'
# alias dmenu_run='dmenu_run -nb "$color0" -nf "$color15" -sb "$color1" -sf "$color15"'

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp" >/dev/null
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

bindkey -s '^a' 'R -q # Calculator\n'

bindkey -s '^f' 'cd "$(dirname "$(fzf)")" # Fuzzy file finder\n'

bindkey '^[[P' delete-char

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' 'exit\n'

# pfetch
pfetch

# Load syntax highlighting; should be last.
source $HOME/.local/src/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
