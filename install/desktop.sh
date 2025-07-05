#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# Verify yay is available
verify_command "yay"

log_info "Installing desktop applications and utilities"

# Batch install desktop packages
install_packages \
  brightnessctl playerctl pamixer pavucontrol wireplumber \
  fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool \
  wl-clip-persist clipse \
  nautilus sushi gnome-calculator \
  vlc evince imv

# Install Google Chrome with fallback to Chromium
log_info "Installing web browser"
if install_packages google-chrome; then
  log_success "Google Chrome installed successfully"
else
  log_warning "Google Chrome failed, installing Chromium as fallback"
  install_packages chromium
  
  # Update browser config to use chromium if Chrome failed
  hyprland_conf="$HOME/.config/hypr/hyprland.conf"
  if [[ -f "$hyprland_conf" ]]; then
    backup_file "$hyprland_conf"
    sed -i 's/google-chrome-stable/chromium/g' "$hyprland_conf"
    log_info "Updated Hyprland config to use Chromium"
  fi
fi

log_success "Desktop applications installation completed"
