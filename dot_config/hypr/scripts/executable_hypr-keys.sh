#!/bin/bash

# HACK: Bản nâng cấp "Porsche V12" - Fix lỗi parser rofi bằng cách loại bỏ -0 flag
# PERF: Xử lý căn lề bằng Lua (thay thế column -t) cho output đơn giản
# WHY: Mỗi dòng là 1 item riêng biệt, Rofi tự động phân biệt bằng newline

lua - <<'EOF' | rofi -dmenu -i -p "Cheatsheet" -theme-str 'window {width: 75%; border: 2px; border-color: #d50000; background-color: #000000;} listview {lines: 15; fixed-height: false;} element-text {text-color: #f5f5f5;} element {padding: 5px 10px;}' -select "$1"
local binds = {}

-- 1. Mock Object: Đánh chặn logic hl.bind để bóc tách mô tả (desc)
_G.hl = {
  dsp = setmetatable({}, {
    __index = function(_, method)
      return setmetatable({}, {
        __call = function(_, arg)
          local p = ""
          if type(arg) == "string" then p = arg end
          if type(arg) == "table" then
            local s = {}
            for k,v in pairs(arg) do table.insert(s, k .. "=" .. tostring(v)) end
            p = table.concat(s, ", ")
          end
          return method .. " -> " .. p
        end,
        __index = function(_, submethod)
          return function(arg)
            local p = ""
            if type(arg) == "string" then p = arg end
            if type(arg) == "table" then
              local s = {}
              for k,v in pairs(arg) do table.insert(s, k .. "=" .. tostring(v)) end
              p = table.concat(s, ", ")
            end
            return method .. "." .. submethod .. " -> " .. p
          end
        end
      })
    end
  }),
  bind = function(key, action, opts)
     -- Dọn dẹp tên phím (Fn keys) cho đẹp
     local k = tostring(key):gsub("XF86Audio", "Audio "):gsub("XF86Mon", "Mon ")

     -- PERF: Truy xuất desc từ tham số thứ 3 (opts)
     local d = (opts and type(opts) == "table" and opts.desc) and opts.desc or tostring(action)

     table.insert(binds, { key = k, desc = d })
  end
}

-- 2. Nạp file cấu hình (Đảm bảo đường dẫn này khớp với máy bro)
local path = os.getenv("HOME") .. "/.config/hypr/configs/keybinds.lua"
local f, err = loadfile(path)

if f then
  f() -- Thực thi file Lua để bung toàn bộ bind và vòng lặp
  table.sort(binds, function(a, b) return a.key < b.key end)

  -- Tự tính toán độ dài cột Key lớn nhất để căn lề thay cho column -t
  local max_k = 0
  for _, v in ipairs(binds) do
    if #v.key > max_k then max_k = #v.key end
  end

  -- 3. Xuất kết quả qua Pipe (Mỗi dòng là 1 item cho Rofi)
  for _, v in ipairs(binds) do
    local pad = string.rep(" ", max_k - #v.key)
    print("  " .. v.key .. pad .. "  |  " .. v.desc)
  end
else
  print("❌ ERROR PARSING: " .. tostring(err))
end
EOF
