module i2c_fsm (
    sda0, out, rst, clk, scl0
);
    input sda0, rst, clk, scl0;
    output out;
    reg [1:0] state, next_state;
    reg [6:0] address;
    reg [7:0] data_in; // data_in or cmd
    reg rw;
    reg rdy; // next bit Ready to go?
    reg [4:0] counter;
    wire start, stop, scl, sda;
    reg [1:0] ack;
    localparam IDLE = 0, START = 2'd1, READ = 2'd2, WRITE = 2'd3;
    i2cwave_binary sclwave (.clk(clk), .rst(rst), .inp(scl0), .out(scl));
    i2cwave_binary sdawave (.clk(clk), .rst(rst), .inp(sda0), .out(sda));
    edge_detector start_stop_detect (.clk(clk), .inp(sda), .posedge_out(stop), .negedge_out(start), .rst(rst));
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            rw <= 1'bz;
            address <= 7'b0000000;
            data_in <= 8'b00000000;
            rdy <= 0;
            counter <= 4'b0000;
            ack <= 0;
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
                else if (rw == 1 && scl) next_state = READ;
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
        case (state):
            START : begin
                if (counter < 4'd7) begin
                if (scl == 1 && rdy == 1) begin
                    address <= {address[6:1], sda};
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
                    rw <= sda;
                end
            end
            end
            WRITE : begin
                if (ack == 0 && scl == 1) begin
                    sda <= 0;
                    ack <= 1;
                end
                else if (ack == 1 && scl == 1 && rdy == 1) begin
                    data_in <= {data_in[7:1], sda};
                    rdy <= 0;
                    counter <= counter + 1;
                end
                else if (ack == 1 && scl == 0) begin
                    rdy <= 1;
                    if (counter == 4'd8) begin
                        ack <= 0;
                        counter <= 4'd0;
                    end
                end
            end
            READ : begin

            end
        endcase
    end




    
endmodule