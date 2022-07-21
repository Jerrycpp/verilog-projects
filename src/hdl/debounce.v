module debounce (clk, inp, out, rst);
    input clk, inp, rst;
    output reg out;
    reg [2:0] state;
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= 3'b000;
            out <= 0;
        end
        else begin
            if (&state & inp == 1) out <= 1;
            else out <= 0;
            state <= {state[1:0], inp};
        end
    end

endmodule