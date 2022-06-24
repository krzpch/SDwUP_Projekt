`timescale 10ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.05.2022 18:38:41
// Design Name: 
// Module Name: censor_rtl
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


module censor_rtl(
    input clock,
    input reset,
    input enable,
    input bloom_write,
    input reg [7:0] char_in,
    output reg [7:0] char_out,
    output reg data_ready
    );
    
    reg prev_fifo_read;
    reg prev_space_detect_in;
    
    reg write;
    reg check;
    reg word_detected;
    
    reg space_detect_in;
    reg space_detect_out;
    
    reg censor_en;
    
    reg fifo_write;
    reg fifo_read;
    reg fifo2_read_int;
    
    reg [7:0] char_int;
    
    reg [7:0] crc_out;
    reg [7:0] hash_out;
    reg [7:0] crc_in;
    reg [7:0] hash_in;
    
    reg [7:0] char_in_count;
    
    reg [7:0] censor_in;
    reg [7:0] censor_out;
    
    
    assign space_detect_in = ~char_in[0] & ~char_in[1] & ~char_in[2] & ~char_in[3] & ~char_in[4] & char_in[5] & ~char_in[6] & ~char_in[7];
    assign space_detect_out = ~char_int[0] & ~char_int[1] & ~char_int[2] & ~char_int[3] & ~char_int[4] & char_int[5] & ~char_int[6] & ~char_int[7];
    
    assign write = bloom_write & space_detect_in;
    assign check = ~bloom_write & space_detect_in;
    
    assign fifo_write = ~bloom_write;
    
    assign crc_in = crc_out;
    assign hash_in = hash_out;
    
    assign censor_en = censor_out[0]&~space_detect_out;
    assign censor_in[0] = word_detected;
    assign censor_in[7:1] = 7'b0000000;
    assign char_out = ( (censor_en == 1'b1) ? 8'h2A : char_int );

    assign fifo2_read_int = ( (((prev_fifo_read == 1'b0) && (fifo_read==1'b1))|| space_detect_out) ? 1'b1 : 1'b0 );
    
    crc8_rtl crc8(clock, reset, enable, space_detect_in, char_in, crc_out);
    pearson8_rtl pearson8(clock, reset, enable, space_detect_in, char_in, hash_out);
    bloom_filter_rtl bloom_filter(clock, reset, enable, write, check, crc_in, hash_in, word_detected);
    fifo_rtl fifo(clock, reset, enable, fifo_write, fifo_read, char_in, char_int, fifo_full, fifo_empty);
    fifo_rtl fifo_to_censor(clock, reset, enable, prev_space_detect_in, fifo2_read_int, censor_in, censor_out, fifo2_full, fifo2_empty);         
        
    always @ (posedge clock) begin
        if(reset) begin
            data_ready <= 1'b0;
            fifo_read <= 1'b0;       
            char_in_count <= 8'h00;
        end
        else if(enable) begin
            if(fifo_write) begin
                char_in_count++;
            end
            else begin
                fifo_read <= 1'b0;
                data_ready <= 1'b0;
                char_in_count <= 8'h00;
            end
            
            if(char_in_count == 8'h2B) begin
                fifo_read <= 1'b1;
            end
            
            if(char_in_count == 8'h2C) begin
                data_ready <= 1'b1;
            end

            prev_fifo_read <= fifo_read;
            prev_space_detect_in <= (space_detect_in & ~bloom_write);
        end
    end
    
endmodule
