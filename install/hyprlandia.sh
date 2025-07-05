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

# Start Hyprland automatically on tty1
log_info "Configuring Hyprland to start automatically on login"
echo "[[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]] && exec Hyprland" >~/.zprofile

log_success "Hyprland installation completed"
log_info ""
log_info "🖥️  Auto-start Setup:"
log_info "  • Hyprland will start automatically when you log in to tty1"
log_info "  • After reboot, just enter your username and password"
log_info "  • Hyprland will launch immediately after login"