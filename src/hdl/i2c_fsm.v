module i2c_fsm (
    sda, out, rst, clk, scl
);
    input sda, rst, clk, scl;
    output out;
    reg [1:0] state, next_state;
    reg [6:0] address;
    reg rw;
    wire start, stop;
    localparam IDLE = 0, START = 2'd1, READ = 2'd2, WRITE = 2'd3;
    edge_detector start_stop_detect (.clk(clk), .sda(sda), .posedge_out(stop), .negedge_out(start), .rst(rst));
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            rw <= 1'bz;
        end
        else begin
            state <= next_state;
        end
    end

    always @* begin
        next_state = state;
        case (state) 
            IDLE : begin 
                if (start && scl) begin
                    next_state = START;
                end
            end
            START : begin
                if (rw == 0 && scl) next_state = WRITE;
                else if (rw == 0 && scl) next_state = READ;
            end
            READ : begin
                if (stop && scl) begin
                    next_state = IDLE;
                end
            end
            WRITE : begin
                if (stop && scl) begin
                    next_state = IDLE;
                end
            end
            default : begin

            end
        endcase
    end
    


    
endmodule