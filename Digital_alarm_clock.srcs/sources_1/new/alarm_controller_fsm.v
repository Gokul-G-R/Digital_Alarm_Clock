
// Code your design here
// alarm controller (FSM)
module alarm_controller(
input clk,rst,alarm_button,one_second,time_button,
  input [3:0]key ,
  output load_new_a,show_a,show_new_time,load_new_c,shift,reset_count );
  
  reg[2:0]ps,ns;
  wire time_out;
  
  reg [3:0] count1,count2;
  
  parameter SHOW_TIME=3'B000,
  			KEY_ENTRY=3'B001,
  			KEY_STORED=3'B010,
  			SHOW_ALARM=3'B011,
  			SET_ALARM_TIME=3'B100,
  			SET_CURRENT_TIME=3'B101,
  			KEY_WAITED=3'B110,
  			NOKEY=10;
  //counts 10s for key entry state  
  always@(posedge clk or posedge rst )begin 
    if(rst)
      count1<=4'd0;
    else if(!(ps==KEY_ENTRY))
      count1<=4'd0;
    else if (count1==9)
      count1<=4'd0;
    else if (one_second)
      count1<=count1+1'b1;
  end
  
  //counts 10s for key waited state 
  always@(posedge clk or posedge rst )begin 
    if(rst)
      count2<=4'd0;
    else if(!(ps==KEY_WAITED))
      count2<=4'd0;
    else if (count2==9)
      count2<=4'd0;
    else if (one_second)
      count2=count2+1'b1;
  end 
  
  assign time_out =((count1==9)|| (count2==9))?0:1;
  
  assign show_new_time = (ps==KEY_ENTRY || ps==KEY_STORED || ps==KEY_WAITED)?1:0;
  
  //ps logic
  always@(posedge clk or posedge rst )begin 
    if(rst)
      ps<=SHOW_TIME;
    else
      ps<=ns;
  end 
  
  // ns logic
  always@( ps or key or alarm_button or time_button or time_out)begin
    
    case(ps)
       
      SHOW_TIME: begin
        		if(alarm_button)
          			ns<=SHOW_ALARM;
        		else if (key!=NOKEY)
         			ns<=KEY_STORED;
        		else
          			ns<=SHOW_TIME;
      			end
  
      
      KEY_STORED:  ns<=KEY_WAITED;
      
   
      KEY_WAITED:begin
     			if(key == NOKEY)
       				ns=KEY_ENTRY;
     			else if(time_out ==0)
       				ns<=SHOW_TIME;
     			else
       				ns<=KEY_WAITED;
   				end
      
      
      KEY_ENTRY: begin
        		if(alarm_button)
          			ns<=SET_ALARM_TIME;
        		else if (time_button)
                    ns<=SET_CURRENT_TIME;
        		else if (time_out==0)
                    ns<=SHOW_TIME;
        else if(key!=NOKEY)
        			ns<=KEY_STORED;
      			else
                  ns<=KEY_ENTRY;
      			end
 
          
   	SHOW_ALARM : begin 
        		if(!alarm_button)
          			ns<=SHOW_TIME;
        		else
          			ns<=SHOW_ALARM;
      			end
      
      
    SET_ALARM_TIME: ns<=SHOW_TIME;
      
      
    SET_CURRENT_TIME: ns<=SHOW_TIME;
      
          default: ns <= SHOW_TIME;
    endcase
  end
          
          
  assign show_a = (ps==SHOW_ALARM)?1:0;
  assign load_new_a= (ps == SET_ALARM_TIME)?1:0;
  assign load_new_c= (ps == SET_CURRENT_TIME)?1:0;
  assign reset_count = (ps == SET_CURRENT_TIME)?1:0;
  assign shift = (ps == KEY_STORED)?1:0;
  
endmodule