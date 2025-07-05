#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

if ! command -v nvim &>/dev/null; then
  log_info "Installing Neovim and related tools"
  install_packages nvim luarocks tree-sitter-cli

  # Backup existing nvim config if it exists
  if [[ -d ~/.config/nvim ]]; then
    backup_file ~/.config/nvim
    log_info "Backed up existing nvim configuration"
  fi

  # Install Omarchy nvim configuration
  log_info "Installing Omarchy nvim configuration"
  
  # Check if nvim config was already copied by 4-config.sh
  if [[ -d ~/.config/nvim ]] && [[ -f ~/.config/nvim/init.lua ]]; then
    log_info "Neovim configuration already exists (copied by config script)"
  else
    # Remove any incomplete config and install fresh
    rm -rf ~/.config/nvim
    
    # Verify source config exists
    if [[ -d ~/.local/share/omarchy/config/nvim ]]; then
      cp -R ~/.local/share/omarchy/config/nvim ~/.config/nvim
      log_success "Neovim configuration installed"
    else
      log_error "Omarchy nvim config not found at ~/.local/share/omarchy/config/nvim"
      exit 1
    fi
  fi
else
  log_info "Neovim already installed"
fi
