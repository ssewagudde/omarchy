#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# Verify yay is available
verify_command "yay"

log_info "Installing Hyprland and related packages"

# Batch install all Hyprland packages
install_packages \
  hyprland hyprshot hyprpicker hyprlock hypridle hyprpolkitagent hyprland-qtutils \
  wofi waybar mako swaybg \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

# Backup existing zprofile
backup_file ~/.zprofile

# Start Hyprland on first session
log_info "Configuring Hyprland to start on login"
echo "[[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]] && exec Hyprland" >~/.zprofile

log_success "Hyprland installation completed"