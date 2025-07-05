#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# Verify required directories and files exist
verify_directory ~/.local/share/omarchy/config
verify_file ~/.local/share/omarchy/default/zsh/rc

log_info "Copying Omarchy configurations"

# Backup existing config if it exists
if [[ -d ~/.config ]]; then
    backup_file ~/.config
fi

# Copy over Omarchy configs
cp -R ~/.local/share/omarchy/config/* ~/.config/

# Change default shell to zsh
log_info "Setting zsh as default shell"
if [[ ! -f /usr/bin/zsh ]]; then
    log_error "zsh not found at /usr/bin/zsh"
    exit 1
fi

chsh -s /usr/bin/zsh

# Backup existing zshrc
backup_file ~/.zshrc

# Use default zshrc from Omarchy
log_info "Configuring zsh with Omarchy defaults"
echo "source ~/.local/share/omarchy/default/zsh/rc" >~/.zshrc

# WARNING: Auto-login setup - only enable if user confirms
log_warning "The next step will enable auto-login for security convenience"
log_warning "This relies on disk encryption + hyprlock for security"

if command -v gum &>/dev/null; then
    if gum confirm "Enable auto-login? (requires disk encryption for security)"; then
        log_info "Setting up auto-login"
        sudo mkdir -p /etc/systemd/system/getty@tty1.service.d
        sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM
EOF
        log_success "Auto-login configured"
    else
        log_info "Skipping auto-login setup"
    fi
else
    log_warning "gum not available, skipping auto-login confirmation"
fi

# Set common git aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global pull.rebase true
git config --global init.defaultBranch master

# Set identification from install inputs
if [[ -n "${OMARCHY_USER_NAME//[[:space:]]/}" ]]; then
  git config --global user.name "$OMARCHY_USER_NAME"
fi

if [[ -n "${OMARCHY_USER_EMAIL//[[:space:]]/}" ]]; then
  git config --global user.email "$OMARCHY_USER_EMAIL"
fi

# Set default XCompose that is triggered with CapsLock
tee ~/.XCompose >/dev/null <<EOF
include "%H/.local/share/omarchy/default/xcompose"

# Identification
<Multi_key> <space> <n> : "$OMARCHY_USER_NAME"
<Multi_key> <space> <e> : "$OMARCHY_USER_EMAIL"
EOF
