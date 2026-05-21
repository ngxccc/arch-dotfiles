#!/bin/sh

# HACK: Sử dụng các biến toàn cục để tránh lặp lại mã (DRY)
readonly DIVIDER="---------"
readonly GOBACK="Back"
readonly ROFI_CMD="rofi -dmenu -i -p" # Thêm -i để không phân biệt hoa thường

# PERF: Hàm helper để lấy thông tin controller chỉ bằng 1 tiến trình
get_controller_info() {
    bluetoothctl show
}

# PERF: Hàm helper để lấy thông tin device chỉ bằng 1 tiến trình
get_device_info() {
    bluetoothctl info "$1"
}

# ==============================================================================
# Controller Operations
# ==============================================================================

toggle_power() {
    if get_controller_info | grep -q "Powered: yes"; then
        bluetoothctl power off
    else
        # Bật bluetooth, nếu bị soft-block thì unblock trước
        rfkill list bluetooth | grep -q 'blocked: yes' && rfkill unblock bluetooth && sleep 1
        bluetoothctl power on
    fi
    show_menu
}

toggle_scan() {
    if get_controller_info | grep -q "Discovering: yes"; then
        pkill -f "bluetoothctl --timeout 5 scan on" # Dùng pkill gọn hơn
        bluetoothctl scan off
    else
        bluetoothctl --timeout 5 scan on & # Chạy ngầm để không block UI
    fi
    show_menu
}

# ==============================================================================
# Device Operations
# ==============================================================================

device_menu() {
    local device_str="$1"
    local mac
    local name
    local info

    mac=$(awk '{print $2}' <<< "$device_str")
    name=$(awk '{$1=$2=""; print $0}' <<< "$device_str" | sed 's/^[ \t]*//')

    # Lấy info 1 lần duy nhất để tối ưu I/O
    info=$(get_device_info "$mac")

    local connected="Connected: no"
    local paired="Paired: no"
    local trusted="Trusted: no"

    # Sử dụng Bash Regex để kiểm tra chuỗi (Cực nhanh, không cần gọi grep)
    [[ $info == *"Connected: yes"* ]] && connected="Connected: yes"
    [[ $info == *"Paired: yes"* ]] && paired="Paired: yes"
    [[ $info == *"Trusted: yes"* ]] && trusted="Trusted: yes"

    local options="$connected\n$paired\n$trusted\n$DIVIDER\n$GOBACK\nExit"
    local chosen
    chosen="$(echo -e "$options" | $ROFI_CMD "$name")"

    case "$chosen" in
        "Connected: "*)
            [[ $chosen == *"yes"* ]] && bluetoothctl disconnect "$mac" || bluetoothctl connect "$mac"
            device_menu "$device_str"
            ;;
        "Paired: "*)
            [[ $chosen == *"yes"* ]] && bluetoothctl remove "$mac" || bluetoothctl pair "$mac"
            device_menu "$device_str"
            ;;
        "Trusted: "*)
            [[ $chosen == *"yes"* ]] && bluetoothctl untrust "$mac" || bluetoothctl trust "$mac"
            device_menu "$device_str"
            ;;
        "$GOBACK") show_menu ;;
        *) exit 0 ;;
    esac
}

# ==============================================================================
# Main Menu
# ==============================================================================

show_menu() {
    local ctrl_info
    ctrl_info=$(get_controller_info)

    if [[ $ctrl_info == *"Powered: yes"* ]]; then
        local scan="Scan: no"
        local discoverable="Discoverable: no"
        local pairable="Pairable: no"

        [[ $ctrl_info == *"Discovering: yes"* ]] && scan="Scan: yes"
        [[ $ctrl_info == *"Discoverable: yes"* ]] && discoverable="Discoverable: yes"
        [[ $ctrl_info == *"Pairable: yes"* ]] && pairable="Pairable: yes"

        # Lấy danh sách thiết bị và format lại cho đẹp
        local devices
        devices=$(bluetoothctl devices | awk '{$1=""; print $0}' | sed 's/^[ \t]*//')

        local options="$devices\n$DIVIDER\nPower: yes\n$scan\n$pairable\n$discoverable\nExit"
    else
        local options="Power: no\nExit"
    fi

    local chosen
    chosen="$(echo -e "$options" | $ROFI_CMD "Bluetooth")"

    case "$chosen" in
        "Power: "*) toggle_power ;;
        "Scan: "*) toggle_scan ;;
        "Discoverable: "*)
            [[ $chosen == *"yes"* ]] && bluetoothctl discoverable off || bluetoothctl discoverable on
            show_menu
            ;;
        "Pairable: "*)
            [[ $chosen == *"yes"* ]] && bluetoothctl pairable off || bluetoothctl pairable on
            show_menu
            ;;
        "$DIVIDER"|""|"Exit") exit 0 ;;
        *)
            # BUG: Fix lỗi chọn nhầm tên thiết bị có chứa khoảng trắng đặc biệt
            local full_device
            full_device=$(bluetoothctl devices | grep -F "$chosen" | head -n 1)
            [[ -n "$full_device" ]] && device_menu "$full_device"
            ;;
    esac
}

# Khởi chạy
if [[ "$1" == "--status" ]]; then
    # In ra icon trạng thái (Để dùng cho Waybar)
    get_controller_info | grep -q "Powered: yes" && echo "" || echo ""
else
    show_menu
fi
