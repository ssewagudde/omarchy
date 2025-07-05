#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

log_info "Installing base development tools"
sudo pacman -S --needed --noconfirm base-devel

if ! command -v yay &>/dev/null; then
  log_info "Installing yay AUR helper"
  
  local temp_dir="/tmp/yay-bin-$$"
  git clone https://aur.archlinux.org/yay-bin.git "$temp_dir"
  cd "$temp_dir"
  
  if ! makepkg -si --noconfirm; then
    log_error "Failed to build and install yay"
    cd - && rm -rf "$temp_dir"
    exit 1
  fi
  
  cd -
  rm -rf "$temp_dir"
  
  # Verify yay installation
  if command -v yay &>/dev/null; then
    log_success "yay installed successfully"
  else
    log_error "yay installation failed"
    exit 1
  fi
else
  log_info "yay already installed"
fi
