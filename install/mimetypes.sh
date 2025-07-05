#!/bin/bash

# Source common functions
source "$(dirname "${BASH_SOURCE[0]}")/common.sh"
init_omarchy_script

log_info "Configuring MIME types and default applications"

# Ensure applications directory exists
mkdir -p ~/.local/share/applications

# Update desktop database (with error handling)
if command -v update-desktop-database &>/dev/null; then
    if update-desktop-database ~/.local/share/applications 2>/dev/null; then
        log_success "Desktop database updated"
    else
        log_warning "Failed to update desktop database (non-critical)"
    fi
else
    log_warning "update-desktop-database not found, skipping database update"
fi

log_info "Setting default applications for file types"

# Function to safely set MIME type defaults
set_mime_default() {
    local app="$1"
    local mime_type="$2"
    
    if command -v xdg-mime &>/dev/null; then
        if xdg-mime default "$app" "$mime_type" 2>/dev/null; then
            log_info "Set $mime_type → $app"
        else
            log_warning "Failed to set default for $mime_type (application may not be installed)"
        fi
    else
        log_warning "xdg-mime not available, skipping MIME type configuration"
        return 1
    fi
}

# Open all images with imv
log_info "Configuring image file associations"
set_mime_default imv.desktop image/png
set_mime_default imv.desktop image/jpeg
set_mime_default imv.desktop image/gif
set_mime_default imv.desktop image/webp
set_mime_default imv.desktop image/bmp
set_mime_default imv.desktop image/tiff

# Open PDFs with the Document Viewer
log_info "Configuring PDF file associations"
set_mime_default org.gnome.Evince.desktop application/pdf

# Open video files with VLC
log_info "Configuring video file associations"
set_mime_default vlc.desktop video/mp4
set_mime_default vlc.desktop video/x-msvideo
set_mime_default vlc.desktop video/x-matroska
set_mime_default vlc.desktop video/x-flv
set_mime_default vlc.desktop video/x-ms-wmv
set_mime_default vlc.desktop video/mpeg
set_mime_default vlc.desktop video/ogg
set_mime_default vlc.desktop video/webm
set_mime_default vlc.desktop video/quicktime
set_mime_default vlc.desktop video/3gpp
set_mime_default vlc.desktop video/3gpp2
set_mime_default vlc.desktop video/x-ms-asf
set_mime_default vlc.desktop video/x-ogm+ogg
set_mime_default vlc.desktop video/x-theora+ogg
set_mime_default vlc.desktop application/ogg

log_success "MIME type configuration completed"
