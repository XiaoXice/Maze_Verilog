`define MEMORYSIZE 2

module Maze(
  input clk,
  input nst,
  output [7:0] led_row,
  output [7:0] led_r_col,
  output [7:0] led_g_col
);

wire [5:0] address;
wire command;
wire [`MEMORYSIZE-1:0] data;

wire LED_enable;

memory memory1(
  clk,
  address,
  command,
  data
);

nvidia mvidia1(
  clk,
  nst,
  data,
  LED_enable,
  address,
  command,
  led_row,
  led_g_col,
  led_r_col
);

testMap testMap(
  clk,
  nst,
  command,
  LED_enable,
  address,
  data
);

endmodule // MAZE