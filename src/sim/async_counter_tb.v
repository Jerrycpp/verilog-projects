`timescale 1 ns/10 ps
module async_counter_tb;
    reg clk, rst;
    reg inp;
    wire [3:0] out;
    integer i;
    
    async_counter UUT (.clk(clk), .rst(rst), .inp(inp), .out(out));
    
    always #20 clk=~clk;
    initial
        begin
            clk <= 0;
            rst <= 0;
            inp <= 0;
            rst <= 1;
            rst <= 0;
            for (i = 0; i < 5; i = i+1) begin
                #5;
                inp <= ~inp;
            end
            #5;
            inp <= 1;
            #100;
            for (i = 0; i < 5; i = i+1) begin
                #5;
                inp <= ~inp;
            end
        end

endmodule
