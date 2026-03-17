module debounce (
    input  wire clk,        // 50MHz
    input  wire reset_n,
    input  wire noisy_in,   // Input từ nút nhấn
    output reg  clean_out   // Output đã lọc sạch
);

    // --- 1. Tạo xung nhịp lấy mẫu (Sampling Clock) ---
    // Thay vì đếm 50 triệu xung, ta tạo 1 xung "tick" cứ mỗi 5ms - 10ms
    parameter SAMPLE_TIME = 20'd500_000; // 500,000 xung * 20ns = 10ms
    reg [19:0] timer_count;
    wire tick;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) timer_count <= 20'd0;
        else begin
            if (timer_count >= SAMPLE_TIME) timer_count <= 20'd0;
            else timer_count <= timer_count + 1'b1;
        end
    end
    assign tick = (timer_count == SAMPLE_TIME); // Tick bật lên mỗi 10ms

    // --- 2. Bộ lọc dịch chuyển (Shift Register Filter) ---
    // Ý tưởng: Lưu 4 trạng thái gần nhất mỗi khi có Tick.
    // Chỉ khi cả 4 lần đều là 0 hoặc cả 4 đều là 1 thì mới đổi ngõ ra.
    
    reg [3:0] shift_reg; // Thanh ghi lưu 4 mẫu
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            shift_reg <= 4'b1111; // Mặc định nhả nút (Active Low)
            clean_out <= 1'b1;
        end else if (tick) begin
            // Dịch bit: Đẩy mẫu mới vào bên phải
            shift_reg <= {shift_reg[2:0], noisy_in};
            
            // Logic quyết định (Vote)
            if (shift_reg == 4'b0000)      clean_out <= 1'b0; // Chắc chắn đã nhấn
            else if (shift_reg == 4'b1111) clean_out <= 1'b1; // Chắc chắn đã nhả
            // Các trường hợp nhiễu (vd: 0101, 1100) thì giữ nguyên clean_out cũ
        end
    end

endmodule