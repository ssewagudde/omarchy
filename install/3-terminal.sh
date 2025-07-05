#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# Verify yay is available
verify_command "yay"

log_info "Installing terminal tools and utilities"

# Batch install all terminal packages for better performance
install_packages \
  wget curl unzip inetutils \
  fd eza fzf ripgrep zoxide bat \
  wl-clipboard fastfetch btop \
  man tldr less whois plocate \
  ghostty zsh atuin yazi lsd aws-cli-v2 opencode-bin lastpass

log_success "Terminal tools installation completed"
