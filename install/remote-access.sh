yay -S --noconfirm --needed rustdesk

# Enable and start RustDesk service
sudo systemctl enable rustdesk
sudo systemctl start rustdesk

# Create desktop entry for easy access
cat > ~/.local/share/applications/rustdesk.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=RustDesk
Comment=Remote Desktop Access
Exec=rustdesk
Terminal=false
Type=Application
Icon=rustdesk
Categories=Network;RemoteAccess;
StartupNotify=true
EOF

echo "🚀 RustDesk installed and configured!"
echo "📱 Download RustDesk on your Mac from: https://rustdesk.com"
echo "🔗 Your connection ID will be shown when you start RustDesk"
echo "💡 Tip: Set a permanent password in RustDesk settings for easier access"