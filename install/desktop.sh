yay -S --noconfirm --needed \
  brightnessctl playerctl pamixer pavucontrol wireplumber \
  fcitx5 fcitx5-gtk fcitx5-qt fcitx5-configtool \
  wl-clip-persist clipse \
  nautilus sushi gnome-calculator \
  vlc evince imv

# Install Google Chrome (with Chromium fallback)
if ! yay -S --noconfirm --needed google-chrome; then
  echo "Google Chrome failed, installing Chromium as fallback..."
  yay -S --noconfirm --needed chromium
  # Update browser config to use chromium if Chrome failed
  sed -i 's/google-chrome-stable/chromium/g' ~/.config/hypr/hyprland.conf
fi
