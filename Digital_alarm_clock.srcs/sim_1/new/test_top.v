`timescale 1ns/1ps

module tb_alarm_clk_top;

  reg clk, rst, fastwatch, time_button, alarm_button;
  reg [3:0] key;
  wire [7:0] display_ms_hr, display_ls_hr, display_ms_min, display_ls_min;
  wire sound_alarm;

  alarm_clk_top DUT (
    .clk(clk),
    .rst(rst),
    .fastwatch(fastwatch),
    .time_button(time_button),
    .alarm_button(alarm_button),
    .key(key),
    .ms_hr(display_ms_hr),
    .ls_hr(display_ls_hr),
    .ms_min(display_ms_min),
    .ls_min(display_ls_min),
    .alarm_sound(sound_alarm)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    rst = 1;
    fastwatch = 0;
    time_button = 0;
    alarm_button = 0;
    key = 4'd10;

    #20;
    rst = 0;

    fastwatch = 1;

    #10 key = 4'd1;
    #10 key = 4'd2;
    #10 key = 4'd3;
    #10 key = 4'd4;
    #10 key = 4'd10;

    #10 time_button = 1;
    #10 time_button = 0;

    #50 key = 4'd1;
    #10 key = 4'd2;
    #10 key = 4'd3;
    #10 key = 4'd4;
    #10 key = 4'd10;

    #10 alarm_button = 1;
    #10 alarm_button = 0;

    #200;

    $finish;
  end

endmodule
