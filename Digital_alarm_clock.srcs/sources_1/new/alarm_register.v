// Code your design here
//alarm register
module alarm_register (
  
  input rst,clk,load_new_alarm,
  
  input [3:0]new_alarm_time_ms_hr,
  			 new_alarm_time_ls_hr,
  			 new_alarm_time_ms_min,
  			 new_alarm_time_ls_min,
  
  output reg[3:0]alarm_time_ms_hr,
  				 alarm_time_ls_hr,
  				 alarm_time_ms_min,
        		 alarm_time_ls_min
);
  
  always@(posedge clk or posedge rst)
    begin 
      if (load_new_alarm)
       begin
         alarm_time_ms_hr<=new_alarm_time_ms_hr;
   	 	 alarm_time_ls_hr<=new_alarm_time_ls_hr;
     	 alarm_time_ms_min<=new_alarm_time_ms_min;
		 alarm_time_ls_min<=new_alarm_time_ls_min;
        end
      
      else 
        
       begin
     	 alarm_time_ms_hr<=4'd0;
   	 	 alarm_time_ls_hr<=4'd0;
     	 alarm_time_ms_min<=4'd0;
		 alarm_time_ls_min<=4'd0;
        end
    end  
  
  
endmodule 
  