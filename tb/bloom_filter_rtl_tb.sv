`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2022 12:03:10
// Design Name: 
// Module Name: bloom_filter_rtl_tb
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


module bloom_filter_rtl_tb();
    
    int i = 0;
    
    reg clock, reset, enable, write, check, word_detected;
    reg [7:0] hash1, hash2;
    
    reg [0:12][7:0] hash_tab = {8'h74, 8'h65, 8'h73, 8'h74, 8'h20, 8'h73, 8'h61, 8'h64, 8'h20, 8'h74, 8'h65, 8'h73, 8'h20};
    
    bloom_filter_rtl bloom_filter(clock, reset, enable, write, check, hash1, hash2, word_detected);
    
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
     #5000 reset <= 1'b1;
    end
    
    //enable signal
    initial
    begin
     enable <= 1'b0;
     #200 enable <= 1'b1;
    end
    
    //write signal
    initial
    begin
     write <= 1'b0;
     #100 write <= 1'b1;
     #200 write <= 1'b0;
    end
    
    //check signal
    initial
    begin
     check <= 1'b0;
     #500 check <= 1'b1;
     #100 check <= 1'b0;
     #200 check <= 1'b1;
     #100 check <= 1'b0;
    end
    
    always @ (negedge clock) begin
        hash1 = hash_tab[i];
        hash2 = hash_tab[i+6];
        i++;
        i = i%6;
    end

    
endmodule
