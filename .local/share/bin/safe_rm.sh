#!/bin/bash

# Function to safely move files to the trash directory
safe_rm() {
  local target_dir="$HOME/.local/share/Trash/files/"
  mkdir -p "$target_dir"

  for file in "$@"; do
    local base_name=$(basename "$file")
    local base_name_no_ext="${base_name%.*}"

    local target_file="${target_dir}/${base_name}"
    local counter=1
    while [ -e "$target_file" ]; do
      # Generate a unique name by appending a number
      target_file="${target_dir}/${base_name_no_ext}_${counter}"
      ((counter++))
    done

    mv "$file" "$target_file"
  done
}

# Call the function with the provided arguments
safe_rm "$@"
