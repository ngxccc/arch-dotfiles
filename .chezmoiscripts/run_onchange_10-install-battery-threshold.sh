#!/bin/bash

# battery-threshold.conf hash: {{ include "dot_config/system-configs/battery-threshold.conf" | sha256sum }}

echo "[+] Đang deploy config pin vào hệ thống..."
sudo cp "$HOME/.config/system-configs/battery-threshold.conf" /etc/tmpfiles.d/
sudo systemd-tmpfiles --create /etc/tmpfiles.d/battery-threshold.conf
echo "[+] Done!"
