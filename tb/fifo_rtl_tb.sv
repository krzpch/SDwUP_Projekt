`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.06.2022 12:22:22
// Design Name: 
// Module Name: fifo_rtl_tb
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


module fifo_rtl_tb();
  
  int i = 0;

  reg clock, reset, enable, write_en, read_en, full, empty;
  reg [7:0] data_in;
  reg [7:0] data_out;
  
  reg [0:63][7:0] data_in_tab = {   8'h4f, 8'h6e, 8'h20, 8'h35, 8'h20, 8'h4a, 8'h61, 8'h6e, 8'h75, 8'h61, 8'h72, 8'h79, 8'h20, 8'h32, 8'h30, 8'h32,
                                    8'h31, 8'h20, 8'h74, 8'h68, 8'h65, 8'h20, 8'h57, 8'h61, 8'h74, 8'h65, 8'h72, 8'h20, 8'h53, 8'h75, 8'h70, 8'h71,
                                    8'h6c, 8'h69, 8'h65, 8'h73, 8'h20, 8'h44, 8'h65, 8'h70, 8'h61, 8'h72, 8'h74, 8'h6d, 8'h65, 8'h6e, 8'h74, 8'h20, 
                                    8'h62, 8'h65, 8'h67, 8'h61, 8'h6e, 8'h20, 8'h74, 8'h69, 8'h64, 8'h79, 8'h69, 8'h6e, 8'h67, 8'h20, 8'h69, 8'h74 };  
  
  fifo_rtl fifofifo_rtl(clock, reset, enable, write_en, read_en, data_in, data_out, full, empty);
    
    //clock signal
    initial
     clock <= 1'b0;
    always
     #50 clock <= ~clock;

    //reset signal
    initial
    begin
        reset <= 1'b1;
        #100 reset <= 1'b0;
    end
    
    //enable signal
    initial
    begin
        enable <= 1'b0;
        #300 enable <= 1'b1;
        #7000 enable <= 1'b0;
        #400 enable <= 1'b1;
    end
    
    //read_en signal
    initial
    begin
        read_en <= 1'b0;
        #6600 read_en <= 1'b1;
    end
    
    //write_en signal
    initial
    begin
        write_en <= 1'b0;
        #200 write_en <= 1'b1;
    end
    
    //Data in
    always @ (negedge clock) begin
        data_in = data_in_tab[i];
        i++;
        i = i%64;       
    end  

endmodule