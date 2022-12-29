module i2cwave_binary (inp, clk, out, rst_n);
    input inp, clk, rst_n;
    output reg out;
    reg [25:0] sampling;
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            out <= inp;
            sampling <= {26{inp}};
        end
        else begin
            if (sampling == {26{1}}) begin
                out <= 1;
            end
            else if (sampling == 0) begin
                out <= 0;
            end
            sampling <= {sampling[24:0], inp};
        end
    end
endmodule