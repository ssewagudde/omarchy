#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

log_info "Installing and configuring keyd for key remapping"

# Install keyd
install_packages keyd

# Create keyd configuration directory
sudo mkdir -p /etc/keyd

# Create the main keyd configuration
log_info "Creating keyd configuration for meta and caps lock remapping"

# Copy Omarchy's keyd configuration
if [[ -f ~/.local/share/omarchy/config/keyd/default.conf ]]; then
  sudo cp ~/.local/share/omarchy/config/keyd/default.conf /etc/keyd/default.conf
  log_info "Copied Omarchy keyd configuration"
else
  # Fallback: create configuration inline
  sudo tee /etc/keyd/default.conf >/dev/null <<'EOF'
[ids]
*

[main]
# Remap Caps Lock to Control
capslock = leftcontrol

# Remap Meta (Super/Cmd) keys to Control
meta = leftcontrol
leftmeta = leftcontrol
rightmeta = rightcontrol
leftcontrol = leftmeta
rightcontrol = rightmeta

EOF
  log_info "Created fallback keyd configuration"
fi

# Backup any existing keyd configuration
if [[ -f /etc/keyd/default.conf.backup ]]; then
  log_info "Existing keyd backup found"
else
  if [[ -f /etc/keyd/default.conf ]]; then
    sudo cp /etc/keyd/default.conf /etc/keyd/default.conf.backup
    log_info "Backed up existing keyd configuration"
  fi
fi

# Enable and start keyd service
log_info "Enabling and starting keyd service"
sudo systemctl enable keyd
sudo systemctl start keyd

# Check if keyd is running
if sudo systemctl is-active --quiet keyd; then
  log_success "keyd service is running"
else
  log_error "keyd service failed to start"
  sudo systemctl status keyd
  exit 1
fi

# Reload keyd configuration
log_info "Reloading keyd configuration"
sudo keyd reload

log_success "keyd configuration completed!"
log_info "Key mappings applied:"
log_info "  • Caps Lock → Control"
log_info "  • Meta/Super/Cmd keys → Control"
log_info ""
log_info "To test the remapping:"
log_info "  • Press Caps Lock + C (should copy)"
log_info "  • Press Meta/Cmd + C (should copy)"
log_info ""
log_info "To modify the configuration, edit: /etc/keyd/default.conf"
log_info "Then reload with: sudo keyd reload"
