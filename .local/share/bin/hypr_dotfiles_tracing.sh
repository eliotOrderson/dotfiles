#!/bin/bash
#!/bin/bash

#!/bin/bash

# --- 配置部分 ---
# 定义裸仓库的存放路径
DOTFILES_DIR="$HOME/.dotfiles"
# 定义 Git 命令的别名（核心魔法）
# --git-dir: 指定仓库位置
# --work-tree: 指定实际文件所在位置 (HOME)
MY_GIT="git --git-dir=$DOTFILES_DIR --work-tree=$HOME"

# trace array (你的原始列表)
trace_array=(
    "$HOME/.config/pip/pip.conf"
    "$HOME/.config/neovide/config.toml"
    "$HOME/.config/nvim/"
    "$HOME/.config/zed/"
    "$HOME/.config/kitty/kitty.conf"
    "$HOME/.config/user-dirs.dirs"
    "$HOME/.config/user-dirs.locale"
    "$HOME/.config/hypr/userprefs.conf"
    "$HOME/.config/hyde/config.toml"

    "$HOME/.config/fcitx5"
    "$HOME/.local/share/fcitx5"

    "$HOME/.local/share/bin/windowoperation.sh"
    "$HOME/.local/share/bin/autostart.sh"
    "$HOME/.local/share/bin/hypr_dotfiles_tracing.sh"

    "$HOME/.config/zsh/user.zsh"
    "$HOME/.config/zsh/.zshrc"
    "$HOME/.zsh_history"

    "$HOME/.makepkg"
    "$HOME/setting_cache"
)

# --- 逻辑部分 ---

# 1. 如果仓库不存在，则初始化
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "正在初始化裸仓库于: $DOTFILES_DIR ..."
    git init --bare "$DOTFILES_DIR"

    # 【关键配置】不显示未追踪的文件
    # 这就是解决终端性能和 status 乱七八糟的核心
    $MY_GIT config --local status.showUntrackedFiles no
else
    echo "检测到现有仓库，继续执行..."
fi

# 2. 遍历数组并添加文件
echo "正在添加文件..."
for item in "${trace_array[@]}"; do
    # 检查文件或目录是否存在
    if [ -e "$item" ]; then
        # 添加文件到暂存区
        $MY_GIT add "$item"
        echo "已添加: $item"
    else
        echo "跳过 (未找到): $item"
    fi
done

# 3. 显示当前状态
echo "------------------------------------------------"
echo "操作完成。当前暂存区状态："
$MY_GIT status

echo "------------------------------------------------"
echo "提示：以后手动管理，请在 .zshrc/.bashrc 中添加别名："
echo "alias config='/usr/bin/git --git-dir=$DOTFILES_DIR --work-tree=$HOME'"
