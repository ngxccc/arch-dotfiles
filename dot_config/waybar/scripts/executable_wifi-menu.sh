#!/bin/sh

chosen=$(nmcli -t -f SSID,SECURITY,SIGNAL device wifi list --rescan yes |
    rofi -dmenu -p "WiFi Networks:" -i -theme-str 'window {width: 420px;}' -lines 15)

if [ -n "$chosen" ]; then
    ssid=$(echo "$chosen" | cut -d':' -f1)
    security=$(echo "$chosen" | cut -d':' -f2)

    # Dấu >/dev/null 2>&1 để nuốt mọi output dư thừa, chỉ lấy Exit Code
    if nmcli connection show "$ssid" >/dev/null 2>&1; then

        # Nhánh 1: Mạng người quen -> Kích hoạt hồ sơ cũ (không hỏi pass)
        notify-send "WiFi" "Connecting to known network: $ssid..."
        if nmcli connection up id "$ssid" >/dev/null 2>&1; then
            notify-send "WiFi" "Connected to $ssid"
        else
            notify-send -u critical "WiFi" "Failed to connect to $ssid"
        fi

    else
        # Nhánh 2: Mạng người lạ -> Kiểm tra xem có cài khóa không
        if [ "$security" != "--" ] && [ -n "$security" ]; then

            # Kích hoạt giao diện hỏi pass
            pass=$(rofi -dmenu -p "Password for '$ssid':" -password -theme-str 'window {width: 500px;}')

            if [ -n "$pass" ]; then
                notify-send "WiFi" "Authenticating with $ssid..."
                if nmcli device wifi connect "$ssid" password "$pass" >/dev/null 2>&1; then
                    notify-send "WiFi" "Connected to $ssid"
                else
                    notify-send -u critical "WiFi" "Authentication failed for $ssid"
                fi
            fi

        else
            # Nhánh 3: Mạng mở (Wifi cafe, sân bay) -> Vào thẳng
            notify-send "WiFi" "Connecting to open network: $ssid..."
            if nmcli device wifi connect "$ssid" >/dev/null 2>&1; then
                notify-send "WiFi" "Connected to $ssid"
            else
                notify-send -u critical "WiFi" "Failed to connect to open network $ssid"
            fi
        fi
    fi
fi
