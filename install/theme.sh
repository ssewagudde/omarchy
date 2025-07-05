#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

log_info "Installing and configuring themes"

# Use dark mode for QT apps too (like VLC and kdenlive)
install_packages kvantum-qt5

# Prefer dark mode everything
install_packages gnome-themes-extra # Adds Adwaita-dark theme
log_info "Configuring dark mode preferences"
if command -v gsettings &>/dev/null; then
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    log_success "Dark mode preferences set"
else
    log_warning "gsettings not available, skipping GTK theme configuration"
fi

# Setup theme links
log_info "Setting up theme links"
mkdir -p ~/.config/omarchy/themes
for f in ~/.local/share/omarchy/themes/*; do 
    if [[ -d "$f" ]]; then
        ln -sf "$f" ~/.config/omarchy/themes/
    fi
done

# Set initial theme
log_info "Configuring Tokyo Night theme as default"
mkdir -p ~/.config/omarchy/current
ln -snf ~/.config/omarchy/themes/tokyo-night ~/.config/omarchy/current/theme

# Source backgrounds script (should have run already, but ensure it's available)
if [[ -f ~/.local/share/omarchy/themes/tokyo-night/backgrounds.sh ]]; then
    source ~/.local/share/omarchy/themes/tokyo-night/backgrounds.sh
else
    log_warning "Tokyo Night backgrounds script not found"
fi

# Link backgrounds if they exist
if [[ -d ~/.config/omarchy/backgrounds/tokyo-night ]]; then
    ln -snf ~/.config/omarchy/backgrounds/tokyo-night ~/.config/omarchy/current/backgrounds
    
    # Find and link the first available background
    background_file=$(find ~/.config/omarchy/current/backgrounds -name "*.jpg" -o -name "*.png" | head -1)
    if [[ -n "$background_file" ]]; then
        ln -snf "$background_file" ~/.config/omarchy/current/background
        log_success "Default background set: $(basename "$background_file")"
    else
        log_warning "No background images found in tokyo-night theme"
    fi
else
    log_warning "Tokyo Night backgrounds directory not found"
fi

# Set specific app links for current theme
log_info "Linking theme configurations to applications"

# Hyprlock configuration
if [[ -f ~/.config/omarchy/current/theme/hyprlock.conf ]]; then
    mkdir -p ~/.config/hypr
    ln -snf ~/.config/omarchy/current/theme/hyprlock.conf ~/.config/hypr/hyprlock.conf
    log_info "Linked hyprlock configuration"
fi

# Wofi configuration
if [[ -f ~/.config/omarchy/current/theme/wofi.css ]]; then
    mkdir -p ~/.config/wofi
    ln -snf ~/.config/omarchy/current/theme/wofi.css ~/.config/wofi/style.css
    log_info "Linked wofi theme"
fi

# Neovim configuration (only if nvim config directory exists or will be created)
if [[ -f ~/.config/omarchy/current/theme/neovim.lua ]]; then
    # Only create nvim directories if nvim is installed or config exists
    if command -v nvim &>/dev/null || [[ -d ~/.config/nvim ]]; then
        mkdir -p ~/.config/nvim/lua/plugins
        ln -snf ~/.config/omarchy/current/theme/neovim.lua ~/.config/nvim/lua/plugins/theme.lua
        log_info "Linked neovim theme"
    else
        log_info "Skipping neovim theme (nvim not installed yet)"
    fi
fi

# Btop configuration
if [[ -f ~/.config/omarchy/current/theme/btop.theme ]]; then
    mkdir -p ~/.config/btop/themes
    ln -snf ~/.config/omarchy/current/theme/btop.theme ~/.config/btop/themes/current.theme
    log_info "Linked btop theme"
fi

# Mako configuration
if [[ -f ~/.config/omarchy/current/theme/mako.ini ]]; then
    mkdir -p ~/.config/mako
    ln -snf ~/.config/omarchy/current/theme/mako.ini ~/.config/mako/config
    log_info "Linked mako theme"
fi

log_success "Theme configuration completed successfully"
