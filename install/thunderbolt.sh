#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# Verify yay is available
verify_command "yay"

log_info "Installing Thunderbolt support for MacBook Pro"

# Install Thunderbolt tools and drivers
install_packages \
    thunderbolt-software-user-space \
    bolt

# Install network drivers that support Thunderbolt Ethernet adapters
install_packages \
    r8152-dkms \
    asix-dkms

# Enable and start bolt service for Thunderbolt device management
log_info "Configuring Thunderbolt device management"
if ! sudo systemctl is-enabled bolt &>/dev/null; then
    sudo systemctl enable bolt
    log_info "Enabled bolt service"
fi

if ! sudo systemctl is-active bolt &>/dev/null; then
    sudo systemctl start bolt
    log_info "Started bolt service"
fi

# Load Thunderbolt modules
log_info "Loading Thunderbolt kernel modules"
sudo modprobe thunderbolt
sudo modprobe apple_mfi_fastcharge  # For MacBook-specific power management

# Add modules to load at boot
if ! grep -q "thunderbolt" /etc/modules-load.d/thunderbolt.conf 2>/dev/null; then
    echo "thunderbolt" | sudo tee /etc/modules-load.d/thunderbolt.conf
    log_info "Added thunderbolt module to load at boot"
fi

# Configure udev rules for Thunderbolt Ethernet
log_info "Configuring udev rules for Thunderbolt devices"
sudo tee /etc/udev/rules.d/99-thunderbolt-ethernet.rules > /dev/null << 'EOF'
# Thunderbolt Ethernet adapter rules
ACTION=="add", SUBSYSTEM=="thunderbolt", ATTR{device_name}=="*Ethernet*", RUN+="/usr/bin/boltctl enroll --policy auto $kernel"
ACTION=="add", SUBSYSTEM=="net", ATTRS{idVendor}=="0b95", ATTRS{idProduct}=="1790", RUN+="/usr/bin/systemctl restart NetworkManager"
EOF

# Reload udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

log_success "Thunderbolt support installation completed"
log_info ""
log_info "⚡ Next steps:"
log_info "  1. Reboot your system to load Thunderbolt modules"
log_info "  2. Connect your Thunderbolt Ethernet adapter"
log_info "  3. Check device authorization: boltctl list"
log_info "  4. If needed, authorize device: boltctl enroll <device-uuid>"
log_info "  5. Check network interfaces: ip link show"
log_info ""
log_info "Common Thunderbolt Ethernet troubleshooting:"
log_info "  • Check dmesg for Thunderbolt messages: dmesg | grep -i thunderbolt"
log_info "  • List USB devices: lsusb"
log_info "  • Check network manager: systemctl status NetworkManager"