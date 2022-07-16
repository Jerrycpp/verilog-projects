`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/24/2022 02:32:54 PM
// Design Name: 
// Module Name: fsm_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns/10 ps
module led_fsm_tb;
    reg clk, rst;
    reg [3:0] inp;
    wire [3:0] out;
    
    
    led_fsm  #(.CYCLE(5)) UUT (.clk(clk), .rst(rst), .inp(inp), .out(out));
    
    always #20 clk=~clk;
    initial
        begin
            clk <= 0;
            rst <= 0;
            inp <= 0;
            rst <= 1;
            #20;
            rst <= 0;
            
            
            inp <= 4'b0001;
            #30;
            inp <= 4'b0010;
            #139;
            inp <= 4'b0001;
            #32;
            inp <= 4'b0100;
            #145;
            inp <= 4'b0001;
            #32;
            inp <= 4'b1000;
            
            
        end

endmodule
