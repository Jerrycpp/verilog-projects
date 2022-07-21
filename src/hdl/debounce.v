module debounce (clk, inp, out, rst);
    input clk, inp, rst;
    output reg out;
    reg [2:0] state;
    reg [21:0] cycle;
    parameter BOUNCING_TIME = 1250000;
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= 3'b000;
            out <= 0;
            cycle <= 0;
        end
        else begin
            if (&state & inp == 1) out <= 1;
            else out <= 0;
            if (cycle == BOUNCING_TIME) begin
                state <= {state[1:0], inp};
                cycle <= 0;
            end
            else cycle <= cycle + 1;
        end
    end

endmodule