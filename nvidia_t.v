`timescale 10ns/10ns
module nvidia_test ();

reg clk;
initial clk = 1'b0;
always clk = #1 ~clk;

reg rst,enable;
wire [1:0] data;
wire [5:0] address;
wire command;
wire [7:0] row,r_col,g_col;

initial begin
  rst = 1'b0;
  enable = 1'b1;
end
initial
begin
$dumpfile("nvidia_test.vcd");
$dumpvars(0, nvidia_test);
end
nvidia #(.TIME(10_000 / 8 / 4 / 8)) nvidia1(
  .clk(clk),
  .nrst(rst),
  .data(data),
  .enable(enable),
  .address(address),
  .command(command),
  .row(row),
  .r_col(r_col),
  .g_col(g_col)
);

memory memory1(
  .clk(clk),
  .rst(rst),
  .address(address),
  .command(command),
  .data(data)
);

initial begin
  #1000000 rst = 1'b1;
  #20 rst = 1'b0;
  #1000 enable = 1'b0;
  #1000000 $finish;
end

endmodule // nvidia_test