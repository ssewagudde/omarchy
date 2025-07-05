#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

log_info "Installing bluetooth support"
install_packages blueberry
sudo systemctl enable --now bluetooth.service
log_success "Bluetooth support installed"
