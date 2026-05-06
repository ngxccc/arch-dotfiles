#!/bin/bash

# HACK: Chezmoi parser. Hash template đảm bảo script chỉ trigger khi file service bị thay đổi
battery-threshold.service hash: {{ include "dot_config/systemd-custom/battery-threshold.service" | sha256sum }}

# PERF: Triển khai file vào rootfs và reload daemon
sudo cp ~/.config/systemd-custom/battery-threshold.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now battery-threshold.service
