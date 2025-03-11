#  Startup 
# Commands on startup (before the prompt is shown)
# This is a good place to load graphic/ascii art, display system information, etc.

# pokego --no-title -r 1,3,6
# fastfetch --logo-type kitty
# fastfetch.sh

#  Aliases 
# Override aliases here or in '~/.zshrc' (already set in .zshenv)

# # Helpful aliases
# alias c='clear'                                                        # clear terminal
# alias l='eza -lh --icons=auto'                                         # long list
# alias ls='eza -1 --icons=auto'                                         # short list
# alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
# alias ld='eza -lhD --icons=auto'                                       # long list dirs
# alias lt='eza --icons=auto --tree'                                     # list folder as tree
# alias un='$aurhelper -Rns'                                             # uninstall package
# alias up='$aurhelper -Syu'                                             # update system/package/aur
# alias pl='$aurhelper -Qs'                                              # list installed package
# alias pa='$aurhelper -Ss'                                              # list available package
# alias pc='$aurhelper -Sc'                                              # remove unused cache
# alias po='$aurhelper -Qtdq | $aurhelper -Rns -'                        # remove unused packages, also try > $aurhelper -Qqd | $aurhelper -Rsu --print -
# alias vc='code'                                                        # gui code editor
# alias fastfetch='fastfetch --logo-type kitty'

# # Directory navigation shortcuts
# alias ..='cd ..'
# alias ...='cd ../..'
# alias .3='cd ../../..'
# alias .4='cd ../../../..'
# alias .5='cd ../../../../..'

# # Always mkdir a path (this doesn't inhibit functionality to make a single dir)
# alias mkdir='mkdir -p'

#  Plugins 
# manually add your oh-my-zsh plugins here
plugins=(
    "sudo"
    "zsh-256color"
    # "git"                     # (default)
    # "zsh-autosuggestions"     # (default)
    # "zsh-syntax-highlighting" # (default)
    # "zsh-completions"         # (default)
)

export HISTSIZE=10000
export SAVEHIST=10000
# export HISTFILE=~/.histfile

setopt INC_APPEND_HISTORY
# only save once in dupliction command
setopt HIST_IGNORE_DUPS
# add timestamp
#setopt EXTENDED_HISTORY
 
# enable cd histrory
setopt AUTO_PUSHD
# only save once in dupliction path 
setopt PUSHD_IGNORE_DUPS
 
#在命令前添加空格，不将此命令添加到纪录文件中
#setopt HIST_IGNORE_SPACE

# not save dupliction histrory 
setopt hist_ignore_all_dups
# when command prefix has space not save command to histrory file
setopt hist_ignore_space
# zsh 4.3.6 doesn't have this option
setopt hist_fcntl_lock 2>/dev/null
setopt hist_reduce_blanks
setopt SHARE_HISTORY

export TERM=xterm
export PATH=$PATH:go/bin
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

source ~/.profile
function lf() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

alias vi="neovide"
alias rm-rf="/usr/bin/rm -rf "
alias rm="safe_rm.sh"
alias goto-trash="cd ~/.local/share/Trash/files/"
alias yay="paru $1 --bottomup --makepkg $HOME/.makepkg"
alias tar-mt="tar --use-compress-program=pigz -cvpf"
alias untar-mt="tar --use-compress-program=pigz -xvpf"

alias mirrors-fast="sudo reflector --verbose -l 200 -p https --sort rate --save /etc/pacman.d/mirrorlist"
alias mirrors-us-fast="sudo reflector --verbose --country 'United States' -l 200 -p https --sort rate --save /etc/pacman.d/mirrorlist"
alias mirrors-cn-fast="sudo reflector --verbose --country 'China' -l 202 -p https --sort rate --save /etc/pacman.d/mirrorlist"
alias mirrors-hk-fast="sudo reflector --verbose --country 'Hong Kong' -l 201 -p https --sort rate --save /etc/pacman.d/mirrorlist"

