# Basic People Counting System on DE1 FPGA

Dự án thiết kế và hiện thực hóa hệ thống thống kê lưu lượng người ra vào sử dụng kit phát triển **FPGA DE1**. Hệ thống tích hợp cảm biến hồng ngoại để đếm người, hiển thị trạng thái qua LED/7-Segment và cảnh báo bằng Buzzer.

## 📌 Giới thiệu dự án
Dự án tập trung vào việc ứng dụng công nghệ vi mạch và hệ thống nhúng để giải quyết bài toán giám sát mật độ người trong thực tế. 
- **Mục tiêu:** Củng cố kiến thức thiết kế mạch số (Verilog/VHDL), thao tác trực tiếp với phần cứng FPGA và rèn luyện tư duy hệ thống.
- **Tính ứng dụng:** Phù hợp cho các cửa hàng, thư viện hoặc khu vực cần quản lý lưu lượng khách hàng theo thời gian thực.

## ✨ Tính năng nổi bật
* **Thống kê song song:** Theo dõi đồng thời tổng lượt khách đã vào và số người hiện có trong khu vực.
* **Cảnh báo đa cấp:**
    * **Mức Xanh:** Hoạt động bình thường.
    * **Mức Vàng:** Lượng người tăng cao, cần lưu ý.
    * **Mức Đỏ:** Đạt ngưỡng tối đa.
    * **Buzzer:** Cảnh báo âm thanh khi quá tải.
* **Cơ chế Reset độc lập:** * Reset trạng thái hiện tại (Reset số người đang ngồi) mà không làm mất dữ liệu thống kê tổng lượt khách trong ngày.
    * Hỗ trợ quản lý dữ liệu linh hoạt cho báo cáo doanh thu dài hạn.

## 🛠 Công cụ và Công nghệ
* **Hardware:** Terasic DE1-SoC (Cyclone V).
* **Language:** Verilog HDL / VHDL.
* **Software:** Quartus II v13.1.
* **Peripheral:** * Infrared (IR) Sensors.
    * 7-Segment Displays (HEX0-HEX5).
    * LEDs & Buzzer.
    * Breadboard.

## 📂 Cấu trúc thư mục (Gợi ý)
```text
├── src/                # Chứa mã nguồn Verilog (.v)
├── simulation/         # Các file testbench mô phỏng
├── constraints/        # File gán chân (.qsf hoặc .sdc)
├── docs/               # Tài liệu báo cáo, sơ đồ khối
└── README.md
