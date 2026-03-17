module counter_up (
    input  wire clk,       
    input  wire reset_n,    
    input  wire btn_up,     
    output reg  [6:0] Q     
);
    reg btn_up_prev;
    wire btn_up_clean;
    debounce db_up (.clk(clk),.reset_n(reset_n),.noisy_in(btn_up),.clean_out(btn_up_clean));
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            Q <= 7'd0;
            btn_up_prev <= 1'b1;
        end 
        else begin
            
            if (btn_up_prev == 1'b1 && btn_up_clean == 1'b0) begin
                if (Q < 7'd99) 
                    Q <= Q + 1'b1;
                else
                    Q <= 7'd0; 
            end
            btn_up_prev <= btn_up_clean;
        end
    end
endmodule
