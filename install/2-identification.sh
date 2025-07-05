#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

# Verify yay is available
verify_command "yay"

# Install gum for user input
log_info "Installing gum for user input"
install_packages gum

# Note: gum verification is handled by install_packages function

# Configure identification
log_info "Configuring user identification for git and autocomplete"
echo -e "\nEnter identification for git and autocomplete..."

export OMARCHY_USER_NAME=$(gum input --placeholder "Enter full name" --prompt "Name> ")
export OMARCHY_USER_EMAIL=$(gum input --placeholder "Enter email address" --prompt "Email> ")

# Validate input
if [[ -z "${OMARCHY_USER_NAME// }" ]]; then
    log_error "Name cannot be empty"
    exit 1
fi

if [[ -z "${OMARCHY_USER_EMAIL// }" ]]; then
    log_error "Email cannot be empty"
    exit 1
fi

# Basic email validation
if [[ ! "$OMARCHY_USER_EMAIL" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
    log_error "Invalid email format"
    exit 1
fi

log_success "User identification configured: $OMARCHY_USER_NAME <$OMARCHY_USER_EMAIL>"
