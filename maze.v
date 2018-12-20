`define MEMORYSIZE 2
`include "Key44.v"
module Maze(
  input clk,
  input nst,
  input [3:0] key_row,
  output [3:0] key_col,
  output [7:0] led_row,
  output [7:0] led_r_col,
  output [7:0] led_g_col,
  output [7:0] LED_CAT,
  output [7:0] LED_NUM
);

tri [5:0] address;
tri commend;
tri [`MEMORYSIZE-1:0] data;

wire NVcommend,timecheckstop,timeout;

wire [3:0] key_value;

wire [7:0] number;

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
  .data(data),
  .timeout(timeout),
  .timecheckstop(timecheckstop)
);

// assign NVcommend = 1;

timechecker timechecker1(
  .clk(clk),
  .rst(nst),
  .stop(timecheckstop),
  .number(number),
  .timeout(timeout)
);

numberdriver numberdriver1(
  .clk(clk),
  .rst(nst),
  .number(number),
  .LED_CAT_out(LED_CAT),
  .LED_NUM(LED_NUM)
);

memory memory1(
  clk,
  nst,
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