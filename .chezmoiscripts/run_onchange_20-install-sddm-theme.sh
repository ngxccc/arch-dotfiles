#!/bin/bash

# 10-theme.conf hash: {{ include "dot_config/system-configs/10-theme.conf" | sha256sum }}

echo "[+] Đang đồng bộ cấu hình SDDM Theme..."

# Đảm bảo thư mục đích tồn tại
sudo mkdir -p /etc/sddm.conf.d

sudo cp "$HOME/.config/system-configs/10-theme.conf" /etc/sddm.conf.d/

echo "[+] Done! SDDM Catppuccin Mocha đã sẵn sàng thực chiến."
