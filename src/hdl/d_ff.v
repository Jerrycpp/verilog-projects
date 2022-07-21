module d_ff(
    clk, inp, out, rst
    );
    input clk, inp, rst;
    output reg out;
    always @ (posedge clk) begin
        if (rst) begin
            out <= 0;
        end
        else begin
            out <= inp;
        end
    end
endmodule
