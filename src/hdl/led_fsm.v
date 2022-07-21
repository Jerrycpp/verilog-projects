module led_fsm (clk, inp, out, rst);
    input [3:0] inp;
    input clk, rst;
    output reg [3:0] out;
    

    parameter DEF_STR = 4'b0011;
    parameter CYCLE = 125000000;
    localparam STATE_RST = 2'b00, STATE_SL = 2'b01, STATE_SR = 2'b10, STATE_PAUSE = 2'b11;
    wire ov;
    reg [26:0] counter;
    reg [1:0] state, next_state;

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_RST;
        end
        else begin
            state <= next_state;
        end
    end

    always @* begin
        next_state = state;
        case (state) 
            STATE_RST : begin 
                if (inp == 4'b0010) begin
                    next_state = STATE_SL;
                end
                else if (inp == 4'b0100) begin
                    next_state = STATE_SR;
                end
                else if (inp == 4'b1000) begin
                    next_state = STATE_PAUSE;
                end
            end
            STATE_SL : begin
                if (inp == 4'b0001) begin
                    next_state = STATE_RST;
                end
                else if (inp == 4'b0100) begin
                    next_state = STATE_SR;
                end
                else if (inp == 4'b1000) begin
                    next_state = STATE_PAUSE;
                end
            end
            STATE_SR : begin
                if (inp == 4'b0001) begin
                    next_state = STATE_RST;
                end
                else if (inp == 4'b0010) begin
                    next_state = STATE_SR;
                end
                else if (inp == 4'b1000) begin
                    next_state = STATE_PAUSE;
                end
            end
            STATE_PAUSE : begin
                if (inp == 4'b0001) begin
                    next_state = STATE_RST;
                end
                else if (inp == 4'b0010) begin
                    next_state = STATE_SL;
                end
                else if (inp == 4'b0100) begin
                    next_state = STATE_SR;
                end
            end
            default : begin

            end
        endcase
    end

    always @ (posedge clk or posedge rst) begin
        if (rst) counter <= 0;
        else begin
            if (counter == CYCLE - 1) counter <= 0;
            else counter <= counter + 1;
        end
    end

    assign ov = (counter == CYCLE - 1);

    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            out <= DEF_STR;
            
            
        end
        else begin
            if (state == STATE_SL && ov) begin
                // temp <= temp << 1;
                // temp[0] <= lm_bit;
                // lm_bit <= temp[2];
                // rm_bit <= lm_bit;
                out <= {out[2:0],out[3]};
            end
            else if (state == STATE_SR && ov) begin
                out <= {out[0],out[3:1]};
            end
            else if (state == STATE_RST) begin
                out <= DEF_STR;
                
            end
            else if (state == STATE_PAUSE) begin
                out <= out;
            end
        end
    end

endmodule