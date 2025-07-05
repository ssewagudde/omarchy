#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# Install asdcontrol for controlling brightness on Apple Displays
if ! command -v asdcontrol &>/dev/null; then
  log_info "Installing asdcontrol for Apple Display brightness control"
  
  # Clone and build asdcontrol
  local temp_dir="/tmp/asdcontrol-$$"
  git clone https://github.com/nikosdion/asdcontrol.git "$temp_dir"
  cd "$temp_dir"
  
  if ! make; then
    log_error "Failed to build asdcontrol"
    cd - && rm -rf "$temp_dir"
    exit 1
  fi
  
  sudo make install
  cd -
  rm -rf "$temp_dir"

  # Setup secure sudo access with specific command restrictions
  log_info "Configuring secure sudo access for asdcontrol"
  
  # Create a more restrictive sudoers entry
  cat << EOF | sudo tee /etc/sudoers.d/asdcontrol >/dev/null
# Allow $USER to run asdcontrol with specific arguments only
$USER ALL=(root) NOPASSWD: /usr/local/bin/asdcontrol set *, /usr/local/bin/asdcontrol get *
EOF
  
  # Verify sudoers file syntax
  if ! sudo visudo -c -f /etc/sudoers.d/asdcontrol; then
    log_error "Invalid sudoers syntax, removing file"
    sudo rm -f /etc/sudoers.d/asdcontrol
    exit 1
  fi
  
  sudo chmod 440 /etc/sudoers.d/asdcontrol
  log_success "asdcontrol installed and configured securely"
else
  log_info "asdcontrol already installed"
fi
