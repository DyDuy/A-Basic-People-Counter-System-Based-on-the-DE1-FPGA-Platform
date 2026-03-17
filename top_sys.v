module top_sys(
    input  wire [8:0] SW,
    input  wire       CLOCK_50, 
    input  wire [1:0] KEY,        
    input  wire [3:0] GPIO_1,     
    output wire [18:4] GPIO_0,    
    output wire [6:0] HEX0, HEX1, HEX2, HEX3 
);

    // Dây nối tín hiệu đếm
    wire [6:0] count_bin;      
    wire [6:0] count_up;        

    // 1. Module Đếm 1
    binary_counter u_counter (.clk(CLOCK_50), .reset_n(KEY[0]),.btn_up(GPIO_1[1]), .btn_down(GPIO_1[3]),.Q(count_bin));
    // 2. Module Đếm 2
    counter_up u_counter_up (.clk(CLOCK_50),.reset_n(KEY[1]),.btn_up(GPIO_1[1]),.Q(count_up));
    // 3. MODULE ĐIỀU KHIỂN TRUNG TÂM (Đã gộp)
    system_controller u_sys_ctrl (
        .clk        (CLOCK_50),
        .rst_n      (KEY[0]),       // Dùng KEY0 làm Reset chung
        .SW         (SW),           // Đưa cả 9 Switch vào
        .cnt_bin_in (count_bin),    // Nối dây đếm 1
        .cnt_up_in  (count_up),     // Nối dây đếm 2
        
        // Ngõ ra
        .GPIO_GREEN (GPIO_0[11]),
        .GPIO_YELLOW(GPIO_0[13]),
        .GPIO_RED   (GPIO_0[15]),
        .GPIO_BUZZER(GPIO_0[17]),
        .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3)
    );

endmodule