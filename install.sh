#!/bin/bash

# Source common functions
source ~/.local/share/omarchy/install/common.sh
init_omarchy_script

log_info "Starting Omarchy installation"

# Install core components (fast)
for f in ~/.local/share/omarchy/install/{1-yay,2-identification,3-terminal,4-config,hyprlandia,desktop,fonts,theme,backgrounds,mimetypes,development}.sh; do 
  if [[ -f "$f" ]]; then
    log_info "Running $(basename "$f")"
    source "$f"
  else
    log_warning "Script not found: $f"
  fi
done

# Optional components (comment out to skip)
log_info "Installing optional components"
source ~/.local/share/omarchy/install/bluetooth.sh
source ~/.local/share/omarchy/install/nvim.sh
# source ~/.local/share/omarchy/install/docker.sh      # Uncomment if needed
# source ~/.local/share/omarchy/install/ruby.sh        # Uncomment if needed  
# source ~/.local/share/omarchy/install/printer.sh     # Uncomment if needed
# source ~/.local/share/omarchy/install/xtras.sh       # Uncomment if needed
# source ~/.local/share/omarchy/install/nvidia.sh      # Auto-detects, uncomment if issues

# Ensure locate is up to date now that everything has been installed
log_info "Updating locate database"
sudo updatedb

log_success "Omarchy installation completed successfully!"
log_info "Backup files are stored in: $OMARCHY_BACKUP_DIR"
log_info "Use 'omarchy-rollback --help' for rollback options"

if command -v gum &>/dev/null; then
  gum confirm "Reboot to apply all settings?" && reboot
else
  read -p "Reboot to apply all settings? (y/N): " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]] && reboot
fi
