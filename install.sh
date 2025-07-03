# Install core components (fast)
for f in ~/.local/share/omarchy/install/{1-yay,2-identification,3-terminal,4-config,hyprlandia,desktop,fonts,theme,backgrounds,mimetypes,development}.sh; do 
  [[ -f "$f" ]] && source "$f"
done

# Optional components (comment out to skip)
echo "Installing optional components..."
source ~/.local/share/omarchy/install/bluetooth.sh
source ~/.local/share/omarchy/install/nvim.sh
# source ~/.local/share/omarchy/install/docker.sh      # Uncomment if needed
# source ~/.local/share/omarchy/install/ruby.sh        # Uncomment if needed  
# source ~/.local/share/omarchy/install/printer.sh     # Uncomment if needed
# source ~/.local/share/omarchy/install/xtras.sh       # Uncomment if needed
# source ~/.local/share/omarchy/install/nvidia.sh      # Auto-detects, uncomment if issues

# Ensure locate is up to date now that everything has been installed
sudo updatedb

gum confirm "Reboot to apply all settings?" && reboot
