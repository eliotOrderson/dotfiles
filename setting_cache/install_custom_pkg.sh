pkg=(
    rime-symbols
    rime-cloverpinyin

    fcitx5
    fcitx5-qt
    fcitx5-gtk
    fcitx5-rime
    fcitx5-configtool
    fcitx5-pinyin-custom-pinyin-dictionary

    neovim
    neovide

    google-chrome
    rclone

    claude-code
    claude-code-router
    docker
)

pkg=$(
    IFS=" "
    echo "${pkg[*]}"
)

yay -S $pkg

# other opertion
sudo usermod -aG docker $USER && newgrp docker
