#!/bin/bash

# Common error handling and utility functions for Omarchy installation scripts
set -euo pipefail

# Prevent multiple sourcing
if [[ "${OMARCHY_COMMON_LOADED:-}" == "true" ]]; then
    return 0
fi

# Colors for output (only declare if not already set)
if [[ -z "${RED:-}" ]]; then
    readonly RED='\033[0;31m'
    readonly GREEN='\033[0;32m'
    readonly YELLOW='\033[1;33m'
    readonly BLUE='\033[0;34m'
    readonly NC='\033[0m' # No Color
fi

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Error handler
error_handler() {
    local line_number=$1
    local error_code=$2
    local command="$3"
    log_error "Script failed at line $line_number with exit code $error_code"
    log_error "Failed command: $command"
    log_error "Installation may be incomplete. Check the logs above for details."
    exit "$error_code"
}

# Set up error trapping
trap 'error_handler ${LINENO} $? "$BASH_COMMAND"' ERR

# Dependency verification
verify_command() {
    local cmd="$1"
    local package="${2:-$1}"
    
    if ! command -v "$cmd" &>/dev/null; then
        log_error "Required command '$cmd' not found. Please install '$package' first."
        return 1
    fi
}

verify_file() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        log_error "Required file '$file' not found."
        return 1
    fi
}

# Safe package installation with retry
install_packages() {
    local packages=("$@")
    local max_retries=3
    local retry_count=0
    
    while [[ $retry_count -lt $max_retries ]]; do
        log_info "Installing packages: ${packages[*]} (attempt $((retry_count + 1))/$max_retries)"
        
        if yay -S --noconfirm --needed "${packages[@]}"; then
            log_success "Successfully installed packages: ${packages[*]}"
            return 0
        else
            retry_count=$((retry_count + 1))
            if [[ $retry_count -lt $max_retries ]]; then
                log_warning "Installation failed, retrying in 5 seconds..."
                sleep 5
            fi
        fi
    done
    
    log_error "Failed to install packages after $max_retries attempts: ${packages[*]}"
    return 1
}

# Safe download with checksum verification
safe_download() {
    local url="$1"
    local output="$2"
    local expected_checksum="${3:-}"
    
    log_info "Downloading $url to $output"
    
    if ! curl -fsSL -o "$output" "$url"; then
        log_error "Failed to download $url"
        return 1
    fi
    
    if [[ -n "$expected_checksum" ]]; then
        local actual_checksum
        actual_checksum=$(sha256sum "$output" | cut -d' ' -f1)
        
        if [[ "$actual_checksum" != "$expected_checksum" ]]; then
            log_error "Checksum mismatch for $output"
            log_error "Expected: $expected_checksum"
            log_error "Actual: $actual_checksum"
            rm -f "$output"
            return 1
        fi
        
        log_success "Checksum verified for $output"
    fi
}

# Backup and restore functions
backup_file() {
    local file="$1"
    local backup_dir="${OMARCHY_BACKUP_DIR:-$HOME/.omarchy-backup}"
    
    if [[ -f "$file" ]]; then
        mkdir -p "$backup_dir"
        local backup_path="$backup_dir/$(basename "$file").$(date +%s)"
        cp "$file" "$backup_path"
        log_info "Backed up $file to $backup_path"
        echo "$backup_path" >> "$backup_dir/backup_list"
    fi
}

# Check if running as root (should not be)
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

# Initialize common setup
init_omarchy_script() {
    check_not_root
    
    # Create backup directory
    export OMARCHY_BACKUP_DIR="$HOME/.omarchy-backup"
    mkdir -p "$OMARCHY_BACKUP_DIR"
    
    log_info "Starting $(basename "$0")"
}

# Mark as loaded
readonly OMARCHY_COMMON_LOADED="true"