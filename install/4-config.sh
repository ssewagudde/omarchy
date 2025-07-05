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

# Copy over Omarchy configs (excluding nvim to preserve user config)
log_info "Copying configuration files (preserving existing nvim config)"
for config_dir in ~/.local/share/omarchy/config/*/; do
    dir_name=$(basename "$config_dir")
    if [[ "$dir_name" != "nvim" ]]; then
        cp -R "$config_dir" ~/.config/
        log_info "Copied $dir_name configuration"
    fi
done

# Change default shell to zsh
log_info "Setting zsh as default shell"

# Wait a moment for package installation to complete if needed
sleep 2

# First, verify zsh is installed and find its location
ZSH_PATH=""
if [[ -f /usr/bin/zsh ]]; then
    ZSH_PATH="/usr/bin/zsh"
elif [[ -f /bin/zsh ]]; then
    ZSH_PATH="/bin/zsh"
elif command -v zsh &>/dev/null; then
    ZSH_PATH=$(command -v zsh)
else
    log_warning "zsh not found. It may still be installing..."
    log_info "Skipping shell change for now. You can run 'chsh -s /usr/bin/zsh' later."
    ZSH_PATH=""
fi

if [[ -n "$ZSH_PATH" ]]; then

    log_info "Found zsh at: $ZSH_PATH"

    # Verify zsh is in /etc/shells
    if ! grep -q "^$ZSH_PATH$" /etc/shells; then
        log_info "Adding $ZSH_PATH to /etc/shells"
        echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
    fi

    # Change shell with better error handling (disable strict error checking temporarily)
    set +e
    if chsh -s "$ZSH_PATH" 2>/dev/null; then
        log_success "Default shell changed to zsh"
    else
        log_warning "Failed to change default shell automatically"
        log_info "You can manually change your shell later with: chsh -s $ZSH_PATH"
        log_info "Or add this to your ~/.bashrc: exec $ZSH_PATH"
    fi
    set -e
else
    log_info "Skipping shell change - zsh not available yet"
fi

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
