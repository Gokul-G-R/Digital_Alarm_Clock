
module key_register (
input rst, clk,shift,
input [3:0]key,
output reg [3:0]  key_buffer_ls_min,
                  key_buffer_ms_min,
                  key_buffer_ls_hr,
                  key_buffer_ms_hr );
  
  always@(posedge clk or posedge rst)
    begin
      if(rst) begin 
        key_buffer_ls_min<=0;
        key_buffer_ms_min<=0;
        key_buffer_ls_hr<=0;
        key_buffer_ms_hr<=0;
      end
      
      else if(shift ==1) begin
        key_buffer_ms_hr<=key_buffer_ls_hr; 
        key_buffer_ls_hr<=key_buffer_ms_min;
        key_buffer_ms_min<=key_buffer_ls_min;
        key_buffer_ls_min<=key;

    
      end
    end
endmodule