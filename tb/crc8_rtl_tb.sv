`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2022 13:08:54
// Design Name: 
// Module Name: crc8_rtl_tb
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


module crc8_rtl_tb();
    
    int i = 0;
     
    reg clock, reset, enable, init;
    reg [7:0] crc_out;
    reg [7:0] char_in;
    reg [0:4][7:0] tab_char_in = {8'h20, 8'h74, 8'h65, 8'h73, 8'h74};
    
    crc8_rtl crc8(clock, reset, enable, init, char_in, crc_out);
    
    //Clock generator
    initial
     clock <= 1'b0;
    always
     #50 clock <= ~clock;
    
    //Reset signal
    initial
    begin
     reset <= 1'b1;
     #100 reset <= 1'b0;
    end
    
    //enable signal    
    initial
    begin
        enable <= 1'b0;
        #550 enable <= 1'b1;
    end
    
    //init signal
    assign init = ((char_in == 8'h20) ? 1'b1 : 1'b0);
    
    //Data in
    always @ (negedge clock) begin
        char_in <= tab_char_in[i];
        i++;
        i=i%5;
    end

endmodule
