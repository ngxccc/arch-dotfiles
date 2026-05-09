#!/bin/bash

set -e

echo "--- BẮT ĐẦU CHIẾN DỊCH HỒI SINH ARCH LINUX ---"

# 1. AUR Helper
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd -
fi

# 2. Core Runtimes (FNM & Rustup)
echo "Setting up Dev Runtimes (Rust & Node.js)..."
sudo pacman -S --needed --noconfirm fnm rustup

if command -v rustup &> /dev/null; then
    echo "Configuring Rustup toolchain..."
    rustup default stable
fi

if command -v fnm &> /dev/null; then
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
    sudo pacman -S --needed --noconfirm - < backup-pkgs/pkglist-repo.txt
fi

if [ -f "backup-pkgs/pkglist-aur.txt" ]; then
    yay -S --needed --noconfirm - < backup-pkgs/pkglist-aur.txt
fi

# 4. Dotfiles Deployment
echo "Initializing Chezmoi..."
if ! command -v chezmoi &> /dev/null; then
    yay -S --noconfirm chezmoi
fi

chezmoi init --apply https://github.com/ngxccc/arch-dotfiles.git

# 5. Core Services
echo "Enabling core services..."
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now libvirtd.socket
sudo systemctl enable --now sddm.service

echo "--- CHỐT ĐƠN! REBOOT LẠI MÁY ĐỂ HƯỞNG THÀNH QUẢ ---"
