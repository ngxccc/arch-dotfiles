# 📑 TMUX CHEATSHEET & REFERENCE

Đây là bản ghi nhớ phím tắt và cấu hình cho Tmux giúp mày không bị quên trong giai đoạn đầu chuyển đổi.

---

## 🚀 CẤU HÌNH PHÍM TẮT CHÍNH (PREFIX)
*   **Prefix:** `Ctrl + a` (Thay thế cho mặc định `Ctrl + b` để đỡ với tay).
    *   *Mọi phím tắt trong Tmux đều bắt đầu bằng việc nhấn tổ hợp phím này rồi mới gõ phím tiếp theo.*

---

## 🔍 BÍ THUẬT TRA CỨU PHÍM TẮT (WHICH-KEY EQUIVALENT)
Tmux có các công cụ tra cứu cực mạnh tích hợp sẵn để mày không bao giờ bị quên phím:

1.  **Tra cứu toàn bộ phím tắt (Searchable List):**
    *   Nhấn **`Prefix`** rồi gõ **`?`** (tức là `Ctrl + a` $\rightarrow$ `?`).
    *   Nó sẽ mở ra danh sách tất cả các phím tắt hiện có. Mày có thể dùng phím mũi tên hoặc `j`/`k` để di chuyển, và nhấn `/` để gõ tìm kiếm từ khóa. Nhấn `q` để thoát.
2.  **Xem mô tả ngắn gọn bằng CLI:**
    *   Gõ lệnh: `tmux list-keys -N` để liệt kê các phím kèm ghi chú ngắn gọn bằng tiếng Anh.
3.  **Tự động tạo bảng tra cứu Which-Key động (Tùy chọn - Cần cài đặt thêm):**
    *   *Yêu cầu:* Cài đặt fzf (`sudo pacman -S fzf`) và thêm dòng sau vào `tmux.conf`:
        `bind-key Space run-shell -b "tmux list-keys -N | fzf-tmux -p 80%,60% --reverse --prompt='Tmux Keys: '"`
    *   *Sử dụng:* Nhấn **`Prefix`** rồi gõ **`Space`** để bật cửa sổ popup tìm kiếm phím tắt nhanh.

---

## 📂 QUẢN LÝ CỬA SỔ & PHÂN CHIA (PANES & WINDOWS)

### 1. Quản lý Pane (Chia nhỏ màn hình - Splits)
*   **Chia dọc (Dọc trái/phải):** `Prefix` + **`|`** (phím `|` là `Shift + \`).
*   **Chia ngang (Ngang trên/dưới):** `Prefix` + **`-`** (phím dấu trừ).
*   **Di chuyển qua lại giữa các Pane (Vim style):**
    *   `Prefix` + `h` $\rightarrow$ Sang trái.
    *   `Prefix` + `l` $\rightarrow$ Sang phải.
    *   `Prefix` + `j` $\rightarrow$ Xuống dưới.
    *   `Prefix` + `k` $\rightarrow$ Lên trên.
*   **Đóng Pane hiện tại:** `Prefix` + `x` (hoặc gõ `exit`).
*   **Phóng to/Thu nhỏ Pane hiện tại (Zoom):** `Prefix` + `z` (Cực kỳ hữu dụng khi muốn xem code toàn màn hình rồi thu lại).

### 2. Quản lý Window (Các Tab ở thanh trạng thái dưới cùng)
*   **Tạo Window mới:** `Prefix` + `c` (Create).
*   **Chuyển sang Window số N:** `Prefix` + `1`, `Prefix` + `2`,...
*   **Chuyển sang Window tiếp theo / trước đó:** `Prefix` + `n` / `Prefix` + `p`.
*   **Đổi tên Window hiện tại:** `Prefix` + `,`.

---

## 💼 QUẢN LÝ SESSION (DỰ ÁN) BẰNG DÒNG LỆNH

Mỗi dự án nên chạy ở một Session riêng. Khi muốn chuyển dự án, mày thoát ra ngoài (Detach) rồi nhảy vào session khác.

| Lệnh trong Terminal | Chức năng |
| :--- | :--- |
| `tmux new -s <tên>` | Tạo session mới với tên cụ thể (Ví dụ: `tmux new -s project-A`) |
| `tmux ls` | Liệt kê tất cả các session đang chạy ngầm |
| `tmux a` | Kết nối lại (Attach) vào session gần nhất |
| `tmux a -t <tên>` | Kết nối vào session cụ thể theo tên |
| `Prefix` + `d` | Thoát ra ngoài (Detach) session hiện tại (Neovim và các tiến trình vẫn chạy ngầm bên dưới) |
| `Prefix` + `s` | Hiện danh sách các session trực quan ngay trong Tmux để chọn nhảy qua lại |
| `tmux kill-session -t <tên>` | Tắt hoàn toàn một session theo tên |
| `tmux kill-server` | Tắt sạch tất cả các session và tiến trình của Tmux |
