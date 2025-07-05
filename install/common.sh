#!/bin/bash

# Common functions for Omarchy installation scripts
set -eo pipefail

# Prevent multiple sourcing
if [[ "${OMARCHY_COMMON_LOADED:-}" == "true" ]]; then
    return 0
fi

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Simple logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $*" >&2; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*" >&2; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $*" >&2; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# Simple verification functions
verify_command() {
    command -v "$1" &>/dev/null || { log_error "Command '$1' not found"; return 1; }
}

verify_file() {
    [[ -f "$1" ]] || { log_error "File '$1' not found"; return 1; }
}

verify_directory() {
    [[ -d "$1" ]] || { log_error "Directory '$1' not found"; return 1; }
}

# Simple package installation
install_packages() {
    log_info "Installing: $*"
    yay -S --noconfirm --needed "$@"
}

# Simple download function
safe_download() {
    local url="$1"
    local output="$2"
    log_info "Downloading $(basename "$url")"
    curl -fsSL -o "$output" "$url"
}

# Simple backup function
backup_file() {
    local file="$1"
    [[ -f "$file" ]] && cp "$file" "$file.backup.$(date +%s)"
}

# Basic initialization
init_omarchy_script() {
    [[ $EUID -eq 0 ]] && { log_error "Don't run as root"; exit 1; }
    log_info "Starting $(basename "$0")"
}

# Mark as loaded
readonly OMARCHY_COMMON_LOADED="true"