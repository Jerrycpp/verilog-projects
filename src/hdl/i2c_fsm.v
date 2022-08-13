module i2c_fsm (
    sda, out, rst, clk, scl
);
    input sda, rst, clk, scl;
    output out;
    reg [1:0] state, next_state;
    reg [6:0] address;
    reg [7:0] data; // Data or cmd
    reg rw;
    reg rdy; // next bit Ready to go?
    reg [4:0] counter;
    wire start, stop;
    localparam IDLE = 0, START = 2'd1, READ = 2'd2, WRITE = 2'd3;
    edge_detector start_stop_detect (.clk(clk), .sda(sda), .posedge_out(stop), .negedge_out(start), .rst(rst));
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            rw <= 1'bz;
            address <= 7'b0000000;
            data <= 8'b00000000;
            rdy <= 0;
            counter <= 4'0000;
        end
        else begin
            state <= next_state;
        end
    end

    //handle state
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
    

    //Wrting mode
    always @ (posedge clk) begin
        if (state == START) begin
            if (counter < 4'd7) begin
                if (scl == 1 && rdy == 1) begin
                    address <= {address[6:1], inp};
                    rdy <= 0;
                    counter <= counter + 1;
                end 
                else if (scl == 0) begin
                    rdy <= 1;
                end
            end
            else if (counter == 4'd7) begin
                counter <= 4'd0;
                if (scl == 1 && rdy == 1) begin
                    rw <= inp;
                end
            end
        end
    end




    
endmodule