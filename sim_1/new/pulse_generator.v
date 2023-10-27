`timescale 1ns/1ps

module pulse_generator (
    input clk,          // 时钟信号，20ns周期
    input reset,        // 复位信号，低电平有效
    input [2:0]mode_sel, //模式选择
    input key,          // 触发按钮，低电平有效
    output [7:0] pulse, // 生成的方波脉冲，8位DAC值，0000_0000代表5V，1111_1111代表-5V
    output clka
);
assign clka = clk;

reg [20:0] counter = 0;     // 15位计数器，用于生成脉冲
reg [7:0]pulse_state = 0;       // 方波脉冲状态

parameter period = 150_000; // 脉冲周期为3ms
parameter width = 100_000;  // 脉冲宽度为2ms
parameter low_width = 50_000; // 低电平宽度为1ms

//消抖模块
wire Key_Flag;
wire Key_State;
key_filter key_filter(
    .Clk(clk),
    .Reset_n(reset),
    .Key(key),
    .Key_Flag(Key_Flag),
    .Key_State(Key_State)
    );

//幅值设置
reg [7:0]pulse_read=153;
reg [7:0]pulse_zero=128;
reg [7:0]pulse_write1,pulse_write2,pulse_write3;

always @(*) begin
    case (mode_sel)
        0: begin
            pulse_write1 = 128;//脉冲1
            pulse_write2 = 128;//脉冲2
            pulse_write3 = 128;//脉冲2
        end

        1: begin
            pulse_write1 = 128;//脉冲1
            pulse_write2 = 128;//脉冲2
            pulse_write3 = 191;//脉冲2
        end

        2: begin
            pulse_write1 = 128;//脉冲1
            pulse_write2 = 191;//脉冲2
            pulse_write3 = 128;//脉冲2
        end

        3: begin
            pulse_write1 = 128;//脉冲1
            pulse_write2 = 191;//脉冲2
            pulse_write3 = 191;//脉冲2
        end        
        
        4: begin
            pulse_write1 = 191;//脉冲1
            pulse_write2 = 128;//脉冲2
            pulse_write3 = 128;//脉冲2
        end

        5: begin
            pulse_write1 = 191;//脉冲1
            pulse_write2 = 128;//脉冲2
            pulse_write3 = 191;//脉冲2
        end

        6: begin
            pulse_write1 = 191;//脉冲1
            pulse_write2 = 191;//脉冲2
            pulse_write3 = 128;//脉冲2
        end

        7: begin
            pulse_write1 = 191;//脉冲1
            pulse_write2 = 191;//脉冲2
            pulse_write3 = 191;//脉冲2
        end


        
    endcase
end
  
always @(posedge clk or posedge reset) begin
    if (!reset) begin
        counter <= 0;
        pulse_state <= pulse_zero; // 0V
    end 
    else if(Key_State == 0) begin
        //读
        if (counter <= width) 
            pulse_state <= pulse_read; 
        else if (counter <= (width + low_width)) 
            pulse_state <= pulse_zero;
        //脉冲1
        else if (counter <= (width*2 + low_width)) 
            pulse_state <= pulse_write1; 
        else if (counter <= (width*2 + low_width*2))
            pulse_state <= pulse_zero; 
        //读
        else if (counter <= (width*3 + low_width*2))
            pulse_state <= pulse_read;
        else if (counter <= (width*3 + low_width*3))
            pulse_state <= pulse_zero; 
        //脉冲2
        else if (counter <= (width*4 + low_width*3)) 
            pulse_state <= pulse_write2; 
        else if (counter <= (width*4 + low_width*4)) 
            pulse_state <= pulse_zero;
        //读
        else if (counter <= (width*5 + low_width*4)) 
            pulse_state <= pulse_read; 
        else if (counter <= (width*5 + low_width*5)) 
            pulse_state <= pulse_zero;
        //脉冲3
        else if (counter <= (width*6 + low_width*5)) 
            pulse_state <= pulse_write3; 
        else if (counter <= (width*6 + low_width*6)) 
            pulse_state <= pulse_zero; 
        //读
        else if (counter <= (width*7 + low_width*6)) 
            pulse_state <= pulse_read;  
        else if (counter <= (width*7 + low_width*7)) 
            pulse_state <= pulse_zero;               
             
            if(counter<=period*7)
            counter <= counter + 1;
            else if(Key_Flag==1)
            counter <=0;
        end

end
assign pulse = pulse_state;

endmodule

