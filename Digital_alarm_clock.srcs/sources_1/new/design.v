// Code your design here

//`include "alarm_register.sv"
//`include "alarm_controller_fsm.sv"
//`include "display_driver.sv"
//`include "key_register.sv"
//`include "key_register.sv"
//`include "lcd_driver_4.sv"
//`include "timing_gen.sv"


module alarm_clk_top(
	input clk,rst,time_button,alarm_button,fastwatch,
    input [3:0] key,
  output [7:0] ms_hr,ls_hr,ms_min,ls_min,
  output alarm_sound
  
);
  
  wire one_second,
  	   one_minute,
  	   load_new_c,
  	   load_new_a,
  	   show_current_time,
  	   show_a,
  	   shift,
  	   reset_count;
  
  wire [3:0] alarm_time_ms_hr,
   	 	 alarm_time_ls_hr,
     	 alarm_time_ms_min,
		 alarm_time_ls_min,
  		 current_time_ms_hr,
         current_time_ls_hr,
         current_time_ms_min,
         current_time_ls_min,
  		 key_buffer_ms_hr,
         key_buffer_ls_hr,
    	 key_buffer_ms_min,
    	 key_buffer_ls_min;
  
  
  
  timegen t1 (.clk(clk),
              .rst(rst),
              .fastwatch(fastwatch),
              .one_second(one_second),
              .one_minute(one_minute),
              .reset_count(reset_count));
  
  counter c1(.one_minute(one_minute),
             .clk(clk),
             .rst(rst),
             .new_current_time_ms_min(key_buffer_ms_min),
             .new_current_time_ls_min(key_buffer_ls_min),
             .new_current_time_ms_hr(key_buffer_ms_hr),
             .new_current_time_ls_hr(key_buffer_ls_hr),
             .load_new_c(load_new_c),
             .current_time_ms_min(current_time_ms_min),
             .current_time_ls_min(current_time_ls_min),
             .current_time_ms_hr(current_time_ms_hr),
             .current_time_ls_hr(current_time_ls_hr));
  
  alarm_register ar1 (.new_alarm_time_ms_hr(key_buffer_ms_hr),
                      .new_alarm_time_ls_hr(key_buffer_ls_hr),
                      .new_alarm_time_ms_min(key_buffer_ms_min),
                      .new_alarm_time_ls_min(key_buffer_ls_min),
                      .clk(clk),
                      .rst(rst),
                      .alarm_time_ms_hr(alarm_time_ms_hr),
                      .alarm_time_ls_hr(alarm_time_ls_hr),
                      .alarm_time_ms_min(alarm_time_ms_min),
                      .alarm_time_ls_min(alarm_time_ls_min));
  
  key_register  kr1(.rst(rst),
                    .clk(clk),
                    .shift(shift),
                    .key(key),
                    .key_buffer_ms_hr(key_buffer_ms_hr),
                    .key_buffer_ls_hr(key_buffer_ls_hr),
                    .key_buffer_ms_min(key_buffer_ms_min),
                    .key_buffer_ls_min(key_buffer_ls_min)
                    );
  
  
  
  alarm_controller fsm1(.rst(rst),
           .clk(clk),
           .shift(shift),
           .key(key),
           .show_a(show_a),
           .one_second(one_second),
           .time_button(time_button),
           .alarm_button(alarm_button),
           .reset_count(reset_count),
           .show_new_time(show_current_time),
           .load_new_c(load_new_c),
           .load_new_a(load_new_a));
  
   // LCD Driver
  lcd_driver_4 lcd_disp (
    .alarm_time_ms_hr(alarm_time_ms_hr),
    .alarm_time_ls_hr(alarm_time_ls_hr),
    .alarm_time_ms_min(alarm_time_ms_min),
    .alarm_time_ls_min(alarm_time_ls_min),
    .current_time_ms_hr(current_time_ms_hr),
    .current_time_ls_hr(current_time_ls_hr),
    .current_time_ms_min(current_time_ms_min),
    .current_time_ls_min(current_time_ls_min),
    .key_ms_hr(key_buffer_ms_hr),
    .key_ls_hr(key_buffer_ls_hr),
    .key_ms_min(key_buffer_ms_min),
    .key_ls_min(key_buffer_ls_min),
    .show_a(show_a),
    .show_current_time(show_current_time),
    .display_ms_hr(ms_hr),
    .display_ls_hr(ls_hr),
    .display_ms_min(ms_min),
    .display_ls_min(ls_min),
    .sound_a(alarm_sound)
  );

endmodule
