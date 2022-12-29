module d_ff(
    clk, inp, out, rst_n
    );
    input clk, inp, rst_n;
    output reg out;
    always @ (posedge clk) begin
        if (~rst_n) begin
            out <= 0;
        end
        else begin
            out <= inp;
        end
    end
endmodule
