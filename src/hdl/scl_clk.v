module scl_clk (scl_in, clk, scl_out, rst);
    input scl_in, clk, rst;
    output reg scl_out;
    reg [1:0] two_cons_state;
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            two_cons_state <= 2'b00;
        end
        else begin
            if (^two_cons_state) begin
                scl_out <= two_cons_state[0];
            end
            two_cons_state <= {two_cons_state[0], scl_in};
        end
    end


endmodule