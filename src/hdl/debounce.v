module debounce (clk, inp, out, rst);
    input clk, inp, rst;
    output out;
    reg [2:0] state;
    
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= 3'b000;
        end
        else begin
            state <= {state[1:0], inp};
        end
    end
    assign out = &state & inp;
endmodule