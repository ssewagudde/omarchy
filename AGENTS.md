# Agent Guidelines for Omarchy

## Build/Test Commands
- **Install**: `source install.sh` (installs all components via individual scripts)
- **Boot**: `source boot.sh` (full system setup from scratch)
- **Test individual component**: `source install/<component>.sh` (e.g., `source install/development.sh`)

## Project Structure
- `install/` - Modular installation scripts for different components
- `themes/` - Theme configurations (catppuccin, gruvbox, nord, etc.)
- `default/` - Default configurations and shell settings
- `applications/` - Desktop application files and icons

## Code Style Guidelines
- **Shell scripts**: Use `yay -S --noconfirm --needed` for package installations
- **Line continuations**: Use backslash `\` for multi-line package lists
- **Comments**: Use `#` for shell script comments, keep them concise
- **File naming**: Use kebab-case for scripts, numbered prefixes for execution order
- **Error handling**: Scripts should be idempotent and handle missing dependencies gracefully

## Development Environment
- Primary tools: cargo, clang, llvm, mise, github-cli, lazygit, lazydocker
- Terminal tools: fd, eza, fzf, ripgrep, zoxide, bat, btop
- Editor: neovim with theme-specific configurations
- Shell: bash with custom prompt and history settings