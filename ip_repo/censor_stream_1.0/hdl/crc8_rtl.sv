`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2022 12:37:48
// Design Name: 
// Module Name: crc8_rtl
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

module crc8_rtl(
    input clock,
    input reset,
    input enable,
    input init,
    input [7:0] char_in,
    output [7:0] crc_out);
    
    reg [7:0]   crc_reg;
    wire [7:0]  next_crc;
     
    assign crc_out = crc_reg;
    
    always @ (posedge clock)
    if(reset) begin
        crc_reg <= 8'h00;
    end
    else if(enable) begin
        if(init) begin
            crc_reg <= 8'h00;
        end
        else begin
            crc_reg <= next_crc;
        end
    end
        
    assign next_crc[0] = (char_in[2] ^ char_in[4] ^ char_in[5] ^ crc_reg[2] ^ crc_reg[4] ^ crc_reg[5]);
    assign next_crc[1] = (char_in[0] ^ char_in[3] ^ char_in[5] ^ char_in[6] ^ crc_reg[0] ^ crc_reg[3] ^ crc_reg[5] ^ crc_reg[6]);
    assign next_crc[2] = (char_in[0] ^ char_in[1] ^ char_in[4] ^ char_in[6] ^ char_in[7] ^ crc_reg[0] ^ crc_reg[1] ^ crc_reg[4] ^ crc_reg[6] ^ crc_reg[7]);
    assign next_crc[3] = (char_in[0] ^ char_in[1] ^ char_in[4] ^ char_in[7] ^ crc_reg[0] ^ crc_reg[1] ^ crc_reg[4] ^ crc_reg[7]);
    assign next_crc[4] = (char_in[0] ^ char_in[1] ^ char_in[4] ^ crc_reg[0] ^ crc_reg[1] ^ crc_reg[4]);
    assign next_crc[5] = (char_in[1] ^ char_in[2] ^ char_in[5] ^ crc_reg[1] ^ crc_reg[2] ^ crc_reg[5]);
    assign next_crc[6] = (char_in[0] ^ char_in[2] ^ char_in[3] ^ char_in[6] ^ crc_reg[0] ^ crc_reg[2] ^ crc_reg[3] ^ crc_reg[6]);
    assign next_crc[7] = (char_in[1] ^ char_in[3] ^ char_in[4] ^ char_in[7] ^ crc_reg[1] ^ crc_reg[3] ^ crc_reg[4] ^ crc_reg[7]);
    
endmodule