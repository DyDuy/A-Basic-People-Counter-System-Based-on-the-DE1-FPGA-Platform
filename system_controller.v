module system_controller (
    // --- INPUTS ---
    input  wire        clk,         // Xung nhịp 50MHz
    input  wire        rst_n,       // Reset tích cực thấp
    input  wire [8:0]  SW,          // SW[8]: Mode, SW[7:0]: Setup Limit
    input  wire [6:0]  cnt_bin_in,  // Số khách hiện tại (Input quan trọng nhất của FSM)
    input  wire [6:0]  cnt_up_in,   // Tổng số khách (Chỉ để hiển thị)

    // --- OUTPUTS ---
    output reg         GPIO_GREEN,      
    output reg         GPIO_YELLOW,     
    output reg         GPIO_RED,        
    output reg         GPIO_BUZZER,
    output reg  [6:0]  HEX0, HEX1, HEX2, HEX3
);

    // =========================================================
    // 1. ĐỊNH NGHĨA TRẠNG THÁI (State Encoding)
    // =========================================================
    localparam W_GREEN  = 2'd0;
    localparam W_YELLOW = 2'd1;
    localparam W_RED    = 2'd2;
    localparam W_BUZZER = 2'd3;

    reg [1:0] current_state, next_state;

    // =========================================================
    // 2. TÍNH TOÁN NGƯỠNG (THRESHOLDS)
    // =========================================================
    // A: 0-60%   | B: 60-80% | C: 80-100% | D: >100%
    wire [7:0] setup_val = (SW[7:4] * 4'd10) + SW[3:0];
    wire [7:0] th_yellow = (setup_val * 60) / 100; 
    wire [7:0] th_red    = (setup_val * 80) / 100;

    // =========================================================
    // 3. FSM SEQUENTIAL LOGIC (Flip-Flops)
    // =========================================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= W_GREEN; // Mũi tên Reset_n trong hình
        end else begin
            current_state <= next_state;
        end
    end

    // =========================================================
    // 4. FSM COMBINATIONAL LOGIC (Logic chuyển trạng thái)
    // =========================================================
    // Logic này mô tả chính xác các mũi tên A, B, C, D trong sơ đồ
    always @(*) begin
        next_state = current_state; // Mặc định giữ trạng thái (Loop)
        
        if (setup_val > 0) begin
            case (current_state)
                // --- TRẠNG THÁI XANH ---
                W_GREEN: begin
                    // Nếu khách > 60% (Vùng B) -> Sang Vàng
                    if (cnt_bin_in > th_yellow) 
                        next_state = W_YELLOW;
                    else 
                        next_state = W_GREEN; // Loop A
                end

                // --- TRẠNG THÁI VÀNG ---
                W_YELLOW: begin
                    // Nếu khách <= 60% (Vùng A) -> Về Xanh
                    if (cnt_bin_in <= th_yellow)
                        next_state = W_GREEN;
                    // Nếu khách > 80% (Vùng C) -> Sang Đỏ
                    else if (cnt_bin_in > th_red)
                        next_state = W_RED;
                    else
                        next_state = W_YELLOW; // Loop B
                end

                // --- TRẠNG THÁI ĐỎ ---
                W_RED: begin
                    // Nếu khách <= 80% (Vùng B) -> Về Vàng
                    if (cnt_bin_in <= th_red)
                        next_state = W_YELLOW;
                    // Nếu khách > 100% (Vùng D) -> Hú Còi
                    else if (cnt_bin_in > setup_val)
                        next_state = W_BUZZER;
                    else
                        next_state = W_RED; // Loop C
                end

                // --- TRẠNG THÁI CÒI (BUZZER) ---
                W_BUZZER: begin
                    // Nếu khách <= 100% (Vùng C) -> Về Đỏ
                    if (cnt_bin_in <= setup_val)
                        next_state = W_RED;
                    else
                        next_state = W_BUZZER; // Loop D
                end
                
                default: next_state = W_GREEN;
            endcase
        end else begin
            next_state = W_GREEN;
        end
    end

    // =========================================================
    // 5. OUTPUT LOGIC (MOORE OUTPUT)
    // =========================================================
    // Ngõ ra chỉ phụ thuộc vào State hiện tại
    always @(*) begin
        // Mặc định tắt hết
        GPIO_GREEN = 0; GPIO_YELLOW = 0; GPIO_RED = 0; GPIO_BUZZER = 0;

        case (current_state)
            W_GREEN:  GPIO_GREEN  = 1;
            W_YELLOW: GPIO_YELLOW = 1;
            W_RED:    GPIO_RED    = 1;
            W_BUZZER: begin
                GPIO_BUZZER = 1;
                GPIO_RED    = 1; // Kèm đèn đỏ cho gay gắt
            end
        endcase
    end

    // =========================================================
    // 6. PHẦN HIỂN THỊ LED 7 ĐOẠN (Display Controller)
    // =========================================================
    // Phần này độc lập với FSM, chỉ lấy dữ liệu để hiển thị
    
    // Khai báo dây nối giải mã
    wire [6:0] s_cur_1, s_cur_10; // Current
    wire [6:0] s_tot_1, s_tot_10; // Total
    wire [6:0] s_set_1, s_set_10; // Setup

    // Gọi các module giải mã (Instantiate)
    bcd_to_7seg d1 (.bcd_in(cnt_bin_in % 10), .seg_out(s_cur_1));
    bcd_to_7seg d2 (.bcd_in(cnt_bin_in / 10), .seg_out(s_cur_10));
    
    bcd_to_7seg d3 (.bcd_in(cnt_up_in % 10),  .seg_out(s_tot_1));
    bcd_to_7seg d4 (.bcd_in(cnt_up_in / 10),  .seg_out(s_tot_10));
    
    bcd_to_7seg d5 (.bcd_in(SW[3:0]),         .seg_out(s_set_1));
    bcd_to_7seg d6 (.bcd_in(SW[7:4]),         .seg_out(s_set_10));

    // Logic chọn hiển thị dựa vào SW[8] (Multiplexer)
    always @(*) begin
        if (SW[8] == 0) begin
            // Mode xem hiện tại + Setup
            HEX0 = s_cur_1;
            HEX1 = s_cur_10;
            HEX2 = s_set_1;
            HEX3 = s_set_10;
        end else begin
            // Mode xem tổng số
            HEX0 = s_tot_1;
            HEX1 = s_tot_10;
            HEX2 = 7'b1111111; // Off
            HEX3 = 7'b1111111; // Off
        end
    end

endmodule