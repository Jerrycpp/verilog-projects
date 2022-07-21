`timescale 1 ns/10 ps
module debounce_tb;
    reg clk, rst;
    reg inp;
    wire out;
    integer i;
    
    debounce UUT (.clk(clk), .rst(rst), .inp(inp), .out(out));
    
    always #20 clk=~clk;
    initial
        begin
            clk <= 0;
            rst <= 0;
            inp <= 0;
            rst <= 1;
            #20;
            rst <= 0;
            for (i = 0; i < 5; i = i+1) begin
                #5;
                inp <= ~inp;
            end
            #5;
            inp <= 1;
            #500;
            for (i = 0; i < 5; i = i+1) begin
                #5;
                inp <= ~inp;
            end
        end

endmodule
