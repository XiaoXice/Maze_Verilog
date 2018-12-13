`timescale 1ns/10ps
`define MEMORYSIZE 2
module Maze_tb;

reg clk,nst;
wire [7:0] row, rcol, gcol;

wire [3:0] key_col;

reg [3:0] key_row [15:0];

initial begin
  key_row[4'b0000] = 4'b1011;
  key_row[4'b1110] = 4'hf;
  key_row[4'b1101] = 4'b1011;
  key_row[4'b1011] = 4'hf;
  key_row[4'b0111] = 4'hf;
end

wire [3:0] key_row_in;

assign key_row_in = key_row[key_col];

Maze UUT(
    .clk(clk),
    .nst(nst),
    .key_row(key_row_in),
    .key_col(key_col),
    .led_row(row),
    .led_r_col(rcol),
    .led_g_col(gcol)
);

initial begin
    clk = 1;
    nst = 0;
    #2 nst = 1;
    #2 nst = 0;
    forever #1 clk = ~clk;
end


endmodule // 