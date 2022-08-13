module edge_detector(
    clk, inp, posedge_out, rst, negedge_out
    );
    
    input clk, inp, rst;
    output posedge_out, negedge_out;
    wire out_flop1;
    
    d_ff flop1 (.clk(clk), .inp(inp), .out(out_flop1), .rst(rst));
    
    assign posedge_out = out_flop1 & (~inp);
    assign negedge_out = (~out_flop1) & inp;
endmodule