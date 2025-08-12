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

    claude-code
    claude-code-router
)

pkg=$(
    IFS=" "
    echo "${pkg[*]}"
)

yay -S $pkg
