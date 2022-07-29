module slave_i2c (
    sda, scl, clk
); 
    input scl, clk;
    inout sda;
    wire sda_en;
    wire sda_out;
    wire sda_in;
    assign sda_in = sda;
    assign sda = sda_en ? sda_out : 1'bz;
    

endmodule