module Maze_test();

reg clk;
initial clk = 1'b0;
always clk = #1 ~clk;

initial
begin
$dumpfile("Maze_test.vcd");
$dumpvars(0, Maze_test);
end

tri [5:0] address;
tri commend;
tri [1:0] data;

reg timeout;
reg [3:0] key_value;

wire NVcommend,timecheckstop;

wire [7:0] number;

memory memory1(
  clk,
  nst,
  address,
  commend,
  data
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

initial begin
    timeout = 1'b0;
    key_value = 0;
    #300 key_value = 10;
    #300 key_value = 0;
    #300 key_value = 7;
    #300 key_value = 0;
    #300 key_value = 7;
    #300 key_value = 0;
    #300 key_value = 7;
    #300 key_value = 0;
    #300 key_value = 7;
    #300 key_value = 0;
    #300 key_value = 7;
    #300 key_value = 0;
    #300 key_value = 7;
    #300 key_value = 0;
    #300 timeout = 1'b1;
    #4000 $finish;
end

endmodule // Maze_test