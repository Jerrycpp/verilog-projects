module edge_detector(
    clk, inp, posedge_out, rst, negedge_out
    );
    
    input clk, inp, rst;
    output posedge_out, negedge_out;
    wire out_flop1, out_flop2;
    
    d_ff flop1 (.clk(clk), .inp(inp), .out(out_flop1), .rst(rst));
    d_ff flop2 (.clk(clk), .inp(out_flop1), .out(out_flop2), .rst(rst));
    assign posedge_out = out_flop1 & (~out_flop2);
    assign negedge_out = (~out_flop1) & out_flop2;
endmodule