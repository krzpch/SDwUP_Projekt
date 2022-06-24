`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2022 12:22:04
// Design Name: 
// Module Name: fifo_rtl
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


module fifo_rtl(
    input clock, 
    input reset,
    input enable, 
    input write_en, 
    input read_en,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output full, 
    output empty
);
  
  reg [5:0] wptr, rptr; // pointers tracking the stack
  reg [7:0] memory [63:0]; // the stack is 8 bit wide and 16 locations in size
  
  assign full = ( (wptr == 6'b111111) & (rptr == 6'b000000) ? 1 : 0 );
  assign empty = (wptr == rptr) ? 1 : 0;
  
  always @(posedge clock)
    if (reset) begin
        memory[0] <= 0; memory[1] <= 0; memory[2] <= 0; memory[3] <= 0;
        memory[4] <= 0; memory[5] <= 0; memory[6] <= 0; memory[7] <= 0;
        memory[8] <= 0; memory[9] <= 0; memory[10] <= 0; memory[11] <= 0;
        memory[12] <= 0; memory[13] <= 0; memory[14] <= 0; memory[15] <= 0;
        memory[16] <= 0; memory[17] <= 0; memory[18] <= 0; memory[19] <= 0;
        memory[20] <= 0; memory[21] <= 0; memory[22] <= 0; memory[23] <= 0;
        memory[24] <= 0; memory[25] <= 0; memory[26] <= 0; memory[27] <= 0;
        memory[28] <= 0; memory[29] <= 0; memory[30] <= 0; memory[31] <= 0;
        memory[32] <= 0; memory[33] <= 0; memory[34] <= 0; memory[35] <= 0;
        memory[36] <= 0; memory[37] <= 0; memory[38] <= 0; memory[39] <= 0;
        memory[40] <= 0; memory[41] <= 0; memory[42] <= 0; memory[43] <= 0;
        memory[44] <= 0; memory[45] <= 0; memory[46] <= 0; memory[47] <= 0;
        memory[48] <= 0; memory[49] <= 0; memory[50] <= 0; memory[51] <= 0;
        memory[52] <= 0; memory[53] <= 0; memory[54] <= 0; memory[55] <= 0;
        memory[56] <= 0; memory[57] <= 0; memory[58] <= 0; memory[59] <= 0;
        memory[60] <= 0; memory[61] <= 0; memory[62] <= 0; memory[63] <= 0;
        
        data_out <= 0; wptr <= 0; rptr <= 0;
    end
    else begin
        if (write_en & !full & enable) begin
            memory[wptr] <= data_in;
            wptr <= wptr + 1;
        end
        if (read_en & !empty & enable) begin
            data_out <= memory[rptr];
            rptr <= rptr + 1;
        end
    end
    
endmodule