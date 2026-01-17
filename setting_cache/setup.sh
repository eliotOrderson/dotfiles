#!/bin/bash

# 定义仓库地址和本地路径
REPO_URL="https://github.com/eliotOrderson/dotfiles.git"
DOT_DIR="$HOME/.dotfiles"

# 1. 浅克隆裸仓库
echo "正在克隆仓库..."
git clone --bare --depth 1 "$REPO_URL" "$DOT_DIR"

# 2. 定义临时别名函数以便在脚本内使用
function config {
    /usr/bin/git --git-dir="$DOT_DIR" --work-tree="$HOME" "$@"
}

# 3. 核心配置：不显示未追踪文件，防止终端卡顿
config config --local status.showUntrackedFiles no
