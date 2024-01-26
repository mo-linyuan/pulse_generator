`timescale 1ns/1ns

module pulse_generator (
    input clk,          // 时钟信号，20ns周期
    input reset_n,        // 复位信号，低电平有效
    input [2:0]mode_sel, //模式选择
    input write_add_subtract,//写加减模式
    input read_add_subtract,//读加减模式
    input [2:0]key,          
    output reg [7:0] pulse, // 生成的方波脉冲，8位DAC值，0000_0000代表5V，1111_1111代表-5V
    output clka
);
assign clka = clk;

reg [21:0] counter;     // 15位计数器，用于生成脉冲
reg [7:0]pulse_read;
reg [7:0]pulse_zero=128;
reg [7:0]pulse_write;
reg [7:0]pulse_write1,pulse_write2,pulse_write3;

wire [2:0]key_flag;
wire [2:0]key_state;

localparam 
    width_read = 150_000,  // 脉冲宽度为3ms
    width_write = 100_000, //脉冲宽度为2ms
    low_width = 100_000, // 低电平宽度为2ms
    period_read =width_read + low_width,
    period_write =width_write + low_width ;

//触发按钮
key_filter key_filter0(
    .clk(clk),
    .reset_n(reset_n),
    .key_in(key[0]),
    .key_flag(key_flag[0]),
    .key_state(key_state[0])
    );
//pulse_read按钮
key_filter key_filter1(
    .clk(clk),
    .reset_n(reset_n),
    .key_in(key[1]),
    .key_flag(key_flag[1]),
    .key_state(key_state[1])
    );
//pulse_write按钮
key_filter key_filter2(
    .clk(clk),
    .reset_n(reset_n),
    .key_in(key[2]),
    .key_flag(key_flag[2]),
    .key_state(key_state[2])
    );

//读电压加减
always @(posedge clk or negedge reset_n) begin
if (!reset_n)
    pulse_read<=162;//-1.3V
else begin
    case (read_add_subtract)
    0: begin
        if(key_flag[1] && key_state[1]==0)
            pulse_read <= pulse_read + 3;
    end

    1: begin
        if(key_flag[1] && key_state[1]==0)
            pulse_read <= pulse_read - 3; 
    end
endcase
end
end

//写电压加减
always @(posedge clk or negedge reset_n) begin
if (!reset_n)
    pulse_write<=201;//-2.8V
else begin
    case (write_add_subtract)
    0: begin
        if(key_flag[2] && key_state[2]==0)
            pulse_write <= pulse_write + 3; 
    end

    1: begin
        if(key_flag[2] && key_state[2]==0)
            pulse_write <= pulse_write - 3; 
    end
endcase
end
end

//8种不同的脉冲选择
always @(*) begin
case (mode_sel)
    0: begin
        pulse_write1 = pulse_zero;//脉冲1
        pulse_write2 = pulse_zero;//脉冲2
        pulse_write3 = pulse_zero;//脉冲2
    end

    1: begin
        pulse_write1 = pulse_zero;//脉冲1
        pulse_write2 = pulse_zero;//脉冲2
        pulse_write3 = pulse_write;//脉冲2
    end

    2: begin
        pulse_write1 = pulse_zero;//脉冲1
        pulse_write2 = pulse_write;//脉冲2
        pulse_write3 = pulse_zero;//脉冲2
    end

    3: begin
        pulse_write1 = pulse_zero;//脉冲1
        pulse_write2 = pulse_write;//脉冲2
        pulse_write3 = pulse_write;//脉冲2
    end        
    
    4: begin
        pulse_write1 = pulse_write;//脉冲1
        pulse_write2 = pulse_zero;//脉冲2
        pulse_write3 = pulse_zero;//脉冲2
    end

    5: begin
        pulse_write1 = pulse_write;//脉冲1
        pulse_write2 = pulse_zero;//脉冲2
        pulse_write3 = pulse_write;//脉冲2
    end

    6: begin
        pulse_write1 = pulse_write;//脉冲1
        pulse_write2 = pulse_write;//脉冲2
        pulse_write3 = pulse_zero;//脉冲2
    end

    7: begin
        pulse_write1 = pulse_write;//脉冲1
        pulse_write2 = pulse_write;//脉冲2
        pulse_write3 = pulse_write;//脉冲2
    end
endcase
end

//counter
always @(posedge clk or negedge reset_n)
if (!reset_n)
    counter<=0;
else if(key_flag[0]==1&&key_state[0] == 0)
    counter <=0;
else if (counter<=(period_read*4+period_write*3))
    counter <= counter + 1;
else
    counter<=counter;

//每次显示的所有脉冲信号
always @(posedge clk or negedge reset_n)
if (!reset_n)
    pulse <= pulse_zero; 
else if(key_state[0] == 0) begin
    //读
    if (counter <= width_read) 
        pulse <= pulse_read; 
    else if (counter <= (period_read)) 
        pulse <= pulse_zero;
    //脉冲1
    else if (counter <= (period_read+width_write)) 
        pulse <= pulse_write1; 
    else if (counter <= (period_read+period_write))
        pulse <= pulse_zero; 
    //读
    else if (counter <= (period_read + period_write + width_read))
        pulse <= pulse_read;
    else if (counter <= (period_read*2+period_write))
        pulse <= pulse_zero; 
    //脉冲2
    else if (counter <= (period_read*2 + period_write + width_write)) 
        pulse <= pulse_write2; 
    else if (counter <= (period_read*2+period_write*2)) 
        pulse <= pulse_zero;
    //读
    else if (counter <= (period_read*2+period_write*2+ width_read)) 
        pulse <= pulse_read; 
    else if (counter <= (period_read*3+period_write*2)) 
        pulse <= pulse_zero;
    //脉冲3
    else if (counter <= (period_read*3+period_write*2+width_write)) 
        pulse <= pulse_write3; 
    else if (counter <= (period_read*3+period_write*3)) 
        pulse <= pulse_zero; 
    //读
    else if (counter <= (period_read*3+period_write*3+width_read)) 
        pulse <= pulse_read;  
    else if (counter <= (period_read*4+period_write*3)) 
        pulse <= pulse_zero;        
end
endmodule