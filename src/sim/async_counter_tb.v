`timescale 1 ns/10 ps
module async_counter_tb;
    reg clk, rst;
    reg inp;
    wire [3:0] out;
    //wire deb1, deb2;
    integer i, j;
    
    async_counter UUT (.clk(clk), .rst(rst), .inp(inp), .out(out)
    //,.debug_out1(deb1), .debug_out2(deb2)
    );
    
    always #5 clk=~clk;
    initial
        begin
            clk <= 0;
            rst <= 0;
            
            inp <= 0;
            rst <= 1;
            #2;
            rst <= 0;
            for (j = 0; j < 3;j = j+1) begin
                for (i = 0; i < 10; i = i+1) begin
                #20;
                inp <= ~inp;
            end
            #20;
            inp <= 1;
            #500;
            for (i = 0; i < 10; i = i+1) begin
                #20;
                inp <= ~inp;
            end
            inp <= 0;
            #20;
            end
        end

endmodule
