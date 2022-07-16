module async_counter (
    clk, inp, out, rst
);
    input clk, inp, rst;
    output [3:0] out;

    wire imme1, imme;
    debounce button (.clk(clk), .inp(inp), .out(imme), .rst(rst));
    posedge_detector posedge_det (.clk(clk), .inp(imme), .out(imme), .reset(rst));
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            out <= 0;
        end
        else begin
            if (imme) begin
                out <= out+1;
            end
        end
    end
endmodule