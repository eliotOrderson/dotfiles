#!/bin/bash

# trace array
trace_array=(
  "$HOME/.config/kitty/kitty.conf"
  "$HOME/.config/hypr/userprefs.conf"
  "$HOME/.config/fcitx5"
  "$HOME/.local/share/bin/windowoperation.sh"
  "$HOME/.local/share/bin/safe_rm.sh"
  "$HOME/.local/share/bin/autostart.sh"
  "$HOME/.zshrc"
  "$HOME/trace_file.sh"
)

# concatenate the trace array into a string
trace_string=$(
  IFS=" "
  echo "${trace_array[*]}"
)

mv $HOME/dotfiles/.git $HOME
git add $trace_string
git commit -m "$(date)"
mv .git $HOME/dotfiles -f

if [ $? -eq 0 ]; then
  echo "Files added successfully."
else
  echo "Error adding files."
fi