# Fast core installation - essentials only
echo "🚀 Installing Omarchy Core (Fast Mode)..."

# Core essentials (always needed)
for f in ~/.local/share/omarchy/install/{1-yay,2-identification,3-terminal,4-config,hyprlandia,desktop,fonts,theme,backgrounds,mimetypes}.sh; do 
  [[ -f "$f" ]] && source "$f"
done

echo "✅ Core installation complete!"
echo ""
echo "🔧 Optional components (run if needed):"
echo "  Development: source ~/.local/share/omarchy/install/development.sh"
echo "  Docker: source ~/.local/share/omarchy/install/docker.sh"
echo "  Ruby: source ~/.local/share/omarchy/install/ruby.sh"
echo "  NVIDIA: source ~/.local/share/omarchy/install/nvidia.sh"
echo "  Printer: source ~/.local/share/omarchy/install/printer.sh"
echo "  Extra Apps: source ~/.local/share/omarchy/install/xtras.sh"
echo "  Remote Access: source ~/.local/share/omarchy/install/remote-access.sh"
echo ""

# Ensure locate is up to date
sudo updatedb

gum confirm "Reboot to apply all settings?" && reboot