`timescale 1ns/1ps
module pulse_generator_tb;
    reg clk;
    reg reset;
    reg [2:0]mode_sel;
    reg key;
    wire [7:0] pulse;  
    wire clka;                                    
    
    //实例化被测试的pulse_generator
    pulse_generator pulse_generator(
        .clk(clk),
        .reset(reset),
        .mode_sel(mode_sel),
        .key(key),
        .pulse(pulse),
        .clka(clka)
    ); 
    
    //初始化时钟
    initial clk=1;
    always #10 clk=~clk;
    
    initial begin
        reset=0;
        key=1;
        #201 
        reset=1;
        mode_sel=3'b000;
        key=0;
        //运行30ms
        #50_000_000
        reset=0;
        key=1;
         #201 
        reset=1;
        mode_sel=3'b001;
        key=0;
        #201
        key=0;
        #50_000_000
        $stop;
    end
endmodule
