#!/bin/bash

# Source common functions
source ~/.local/share/omarchy/install/common.sh
init_omarchy_script

log_info "🚀 Installing Omarchy Core (Fast Mode)"

# Core essentials (always needed)
for f in ~/.local/share/omarchy/install/{1-yay,2-identification,3-terminal,4-config,hyprlandia,desktop,fonts,backgrounds,theme,mimetypes,networking}.sh; do 
  if [[ -f "$f" ]]; then
    log_info "Running $(basename "$f")"
    source "$f"
  else
    log_warning "Script not found: $f"
  fi
done

log_success "✅ Core installation complete!"
echo ""
log_info "🔧 Optional components (run if needed):"
echo "  Development: source ~/.local/share/omarchy/install/development.sh"
echo "  Docker: source ~/.local/share/omarchy/install/docker.sh"
echo "  Ruby: source ~/.local/share/omarchy/install/ruby.sh"
echo "  NVIDIA: source ~/.local/share/omarchy/install/nvidia.sh"
echo "  Printer: source ~/.local/share/omarchy/install/printer.sh"
echo "  Extra Apps: included in development.sh"
echo "  Remote Access: source ~/.local/share/omarchy/install/remote-access.sh"
echo ""

# Ensure locate is up to date
log_info "Updating locate database"
sudo updatedb

log_success "Fast installation completed successfully!"
log_info "Backup files are stored in: $OMARCHY_BACKUP_DIR"
log_info "Use 'omarchy-rollback --help' for rollback options"

if command -v gum &>/dev/null; then
  gum confirm "Reboot to apply all settings?" && reboot
else
  read -p "Reboot to apply all settings? (y/N): " -n 1 -r
  echo
  [[ $REPLY =~ ^[Yy]$ ]] && reboot
fi