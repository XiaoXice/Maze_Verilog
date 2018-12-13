`define MEMORYSIZE 2
`include "Key44.v"
module Maze(
  input clk,
  input nst,
  input [3:0] key_row,
  output [3:0] key_col,
  output [7:0] led_row,
  output [7:0] led_r_col,
  output [7:0] led_g_col
);

tri [5:0] address;
tri commend;
tri [`MEMORYSIZE-1:0] data;

wire NVcommend;

wire [3:0] key_value;

Key44 Key441(
  .clk(clk),
  .reset(nst),
  .row(key_row),
  .col(key_col),
  .key_value(key_value)
);

commend commend1(
  .clk(clk),
  .key_value(key_value),
  .nst(nst),
  .address(address),
  .commend(commend),
  .NVcommend(NVcommend),
  .data(data)
);

// assign NVcommend = 1;

memory memory1(
  clk,
  address,
  commend,
  data
);

nvidia nvidia1(
  clk,
  nst,
  data,
  NVcommend,
  address,
  commend,
  led_row,
  led_r_col,
  led_g_col
);

endmodule // MAZE