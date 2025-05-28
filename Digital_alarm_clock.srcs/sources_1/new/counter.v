

module counter(
  input clk,rst,one_minute,load_new_c,
  input [3:0] new_current_time_ms_hr,
              new_current_time_ms_min,
              new_current_time_ls_hr,
              new_current_time_ls_min,
              
  output reg[3:0] current_time_ms_hr,
                  current_time_ms_min,
                  current_time_ls_hr,
                  current_time_ls_min
);
  
  always@(posedge clk or posedge rst)
    begin
      
      if(rst)
        begin
         current_time_ms_hr<=4'd0;
         current_time_ls_hr<=4'd0;
         current_time_ms_min<=4'd0;
         current_time_ls_min<=4'd0;
        end
      
      else if(load_new_c)
        begin
          current_time_ms_hr<=new_current_time_ms_hr; 				
          current_time_ls_hr<=new_current_time_ls_hr;
          current_time_ms_min<=new_current_time_ms_min;
          current_time_ls_min<=new_current_time_ls_min;
          
        end
      
      
      else if(one_minute == 1)
        begin
          
          //check corner cases
          //23:59---> 00:00
          
          if(current_time_ms_hr == 4'd2 && current_time_ms_min ==4'd5 && 
             current_time_ls_hr == 4'd3 && current_time_ls_min == 4'd9)
            begin 
              current_time_ms_hr<=4'd0;
         	  current_time_ls_hr<=4'd0;
         	  current_time_ms_min<=4'd0;
         	  current_time_ls_min<=4'd0;
            end
          
          //09:59-->10:00
          else if( current_time_ls_hr == 4'd9 && current_time_ms_min ==4'd5 && current_time_ls_min == 4'd9) 
            begin
              current_time_ms_hr<=current_time_ms_hr+1'd1;
         	  current_time_ls_hr<=4'd0;
         	  current_time_ms_min<=4'd0;
         	  current_time_ls_min<=4'd0;
            end
          
          //00: 59-->01:00
          else if (current_time_ms_min ==4'd5 && current_time_ls_min == 4'd9)
            begin
              current_time_ls_hr<=current_time_ls_hr+1'd1;
         	  current_time_ms_min<=4'd0;
         	  current_time_ls_min<=4'd0;
            end 
          
          //00:09-->00:10
          else if (current_time_ls_min == 4'd9)
            begin
            
         	  current_time_ms_min<=current_time_ms_min+1'd1;
         	  current_time_ls_min<=4'd0;
            end 
          
          //ls_min incrementing 
          else 
            begin 
              current_time_ls_min<=current_time_ls_min+1'b1;
            end 
        end
    end
endmodule