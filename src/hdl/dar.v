module dar (clk, rst, data_in, data_out, w_en, r_en, addr);
    input clk, rst, w_en, r_en;
    input [7:0] data_in;
    input [1:0] addr;
    output [7:0] data_out;
    integer i;
    reg [7:0] regs [3:0];

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0 ; i < 128 ; i = i+1) begin
                regs[i] <= 8'b0;
            end
        end
        else begin
            if (w_en) begin
                regs[addr] <= data_in;
            end
            else if (r_en) begin
                data_out <= regs[addr];
            end
        end
    end



endmodule