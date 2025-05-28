// Code your design here
//timing generator

module timegen(
input clk,rst,reset_count,fastwatch,
output one_minute,one_second);
  
  reg[13:0]count;
  reg one_second;
  reg one_minute_reg;
  reg one_minute;
  
  // 1 min pulse gen
  always@(posedge clk or posedge rst) begin 
    
    if(rst ) 
      begin
      count<=14'd0;
      one_minute_reg<=0;
   	  end
    
    else if(reset_count)
      begin 
      count<=14'd0;
      one_minute_reg<=1'b0;
      
   	  end
    
    else if (count[13:0] == 14'd15359)//256*60
      begin 
        count<=14'b0;
        one_minute_reg<=1'b1;
      end
    else 
      begin
        count<=count+1'b1;
        one_minute_reg<=1'b0;
      end
  end 
  
  //1 sec pulse gen
  always@(posedge clk or posedge rst) 
    begin
      
      if(rst)
        one_second<=1'b0;
      
      else if (reset_count)
        one_second<=1'b0;
  
      else if (count[7:0]==8'd255)
        one_second<=1'b1;
      
      else 
        one_second <=1'b0;
     end
  
  
 //fastwatch mode 
  always@(*) 
    begin
    if(fastwatch)
      one_minute =one_second;
    else
      one_minute=one_minute_reg;
  	end
  
  
  endmodule