`timescale 1 ns/10 ps
module debounce_tb;
    reg clk, rst;
    reg inp;
    wire out;
    integer i, j;
    
    debounce #(.BOUNCING_TIME(10)) UUT (.clk(clk), .rst(rst), .inp(inp), .out(out));
    
    always #5 clk=~clk;
    initial
        begin
            clk <= 0;
            rst <= 0;
            inp <= 0;
            rst <= 1;
            #20;
            rst <= 0;
            for (j = 0; j < 3;j = j+1) begin
                for (i = 0; i < 5; i = i+1) begin
                #20;
                inp <= ~inp;
            end
            #20;
            inp <= 1;
            #750;
            for (i = 0; i < 5; i = i+1) begin
                #20;
                inp <= ~inp;
            end
            end
        end

endmodule
