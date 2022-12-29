module slave_i2c (
    sda, scl0, clk0, data, rst_n, device_address
); 
    input scl0, clk0, rst_n;
    input [6:0] device_address;
    inout sda;
    wire clk;
    reg [7:0] data_out;
    reg sda_en;
    reg sda_out;
    wire sda_in;
    wire scl_rise, scl_fall;
    input [7:0] data;
    reg [6:0] addr;
    reg [7:0] addressrw;
    reg [7:0] data_in;
    reg [7:0] data_in_0;
    reg [4:0] counter;
    reg [2:0] state;
    reg [2:0] next_state;
    assign sda = sda_en ? 0 : 1'bz;
    
    localparam IDLE = 3'd0, START = 3'd1, READ = 3'd2, WRITE = 3'd3, ACK = 3'd4;
    localparam ADDRESSRW_READ = 5'd8, ACK1 = 5'd9, DATA = 5'd17, NACK2 = 5'd18;
    i2cwave_binary sclwave (.clk(clk), .rst_n(rst_n), .inp(scl0), .out(scl));
    i2cwave_binary sdawave (.clk(clk), .rst_n(rst_n), .inp(sda), .out(sda_in));
    edge_detector start_stop_detect (.clk(clk), .inp(sda), .posedge_out(stop), .negedge_out(start), .rst_n(rst_n));
    edge_detector rising_scl (.clk(clk), .inp(scl), .posedge_out(scl_rise), .negedge_out(scl_fall), .rst_n(rst_n));
    dar i2c_mem (.clk(clk), .rst_n(rst_n), .data_in(data_in_0), .data_out(data), .addr(addr), .w_en(1), .r_en(1));
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
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
                if (counter == 8) begin
                    if (addressrw[7:1] != device_address) begin
                        next_state = IDLE;
                    end
                    else begin
                        next_state = ACK;
                    end
                end
            end
            READ : begin
                if (counter == 17) begin
                    next_state = ACK;
                end
            end
            WRITE : begin
                if (counter == 17) begin
                    next_state = ACK;
                end
            end
            ACK : begin
                if (counter == 9) begin
                    if (addressrw[0] == 0) next_state = WRITE;
                    else next_state = READ;
                end
                else if (counter == 18 || (stop && scl)) next_state = IDLE;
            end
            default : begin

            end
        endcase
    end
    
    // counter (saving the number of bits from the first bit)
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            counter <= 5'b00000;
        end
        else begin
            if (state == IDLE) begin
                counter <= 5'b00000;
            end
            else if (state != IDLE) begin
                if (scl_rise) counter <= counter + 1;
            end
        end
    end

    // get addressrw (the first 8 bit after start)
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            addressrw <= 8'b0;
        end
        else begin
            if (state == START && scl_rise) begin
                addressrw <= {addressrw[6:0], sda_in};
            end
        end
    end


    // sda_en for ACK and NACK
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) sda_en <= 0;
        else begin
            if (scl_fall && state == ACK) begin
                sda_en <= 1;
            end
            else if (state == READ && scl_fall) begin
                sda_en <= ~(data_out[7]);
            end
            else if (scl_fall && (state != ACK && state != READ)) begin
                sda_en <= 0;
            end
        end
    end

    
    
    //WRITE
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_in <= 8'b0;
        end
        else begin
            if (state == WRITE && scl_rise) begin
                data_in <= {data_in[6:0], sda_in};
            end
        end
    end
    

    // DATA_OUT
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            data_out <= 8'b0;
        end
        else begin
            if (state == ACK && scl_rise) begin
                data_out <= data;
            end
            else if (state == READ && scl_fall) begin
                data_out <= data_out << 1;
            end
        end
    end
    
    // handle data_in
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            addr <= 7'b0;
        end
        else begin
            if (data_in[7] == 0) begin
                addr <= data_in[6:0];
            end
        end
    end
endmodule