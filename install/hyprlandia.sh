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
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  sddm

# Configure SDDM display manager
log_info "Configuring SDDM display manager for automatic login"
sudo systemctl enable sddm

# Create Hyprland desktop entry for SDDM
sudo mkdir -p /usr/share/wayland-sessions
sudo tee /usr/share/wayland-sessions/hyprland.desktop >/dev/null <<'EOF'
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=Hyprland
Type=Application
EOF

# Remove old auto-start method
if [[ -f ~/.zprofile ]]; then
    backup_file ~/.zprofile
    sed -i '/Hyprland/d' ~/.zprofile 2>/dev/null || true
fi

log_success "Hyprland installation completed"
log_info ""
log_info "🖥️  Display Manager Setup:"
log_info "  • SDDM is now enabled and will show a login screen on boot"
log_info "  • Select 'Hyprland' from the session menu when logging in"
log_info ""
log_info "🔐 Optional Auto-login:"
log_info "  • Enable: omarchy-autologin enable"
log_info "  • Disable: omarchy-autologin disable"
log_info "  • Status: omarchy-autologin status"