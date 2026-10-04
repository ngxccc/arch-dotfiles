#!/bin/bash

set -e

echo "--- BẮT ĐẦU CHIẾN DỊCH HỒI SINH ARCH LINUX ---"

# 1. AUR Helper
if ! command -v yay &>/dev/null; then
  echo "Installing yay..."
  sudo pacman -S --needed --noconfirm base-devel git
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay && makepkg -si --noconfirm
  cd -
fi

# 2. Core Runtimes (FNM & Rustup)
echo "Setting up Dev Runtimes (Rust & Node.js)..."
sudo pacman -S --needed --noconfirm fnm rustup

if command -v rustup &>/dev/null; then
  echo "Configuring Rustup toolchain..."
  rustup default stable
fi

if command -v fnm &>/dev/null; then
  echo "Configuring FNM..."
  eval "$(fnm env --shell bash)"
  fnm install --lts
  fnm default lts
fi

# BUG: Ensure user-space binaries are strictly available in the current shell execution context
export PATH="$HOME/.cargo/bin:$PATH"

# 3. Sync Packages
echo "Syncing packages from backup lists..."
if [ -f "backup-pkgs/pkglist-repo.txt" ]; then
  sudo pacman -S --needed --noconfirm - <backup-pkgs/pkglist-repo.txt
fi

if [ -f "backup-pkgs/pkglist-aur.txt" ]; then
  yay -S --needed --noconfirm - <backup-pkgs/pkglist-aur.txt
fi

# 4. Dotfiles Deployment
echo "Initializing Chezmoi..."
if ! command -v chezmoi &>/dev/null; then
  yay -S --noconfirm chezmoi
fi

chezmoi init --apply https://github.com/ngxccc/arch-dotfiles.git


# 5. DBX Web Standalone Setup
echo "Installing DBX Web Standalone..."
if [ -x "$HOME/.local/bin/dbx-update" ]; then
  "$HOME/.local/bin/dbx-update"
else
  DBX_DIR="$HOME/.local/share/dbx-web"
  mkdir -p "$DBX_DIR" "$DBX_DIR/data" "$HOME/.local/bin"
  curl -sL https://api.github.com/repos/t8y2/dbx/releases/latest \
    | grep '"browser_download_url":' \
    | grep 'browser-static\.tar\.gz' \
    | head -n 1 \
    | cut -d'"' -f4 \
    | xargs curl -L \
    | tar -xz -C "$DBX_DIR" --strip-components=1
  chmod +x "$DBX_DIR/dbx" "$DBX_DIR/bin/dbx-web-bin"
  ln -sf "$DBX_DIR/dbx" "$HOME/.local/bin/dbx"
fi

if [ ! -f "$HOME/.local/share/dbx-web/.env" ]; then
  cat << 'EOF' > "$HOME/.local/share/dbx-web/.env"
DBX_PORT=4224
DBX_DATA_DIR=$HOME/.local/share/dbx-web/data
DBX_DISABLE_PASSWORD=1
EOF
fi

# Reload systemd user daemon for dbx.service
systemctl --user daemon-reload || true
# 6. Core Services
echo "Enabling core services..."
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now libvirtd.socket
sudo systemctl enable --now sddm.service
sudo systemctl enable --now "fcitx5-lotus-server@$(whoami).service"

sudo systemctl disable --now cups.service
sudo systemctl enable --now cups.socket

sudo systemctl disable docker.service docker.socket
sudo systemctl stop docker.service docker.socket
sudo usermod -aG docker $USER
newgrp docker

echo "CHỐT ĐƠN! REBOOT LẠI MÁY ĐỂ HƯỞNG THÀNH QUẢ"
