module async_counter (
    clk, inp, out, rst,
//    debug_out1, debug_out2
);
    input clk, inp, rst;
    output reg [3:0] out;
    //output debug_out1, debug_out2;
    wire imme, imme1;
    debounce #(.BOUNCING_TIME(1250000)) db_but (.clk(clk), .inp(inp), .out(imme), .rst(rst));
    posedge_detector posedge_detect (.clk(clk), .inp(imme), .out(imme1), .rst(rst));
//    assign debug_out1 = imme;
//    assign debug_out2 = imme1;
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            out <= 4'b0000;
        end
        else begin
            if (imme1) begin
                out <= out+1;
            end
        end
    end
endmodule