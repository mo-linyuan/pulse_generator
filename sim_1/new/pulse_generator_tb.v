`timescale 1ns/1ns
module pulse_generator_tb;
    reg clk;
    reg reset_n;
    reg [2:0]mode_sel;
    reg write_add_subtract;
    reg read_add_subtract;
    reg [2:0]key;

    wire [7:0] pulse;  
    wire clka;                                    
    
    pulse_generator pulse_generator(
        .clk(clk),
        .reset_n(reset_n),
        .mode_sel(mode_sel),
        .write_add_subtract(write_add_subtract),
        .read_add_subtract(read_add_subtract),
        .key(key),
        .pulse(pulse),
        .clka(clka)
    ); 
    
    
    initial clk=1;
    always #10 clk=~clk;
    
    initial begin
        reset_n=0;
        mode_sel=3'b111;
        read_add_subtract=0;
        write_add_subtract=0;
        key=3'b111;
        #200
        reset_n=1;
        #201

        key=3'b000;
        #40_000_000
        reset_n=0;
        $stop;
    end
endmodule
