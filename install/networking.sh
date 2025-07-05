#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# Verify yay is available
verify_command "yay"

log_info "Installing networking and synchronization tools"

# Install syncthing and tailscale
install_packages syncthing tailscale

# Configure syncthing
log_info "Configuring syncthing"
if ! systemctl --user is-enabled syncthing &>/dev/null; then
    systemctl --user enable syncthing
    log_info "Enabled syncthing user service"
fi

if ! systemctl --user is-active syncthing &>/dev/null; then
    systemctl --user start syncthing
    log_info "Started syncthing user service"
fi

# Configure tailscale
log_info "Configuring tailscale"
if ! sudo systemctl is-enabled tailscaled &>/dev/null; then
    sudo systemctl enable tailscaled
    log_info "Enabled tailscale daemon"
fi

if ! sudo systemctl is-active tailscaled &>/dev/null; then
    sudo systemctl start tailscaled
    log_info "Started tailscale daemon"
fi

log_success "Networking tools installation completed"
log_info ""
log_info "🔗 Next steps:"
log_info "  Syncthing:"
log_info "    • Web UI: http://localhost:8384"
log_info "    • Add devices and configure folders for file sync"
log_info ""
log_info "  Tailscale:"
log_info "    • Run: sudo tailscale up"
log_info "    • Follow the authentication link to connect your device"
log_info "    • Access your devices securely from anywhere"
log_info ""
log_info "Both services are now running and will start automatically on boot"