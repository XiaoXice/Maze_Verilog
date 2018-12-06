`timescale 1ns/10ps
`define MEMORYSIZE 2
module Maze_tb;

reg clk,nst;
wire [7:0] row, rcol, gcol;

Maze UUT(
    .clk(clk),
    .nst(nst),
    .led_row(row),
    .led_r_col(rcol),
    .led_g_col(gcol)
);

initial begin
    clk = 1;
    nst = 0;
    forever #1 clk = ~clk;
end


endmodule // 