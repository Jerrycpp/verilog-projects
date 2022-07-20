module debounce (clk, inp, out, rst);
    input clk, inp, rst;
    output reg out;
    reg [2:0] state;
    parameter STD_SAMPLE = 3'b111;
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= 3'b000;
            out <= 0;
        end
        else begin
            if (inp == 0) begin
                state <= 3'b000;
                if (out == 1) out <= 0;
            end
            else begin
                if (state==3'b111) begin
                    out <= 1;
                end
                else state = {state[1:0], 1};
            end
        end
    end
endmodule