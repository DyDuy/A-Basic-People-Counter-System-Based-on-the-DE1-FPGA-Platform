module binary_counter (
    input  wire clk,       
    input  wire reset_n,    
    input  wire btn_up,     
    input  wire btn_down,   
    output reg  [6:0] Q     
);

    reg btn_up_prev;
    reg btn_down_prev;
    wire btn_up_clean, btn_down_clean;
    debounce db_up (.clk(clk),.reset_n(reset_n),.noisy_in(btn_up),.clean_out(btn_up_clean));
    debounce db_down (.clk(clk),.reset_n(reset_n),.noisy_in(btn_down),.clean_out(btn_down_clean));
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            Q <= 7'd0;
            btn_up_prev   <= 1'b1;
            btn_down_prev <= 1'b1;
        end 
        else begin
            // Phát hiện cạnh xuống của tín hiệu đã lọc
            if (btn_up_prev == 1'b1 && btn_up_clean == 1'b0) begin
                if (Q < 7'd99) 
                    Q <= Q + 1'b1;
                else
                    Q <= 7'd0; // quay vòng về 0 nếu vượt 99
            end
            else if (btn_down_prev == 1'b1 && btn_down_clean == 1'b0) begin
                if (Q > 7'd0) 
                    Q <= Q - 1'b1;
                else
                    Q <= 7'd0; // giữ nguyên 0, không quay vòng về 99
            end

            // Cập nhật trạng thái trước
            btn_up_prev   <= btn_up_clean;
            btn_down_prev <= btn_down_clean;
        end
    end
endmodule
