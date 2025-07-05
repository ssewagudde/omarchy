#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

log_info "Installing printer support"
install_packages cups cups-pdf cups-filters system-config-printer
sudo systemctl enable --now cups.service
log_success "Printer support installed"
