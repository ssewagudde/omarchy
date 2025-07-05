if ! command -v nvim &>/dev/null; then
  yay -S --noconfirm --needed nvim luarocks tree-sitter-cli

  # Install LazyVim
  rm -rf ~/.config/nvim
  cp -R ~/.local/share/omarchy/config/nvim/* ~/.config/nvim/
fi
