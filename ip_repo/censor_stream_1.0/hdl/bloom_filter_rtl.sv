`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2022 16:51:00
// Design Name: 
// Module Name: bloom_filter_rtl
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


module bloom_filter_rtl(
    input clock, 
    input reset,
    input enable,
    input write,
    input check,
    input reg[7:0] hash1,
    input reg[7:0] hash2,
    output reg word_detected
);   
    
    reg [511:0] filter;
    
    always @(posedge clock)
    if(reset) begin
        filter <= 512'h0;
        word_detected <= 1'b0;
    end
    else if(enable) begin
        if(write) begin
            filter[hash1] <= 1'b1;
            filter[hash2 + 9'hff] <= 1'b1;
        end
        else if(check) begin
            if(filter[hash1] == 1'b1) begin
                if(filter[hash2 + 9'hff] == 1'b1) begin
                    word_detected <= 1'b1;
                end
                else begin
                word_detected <= 1'b0;
                end
            end
            else begin
                word_detected <= 1'b0;
            end
        end
        else begin
            word_detected <= 1'b0;
        end
    end
endmodule
