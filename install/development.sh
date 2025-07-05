#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# Verify yay is available
verify_command "yay"

log_info "Installing development tools and libraries"

# Core development tools
install_packages \
  cargo clang llvm mise \
  imagemagick \
  mariadb-libs postgresql-libs \
  github-cli \
  lazygit lazydocker \
  python-uv

# Optional extra applications (previously in xtras.sh)
log_info "Installing optional applications"
install_packages \
  spotify dropbox-cli zoom \
  obsidian typora libreoffice obs-studio kdenlive \
  pinta xournalpp

# Copy over Omarchy applications
log_info "Syncing application icons and desktop files"
mkdir -p ~/.local/share/icons/hicolor/48x48/apps/ ~/.local/share/applications
cp ~/.local/share/omarchy/applications/icons/*.png ~/.local/share/icons/hicolor/48x48/apps/ 2>/dev/null || true
cp ~/.local/share/omarchy/applications/*.desktop ~/.local/share/applications/ 2>/dev/null || true
gtk-update-icon-cache ~/.local/share/icons/hicolor &>/dev/null || true
update-desktop-database ~/.local/share/applications &>/dev/null || true

log_success "Development tools and applications installation completed"
