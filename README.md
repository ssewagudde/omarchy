# Omarchy

Turn a fresh Arch installation into a fully-configured, beautiful, and modern development system based on Hyprland by running a single command. Omarchy provides an opinionated take on what Linux can be at its best - optimized for developers and MacBook users transitioning to Linux.

## ✨ What You Get

- **🐚 zsh** as default shell with Zinit plugin manager and Powerlevel10k theme
- **💻 ghostty** terminal emulator for blazing-fast performance
- **🪟 Hyprland** Wayland compositor with beautiful animations
- **🎨 Multiple themes**: Catppuccin, Gruvbox, Nord, Tokyo Night, Kanagawa, Everforest
- **🔧 Modern CLI tools**: atuin, yazi, eza, fzf, ripgrep, zoxide, bat, and more
- **🍎 MacBook optimized**: Natural scrolling, 3-finger gestures, Mac-style shortcuts
- **⚡ Development ready**: Go, Rust, Python (uv), Docker, Git, GitHub CLI

## 🚀 Installation

### Quick Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/ssewagudde/omarchy/master/boot.sh | bash
```

### Fast Core Install (5-10 minutes)
```bash
# Clone and run fast installation
git clone https://github.com/ssewagudde/omarchy.git ~/.local/share/omarchy
source ~/.local/share/omarchy/install-fast.sh
```

The fast install includes only essentials. Add optional components later as needed.

### Manual Component Installation
```bash
# Install specific components after core installation
source ~/.local/share/omarchy/install/development.sh  # Development tools
source ~/.local/share/omarchy/install/networking.sh   # Syncthing + Tailscale (included by default)
source ~/.local/share/omarchy/install/docker.sh       # Docker support
source ~/.local/share/omarchy/install/nvidia.sh       # NVIDIA drivers
source ~/.local/share/omarchy/install/thunderbolt.sh  # Thunderbolt Ethernet support (MacBook Pro)
source ~/.local/share/omarchy/install/nvim.sh         # Neovim (preserves existing config)
```

## 🍎 MacBook Features

Omarchy is specially optimized for MacBook users:

- **Natural trackpad scrolling** and 3-finger workspace gestures
- **Mac-style shortcuts**: Cmd+C/V/X/A/Z/Q/W/N/R work as expected
- **Caps Lock → Control** and **Meta/Cmd → Control** mapping for familiar keyboard behavior
- **Thunderbolt Ethernet support** for MacBook Pro with comprehensive driver installation
- **Optimal 1.33x scaling** for crisp text on high-DPI displays
- **Platform detection** for seamless macOS/Linux compatibility

## 🛠️ What's Included

### Shell & Terminal
- **zsh** with Zinit plugin manager
- **ghostty** terminal emulator
- **Powerlevel10k** theme with auto-configuration
- Enhanced completions, syntax highlighting, and autosuggestions

### Development Tools
- **Languages**: Go, Rust, Python (with uv), Node.js (via mise)
- **Version management**: mise for runtime versions
- **Containers**: Docker with lazydocker TUI
- **Git**: Enhanced with lazygit TUI and comprehensive aliases

### System Tools
- **File management**: yazi TUI file manager, eza/lsd for listings
- **Search**: fzf fuzzy finder, ripgrep for fast text search
- **Navigation**: zoxide for smart directory jumping
- **History**: atuin for enhanced shell history sync
- **Monitoring**: btop for system monitoring
- **Networking**: syncthing for file sync, tailscale for secure networking

### Desktop Environment
- **Hyprland** Wayland compositor
- **waybar** status bar with system information
- **wofi** application launcher
- **mako** notification daemon
- **Multiple theme support** with easy switching

### Remote Access
- **RustDesk** for seamless remote desktop from Mac/Windows/Linux
- **Wayland-compatible** remote access solution
- **Easy setup** with connection ID and password

## 📖 Usage

### First Boot
After installation and reboot:
1. **Login prompt** will appear (standard terminal login)
2. Enter your **username and password**
3. **Hyprland will start automatically** on tty1

### Auto-start Management
Control Hyprland auto-start behavior:
```bash
omarchy-autostart status   # Check current status
omarchy-autostart disable  # Disable auto-start
omarchy-autostart enable   # Re-enable auto-start
```

### Keyboard Shortcuts
- **Super + Enter**: Open terminal
- **Super + Space**: Application launcher
- **Super + Q**: Quit application (Mac-style)
- **3-finger swipe**: Switch workspaces
- **Cmd+C/V**: Copy/paste (Mac-style)

## 🌐 Remote Access

Access your Omarchy machine from anywhere:

```bash
# Install remote access (optional)
source ~/.local/share/omarchy/install/remote-access.sh
```

Then download RustDesk on your Mac/Windows/phone and connect using the displayed ID!

## 🌐 File Sync & Secure Networking

Omarchy includes modern networking tools for seamless connectivity:

### **Syncthing - Decentralized File Sync**
```bash
# Access web interface (auto-starts after installation)
http://localhost:8384

# Add devices and sync folders across all your machines
# No cloud required - direct peer-to-peer synchronization
```

### **Tailscale - Zero-Config VPN**
```bash
# Connect your device to your Tailscale network
sudo tailscale up

# Access all your devices securely from anywhere
# Works behind NAT/firewalls without port forwarding
```

Both services start automatically and provide secure, private alternatives to cloud services.

## ⌨️ Key Remapping

Omarchy includes keyd configuration for Mac-like key behavior (installed by default):

```bash
# Manage keyd configuration
omarchy-keyd status    # Show current status
omarchy-keyd reload    # Reload configuration
omarchy-keyd edit      # Edit configuration
omarchy-keyd test      # Test key mappings
```

**Default mappings (automatically configured):**
- **Caps Lock → Control**
- **Meta/Super/Cmd → Control**
- This makes Cmd+C, Cmd+V, etc. work like on Mac

## 📝 Neovim Configuration

Omarchy respects your existing Neovim configuration and provides tools to manage it:

```bash
# Install Neovim (preserves existing config)
source ~/.local/share/omarchy/install/nvim.sh

# Manage your nvim configuration
omarchy-nvim status           # Show current config status
omarchy-nvim backup           # Backup current config
omarchy-nvim link ~/my-config # Symlink to your config
omarchy-nvim reset            # Remove config for fresh start
```

**Features:**
- **Preserves existing configs** - Never overwrites your setup
- **Symlink support** - Detects and preserves symlinked configurations
- **Easy management** - Backup, restore, and link configurations
- **Fresh start option** - Clean slate for new configurations

## 🔄 Backup & Rollback

Omarchy automatically backs up your existing configurations before making changes:

```bash
# List available backups
~/.local/share/omarchy/bin/omarchy-rollback --list

# Restore a specific file
~/.local/share/omarchy/bin/omarchy-rollback --restore ~/.zshrc

# Restore all backed up files
~/.local/share/omarchy/bin/omarchy-rollback --restore-all

# Clean up all backups
~/.local/share/omarchy/bin/omarchy-rollback --clean
```

## 🎨 Themes

Switch between beautiful themes:
- Tokyo Night (default)
- Catppuccin
- Gruvbox
- Nord
- Kanagawa
- Everforest

## 📚 Documentation

For detailed configuration and customization, see the [AGENTS.md](AGENTS.md) file.

Read more at [omarchy.org](https://omarchy.org).

## 🤝 Contributing

Omarchy is designed to be a solid foundation that works out of the box. Contributions that enhance the core experience while maintaining simplicity are welcome.

## 📄 License

Omarchy is released under the [MIT License](https://opensource.org/licenses/MIT).

