 module key_filter(
    Clk,
    Reset_n,
    Key,
    Key_Flag,
    Key_State
    );
    input Clk;
    input Reset_n;
    input Key; 
    output Key_Flag;
    output reg Key_State;
    
    reg Key_P_Flag;
    reg Key_R_Flag;
    
    assign Key_Flag = Key_P_Flag | Key_R_Flag;
    
    reg [1:0]sync_Key;
    always@(posedge Clk)
        sync_Key <= {sync_Key[0],Key};//移位
     
    reg [1:0] r_Key;
    always@(posedge Clk)
        r_Key <= {r_Key[0],sync_Key[1]};//移位
        
    wire pedge_key;
    assign pedge_key = r_Key == 2'b01;
    wire nedge_key;
    assign nedge_key = r_Key == 2'b10;
    
    reg [19:0]cnt;
    
    //定义状态机
    reg [1:0]state; 
    always@(posedge Clk or negedge Reset_n)
    if(!Reset_n)begin
        state <= 0;
        Key_P_Flag<=1'b0;
        Key_R_Flag<=1'b0;
        cnt<=0;
        Key_State<=1;
    end  
    else begin 
        case(state)
            0:
                begin
                    Key_R_Flag<=0;
                    if(nedge_key)
                        state<=1;
                    else
                        state<=0;
                end
            1:
                if((pedge_key)&&(cnt < 1000000-1))begin
                    state<=0;
                    cnt<=0;
                end
                else if(cnt >= 1000000-1)begin
                    state<=2;
                    cnt<=0;
                    Key_P_Flag <=1;
                    Key_State<=0;
                end   
                else begin
                    cnt <=cnt+1'b1; 
                    state <= 1;
                end
            2:
                begin
                    Key_P_Flag<=0;
                    if(pedge_key)
                        state<=3;
                    else
                        state<=2;
                end                      
            3:
                if((nedge_key)&&(cnt<1000000-1))begin
                    state<=2;
                    cnt<=0;
                end
                else if(cnt>=1000000-1)begin
                    state<=0;
                    cnt<=0;
                    Key_R_Flag<=1'b1;
                    Key_State<=1;
                end
                else begin
                    cnt<=cnt+1'b1;
                    state<=3;
                end
            endcase                            
    end                 
endmodule
