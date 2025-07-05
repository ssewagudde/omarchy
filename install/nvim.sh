#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

log_info "Installing Neovim and related tools"
install_packages nvim luarocks tree-sitter-cli

# Check for existing nvim configuration
if [[ -d ~/.config/nvim ]] || [[ -L ~/.config/nvim ]]; then
  log_success "Existing Neovim configuration detected - preserving it"
  if [[ -L ~/.config/nvim ]]; then
    log_info "Neovim config is symlinked to: $(readlink ~/.config/nvim)"
  fi
  log_info "Your nvim configuration will remain unchanged"
else
  log_info "No existing nvim config found"
  log_info "You can set up your own nvim configuration or use a popular one like:"
  log_info "  • LazyVim: https://github.com/LazyVim/LazyVim"
  log_info "  • NvChad: https://github.com/NvChad/NvChad"
  log_info "  • AstroNvim: https://github.com/AstroNvim/AstroNvim"
fi

log_success "Neovim installation completed"
