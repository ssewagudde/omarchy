#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# Verify yay is available
verify_command "yay"

log_info "Installing system fonts"
install_packages ttf-font-awesome noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra

mkdir -p ~/.local/share/fonts

# Install CaskaydiaMono Nerd Font
if ! fc-list | grep -qi "CaskaydiaMono Nerd Font"; then
  log_info "Installing CaskaydiaMono Nerd Font"
  
  temp_dir="/tmp/cascadia-$$"
  mkdir -p "$temp_dir"
  cd "$temp_dir"
  
  # Download with safer approach (no checksum available for latest)
  if safe_download "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip" "CascadiaMono.zip"; then
    unzip -q CascadiaMono.zip -d CascadiaFont
    
    # Copy font files safely
    find CascadiaFont -name "CaskaydiaMonoNerdFont-*.ttf" -exec cp {} ~/.local/share/fonts/ \;
    
    # Verify fonts were copied
    if ls ~/.local/share/fonts/CaskaydiaMonoNerdFont-*.ttf &>/dev/null; then
      log_success "CaskaydiaMono Nerd Font installed"
      fc-cache -f
    else
      log_error "Failed to install CaskaydiaMono Nerd Font"
    fi
  else
    log_error "Failed to download CaskaydiaMono Nerd Font"
  fi
  
  cd -
  rm -rf "$temp_dir"
else
  log_info "CaskaydiaMono Nerd Font already installed"
fi

# Install iA Writer Mono S
if ! fc-list | grep -qi "iA Writer Mono S"; then
  log_info "Installing iA Writer Mono S font"
  
  temp_dir="/tmp/iafonts-$$"
  mkdir -p "$temp_dir"
  cd "$temp_dir"
  
  if safe_download "https://github.com/iaolo/iA-Fonts/archive/refs/heads/master.zip" "iafonts.zip"; then
    unzip -q iafonts.zip -d iaFonts
    
    # Copy font files safely
    find iaFonts/iA-Fonts-master/iA\ Writer\ Mono/Static -name "iAWriterMonoS-*.ttf" -exec cp {} ~/.local/share/fonts/ \;
    
    # Verify fonts were copied
    if ls ~/.local/share/fonts/iAWriterMonoS-*.ttf &>/dev/null; then
      log_success "iA Writer Mono S font installed"
      fc-cache -f
    else
      log_error "Failed to install iA Writer Mono S font"
    fi
  else
    log_error "Failed to download iA Writer Mono S font"
  fi
  
  cd -
  rm -rf "$temp_dir"
else
  log_info "iA Writer Mono S font already installed"
fi

log_success "Font installation completed"
