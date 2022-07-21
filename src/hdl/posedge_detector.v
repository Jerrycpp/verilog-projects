module posedge_detector(
    clk, inp, out, rst
    );
    
    input clk, inp, rst;
    output out;
    wire out_flop1, out_flop2;
    
    d_ff flop1 (.clk(clk), .inp(inp), .out(out_flop1), .rst(rst));
    d_ff flop2 (.clk(clk), .inp(out_flop1), .out(out_flop2), .rst(rst));
    assign out = out_flop1 & (~out_flop2);
endmodule