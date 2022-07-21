module posedge_detector(
    clk, inp, out, rst
    );
    parameter N_CLOCK = 125000000;
    input clk, inp, rst;
    output reg out;
    wire out_flop1, out_flop2;
    reg [25:0] counter;
    d_ff flop1 (.clk(clk), .inp(inp), .out(out_flop1), .rst(rst));
    d_ff flop2 (.clk(clk), .inp(out_flop1), .out(out_flop2), .rst(rst));
    assign imme = out_flop1 & (~out_flop2);
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            out <= 0;
        end
        else begin
            if (imme) begin
                out <= 1;
                counter <= 0;
            end
            else if (counter == N_CLOCK-1) begin
                out <= 0;
                counter <= 0;
            end
            else counter <= counter+1;
        end
    end
endmodule