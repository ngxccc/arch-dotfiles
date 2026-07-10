# 🚀 Neovim Core Features & 80/20 Cheatsheet

Tài liệu này tổng hợp **20% tính năng và phím tắt cốt lõi** nhưng mang lại **80% hiệu quả công việc** trong cấu hình Neovim hiện tại của bạn. Phím `<leader>` mặc định là nút **phím cách (Space)**.

---

## 🔍 Mẹo tìm kiếm phím tắt nhanh (`<leader>fk`)

Nếu bạn quên phím tắt, hãy nhấn:

- **`Space` + `f` + `k`** (`<leader>fk`) để mở bộ tìm kiếm phím tắt trực quan qua Telescope. Bạn chỉ cần gõ tên chức năng cần làm (ví dụ: `rename`, `find`, `git`...) để xem phím tắt tương ứng.

---

## 📂 1. Quản lý File & Thư mục (File Explorer)

| Phím tắt                | Chức năng        | Mô tả                                                                                                                                         |
| :---------------------- | :--------------- | :-------------------------------------------------------------------------------------------------------------------------------------------- |
| **`Space` + `e`**       | Bật/tắt Neo-tree | Hiển thị cây thư mục trực quan ở cạnh trái. Mặc định hiển thị cả file ẩn (`visible = true`).                                                  |
| **`Space` + `c` + `d`** | Mở Oil.nvim      | Trình chỉnh sửa file/thư mục dưới dạng buffer văn bản. Sửa tên, tạo mới, xóa file y hệt như soạn thảo văn bản bình thường rồi gõ `:w` để lưu. |

- **Tính năng tự động sửa Import:** Khi bạn đổi tên (`r`) hoặc di chuyển file trong **Neo-tree**, hệ thống sẽ tự động quét dự án qua LSP và sửa lại toàn bộ đường dẫn `import` bị ảnh hưởng ở các file khác (giống VS Code).

---

## 🔍 2. Tìm kiếm nhanh (Fuzzy Finder - Telescope)

| Phím tắt                | Chức năng               | Mô tả                                                                         |
| :---------------------- | :---------------------- | :---------------------------------------------------------------------------- |
| **`Space` + `f` + `f`** | Tìm kiếm File           | Tìm nhanh file theo tên trong dự án hiện tại.                                 |
| **`Space` + `f` + `a`** | Tìm tất cả File         | Tìm file bao gồm cả các file ẩn (như `.env`, `.gitignore`...).                |
| **`Space` + `f` + `w`** | Live Grep               | Tìm kiếm từ/cụm từ bất kỳ trong nội dung của tất cả các file trong workspace. |
| **`Space` + `f` + `o`** | Mở file gần đây         | Xem danh sách các file vừa chỉnh sửa gần đây nhất.                            |
| **`Space` + `f` + `b`** | Quản lý Buffer          | Xem danh sách các file đang mở (buffer) để nhảy qua lại nhanh.                |
| **`Space` + `f` + `t`** | Tìm kiếm tất cả ghi chú | Tự động liệt kê toàn bộ các ghi chú TODO, FIXME... đang có trong dự án.       |

---

## 💻 3. Trình soạn thảo & LSP (Language Server Protocol)

| Phím tắt                | Chức năng           | Mô tả                                                                                            |
| :---------------------- | :------------------ | :----------------------------------------------------------------------------------------------- |
| **`g` + `d`**           | Go to Definition    | Nhảy thẳng tới định nghĩa của hàm, biến, hoặc class dưới con trỏ.                                |
| **`K`**                 | Hover Documentation | Hiện pop-up tài liệu chi tiết (types, mô tả) của hàm/biến dưới con trỏ.                          |
| **`g` + `r`**           | Show References     | Tìm toàn bộ các vị trí đang sử dụng hàm/biến này trong dự án qua Telescope.                      |
| **`Space` + `r` + `n`** | Rename Symbol       | Đổi tên biến/hàm và **tự động cập nhật ở tất cả các file liên quan** (giống `F2` trong VS Code). |
| **`Space` + `c` + `a`** | Code Actions        | Xem các gợi ý sửa lỗi nhanh, tự động import... của LSP tại dòng code hiện tại.                   |

- **Formatter tích hợp:** Tự động format code bằng **Biome** (hoặc Prettier làm fallback) mỗi khi bạn lưu file (`Ctrl+S`).

---

## ⚡ 4. Terminal & Quản lý Windows

### **Terminal Tích hợp (ToggleTerm)**

- **`Ctrl` + `\`** : Bật / tắt Terminal tích hợp ở góc dưới màn hình.
- **`Esc` + `Esc`** : Thoát khỏi Terminal Mode về Normal Mode (khi đang ở trong terminal) để bạn có thể copy text hoặc cuộn xem log.

### **Di chuyển cửa sổ (Pane Navigation)**

- Trong cả Normal Mode và Terminal Mode, dùng tổ hợp **`Ctrl` + `h/j/k/l`** để di chuyển nhanh con trỏ qua lại giữa các cửa sổ split hoặc cửa sổ terminal:
  - `Ctrl` + `h` $\rightarrow$ Sang cửa sổ bên trái.
  - `Ctrl` + `l` $\rightarrow$ Sang cửa sổ bên phải.
  - `Ctrl` + `j` $\rightarrow$ Xuống cửa sổ dưới.
  - `Ctrl` + `k` $\rightarrow$ Lên cửa sổ trên.

---

## 🌳 5. Git Integration (Neogit & Diffview)

| Phím tắt                | Chức năng           | Mô tả                                                                                                           |
| :---------------------- | :------------------ | :-------------------------------------------------------------------------------------------------------------- |
| **`Space` + `g` + `s`** | Git Status (Neogit) | Mở giao diện Git trực quan (y hệt Magit của Emacs). Nhấn `s` để stage, `c` để commit, `p` để push cực kỳ nhanh. |
| **`Space` + `g` + `d`** | Diffview Open       | Xem so sánh (diff) toàn bộ các file thay đổi một cách trực quan theo dạng so sánh hai bên.                      |
| **`Space` + `g` + `c`** | Diffview Close      | Đóng cửa sổ so sánh diffview lại.                                                                               |

---

## 📝 6. Markdown & Buffer Tabs

- **Bufferline:** Hiển thị các tab ngang ở trên đầu màn hình đại diện cho các file đang mở. Bạn có thể dùng chuột click vào các tab để chuyển đổi nhanh hoặc nhấn `:bd` để đóng file hiện tại.
- **Markdown Preview:** Khi đang làm việc với file `.md`:
  - Nhập lệnh `:MarkdownPreview` để mở trình duyệt xem trực tiếp giao diện hiển thị markdown được tự động đồng bộ theo thời gian thực khi bạn gõ.
  - Nhập lệnh `:MarkdownPreviewStop` để dừng xem trước.

---

## 🎨 7. Một số phím tắt soạn thảo nâng cao khác

- **`Ctrl` + `s`** : Lưu file nhanh ở mọi chế độ (Insert, Normal, Visual).
- **`Alt` + `j` / `k`** : Di chuyển dòng hiện tại (hoặc khối được bôi đen trong Visual mode) đi lên hoặc đi xuống.
- **`Alt` + `Shift` + `j` / `k`** : Nhân bản (duplicate) dòng hiện tại đi lên hoặc đi xuống.
- **`Space` + `u`** : Mở Undotree trực quan dạng cây để xem lịch sử undo/redo qua các mốc thời gian.
- **`Space` + `s`** : Tìm và thay thế từ đang nằm dưới con trỏ trên toàn bộ file hiện tại.
- **`Space` + `ss`** : Lưu trạng thái phiên làm việc hiện tại (Save Global Session).
- **`Space` + `sr`** : Khôi phục lại toàn bộ phiên làm việc cũ (Restore Global Session).
