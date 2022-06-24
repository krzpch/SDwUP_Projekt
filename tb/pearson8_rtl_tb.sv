`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2022 15:13:40
// Design Name: 
// Module Name: pearson8_rtl_tb
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


module pearson8_rtl_tb();
    
    int i = 0;
    
    reg clock, reset, enable, init;
    reg [7:0] hash_out;
    reg [7:0] char_in;
    reg [0:4][7:0] tab_char_in = {8'h20, 8'h74, 8'h65, 8'h73, 8'h74};
    
    pearson8_rtl pearson8(clock, reset, enable, init, char_in, hash_out);
    
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
