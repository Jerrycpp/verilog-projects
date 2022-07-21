module async_counter (
    clk, inp, out, rst
);
    input clk, inp, rst;
    output [3:0] out;

    wire imme, imme1;
    debounce db_but (.clk(clk), .inp(inp), .out(imme), .rst(rst));
    posedge_detector pos_but (.clk(clk), .inp(imme), .out(imme1), .rst(rst));
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