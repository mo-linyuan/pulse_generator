 module key_filter(
    clk,
    reset_n,
    key_in,
    key_flag,
    key_state
    );

    input clk;//时钟信号
    input reset_n;//复位信号，低电平有效
    input key_in; //按键输入

    output reg key_flag;//按键标志
    output reg key_state;//按键状态
    
    //?????????????????????
    localparam 
        IDEL= 4'b0001,
        FILTER0=4'b0010,
        DOWN=4'b0100,
        FILTER1=4'b1000;

    reg [3:0]state;//??????
    reg [19:0]cnt;//??????
    reg en_cnt;//??????????
    reg cnt_full;
    reg [1:0]sync_key;//????????
    reg [1:0] r_key;//????????
    wire key_in_pedge;//??????
    wire key_in_nedge;//?????


    //sync_key????????????????????????
    always@(posedge clk or negedge reset_n)
    if (!reset_n)
        sync_key <=2'b0;
    else
        sync_key <= {sync_key[0],key_in};
    
    //r_key,???D?????????????????????????????????
    always@(posedge clk or negedge reset_n)
    if (!reset_n)
        r_key<=2'b0;
    else
        r_key <= {r_key[0],sync_key[1]};

    //??????    
    assign key_in_pedge = r_key == 2'b01;
    assign key_in_nedge = r_key == 2'b10;
    
    //cnt
    always@(posedge clk or negedge reset_n)
	if(!reset_n)
		cnt <= 20'd0;
	else if(en_cnt)
		cnt <= cnt + 1'b1;
	else
		cnt <= 20'd0;
    //en_full,????20ms?????????????
    always@(posedge clk or negedge reset_n)
	if(!reset_n)
		cnt_full <= 1'b0;
	else if(cnt == 20'd999_999)
		cnt_full <= 1'b1;
	else
		cnt_full <= 1'b0;

    //????????????
    always@(posedge clk or negedge reset_n)
    if(!reset_n)begin
        en_cnt<=1'b0;
        state<=IDEL;
        key_flag<=1'b0;
        key_state<=1'b1;
    end               
    else begin
        case (state)
            IDEL:begin
                key_flag<=1'b0;
                if (key_in_nedge) begin
                    state<=FILTER0;
                    en_cnt<=1'b1;
                end
                else
                    state<=IDEL;
            end 

            FILTER0:begin
                if (cnt_full) begin
                    key_flag<=1'b1;
                    key_state<=1'b0;
                    en_cnt<=0;
                    state<=DOWN;
                end
                else if (key_in_pedge) begin
                    state<=IDEL;
                    en_cnt<=1'b0;
                end
                else
                    state<=FILTER0;
            end

            DOWN:begin
                key_flag<=1'b0;
                if (key_in_pedge) begin
                    state<=FILTER1;
                    en_cnt<=1;
                end
                else
                    state<=DOWN;
            end

            FILTER1:begin
                if (cnt_full) begin
                    key_flag<=1'b1;
                    key_state<=1'b1;
                    state<=IDEL;
                    en_cnt<=0;            
                end
                else if (key_in_nedge) begin
                    en_cnt<=0;
                    state<=DOWN;
                end
                else
                    state<=FILTER1;
            end

            default: begin
                state<=IDEL;
                en_cnt<=1'b0;
                key_flag<=1'b0;
                key_state<=1'b1;
            end
        endcase
    end
endmodule
