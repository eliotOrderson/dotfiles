#!/bin/bash

# trace array
trace_array=(
    "$HOME/.config/pip/pip.conf"
    "$HOME/.config/neovide/config.toml"
    "$HOME/.config/nvim/"
    "$HOME/.config/zed/"
    "$HOME/.config/kitty/kitty.conf"
    "$HOME/.config/hypr/userprefs.conf"
    "$HOME/.config/fcitx5"
    
    "$HOME/.local/share/bin/windowoperation.sh"
    "$HOME/.local/share/bin/safe_rm.sh"
    "$HOME/.local/share/bin/autostart.sh"
    "$HOME/.local/share/bin/hypr_dotfiles_tracing.sh"

    "$HOME/.hyde.zshrc"
    "$HOME/.zsh_history"
    "$HOME/.makepkg"
    "$HOME/setting_cache"
)

# concatenate the trace array into a string
trace_string=$(
    IFS=" "
    echo "${trace_array[*]}"
)

mv $HOME/.hypr-dotfiles/.git $HOME -f
git add $trace_string
git commit -m "auto commit"
mv $HOME/.git $HOME/.hypr-dotfiles -f

if [ $? -eq 0 ]; then
    echo "Files added successfully."
else
    echo "Error adding files."
fi
