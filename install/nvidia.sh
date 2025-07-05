#!/bin/bash
# ==============================================================================
# Hyprland NVIDIA Setup Script for Arch Linux
# ==============================================================================
# This script automates the installation and configuration of NVIDIA drivers
# for use with Hyprland on Arch Linux, following the official Hyprland wiki.
#
# Author: https://github.com/Kn0ax
#
# ==============================================================================

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# --- GPU Detection ---
gpu_info=$(lspci | grep -i 'nvidia')
if [ -n "$gpu_info" ]; then
  log_info "NVIDIA GPU detected: $gpu_info"
  
  # --- Driver Selection ---
  # Turing (16xx, 20xx), Ampere (30xx), Ada (40xx), and newer recommend the open-source kernel modules
  if echo "$gpu_info" | grep -q -E "RTX [2-9][0-9]|GTX 16"; then
    NVIDIA_DRIVER_PACKAGE="nvidia-open-dkms"
    log_info "Using open-source NVIDIA drivers for modern GPU"
  else
    NVIDIA_DRIVER_PACKAGE="nvidia-dkms"
    log_info "Using proprietary NVIDIA drivers for older GPU"
  fi

  # Check which kernel is installed and set appropriate headers package
  KERNEL_HEADERS="linux-headers" # Default
  if pacman -Q linux-zen &>/dev/null; then
    KERNEL_HEADERS="linux-zen-headers"
  elif pacman -Q linux-lts &>/dev/null; then
    KERNEL_HEADERS="linux-lts-headers"
  elif pacman -Q linux-hardened &>/dev/null; then
    KERNEL_HEADERS="linux-hardened-headers"
  fi

  # Enable multilib repository for 32-bit libraries
  if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    sudo sed -i '/^#\[multilib\]/,/^#Include/ s/^#//' /etc/pacman.conf
  fi

  # Install packages
  PACKAGES_TO_INSTALL=(
    "${KERNEL_HEADERS}"
    "${NVIDIA_DRIVER_PACKAGE}"
    "nvidia-utils"
    "lib32-nvidia-utils"
    "egl-wayland"
    "libva-nvidia-driver" # For VA-API hardware acceleration
    "qt5-wayland"
    "qt6-wayland"
  )

  install_packages "${PACKAGES_TO_INSTALL[@]}"

  # Configure modprobe for early KMS
  log_info "Configuring NVIDIA modprobe settings"
  echo "options nvidia_drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf >/dev/null

  # Configure mkinitcpio for early loading
  MKINITCPIO_CONF="/etc/mkinitcpio.conf"
  verify_file "$MKINITCPIO_CONF"

  # Define modules
  NVIDIA_MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"

  # Create backup
  backup_file "$MKINITCPIO_CONF"
  sudo cp "$MKINITCPIO_CONF" "${MKINITCPIO_CONF}.backup"

  # Remove any old nvidia modules to prevent duplicates
  sudo sed -i -E 's/ nvidia_drm//g; s/ nvidia_uvm//g; s/ nvidia_modeset//g; s/ nvidia//g;' "$MKINITCPIO_CONF"
  # Add the new modules at the start of the MODULES array
  sudo sed -i -E "s/^(MODULES=\\()/\\1${NVIDIA_MODULES} /" "$MKINITCPIO_CONF"
  # Clean up potential double spaces
  sudo sed -i -E 's/  +/ /g' "$MKINITCPIO_CONF"

  log_info "Rebuilding initramfs"
  sudo mkinitcpio -P

  # Add NVIDIA environment variables to hyprland.conf
  HYPRLAND_CONF="$HOME/.config/hypr/hyprland.conf"
  if [ -f "$HYPRLAND_CONF" ]; then
    backup_file "$HYPRLAND_CONF"
    log_info "Adding NVIDIA environment variables to Hyprland config"
    cat >>"$HYPRLAND_CONF" <<'EOF'

# NVIDIA environment variables
env = NVD_BACKEND,direct
env = LIBVA_DRIVER_NAME,nvidia
env = __GLX_VENDOR_LIBRARY_NAME,nvidia
EOF
    log_success "NVIDIA configuration added to Hyprland"
  else
    log_warning "Hyprland config not found, NVIDIA environment variables not added"
  fi
  
  log_success "NVIDIA setup completed successfully"
else
  log_info "No NVIDIA GPU detected, skipping NVIDIA setup"
fi
