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

```bash
curl -fsSL https://raw.githubusercontent.com/ssewagudde/omarchy/master/boot.sh | bash
```

## 🍎 MacBook Features

Omarchy is specially optimized for MacBook users:

- **Natural trackpad scrolling** and 3-finger workspace gestures
- **Mac-style shortcuts**: Cmd+C/V/X/A/Z/Q/W/N/R work as expected
- **Caps Lock → Control** mapping for familiar keyboard behavior
- **Optimal 1.66x scaling** for crisp text on high-DPI displays
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

After installation:
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

## 🎨 Themes

Switch between beautiful themes:
- Catppuccin (default)
- Gruvbox
- Nord
- Tokyo Night
- Kanagawa
- Everforest

## 📚 Documentation

For detailed configuration and customization, see the [AGENTS.md](AGENTS.md) file.

Read more at [omarchy.org](https://omarchy.org).

## 🤝 Contributing

Omarchy is designed to be a solid foundation that works out of the box. Contributions that enhance the core experience while maintaining simplicity are welcome.

## 📄 License

Omarchy is released under the [MIT License](https://opensource.org/licenses/MIT).

