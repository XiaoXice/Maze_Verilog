`timescale 10ns/10ns
module timechecker_test();

reg clk;
initial clk = 1'b0;
always clk = #1 ~clk;

initial
begin
$dumpfile("timechecker_test.vcd");
$dumpvars(0, timechecker_test);
end

reg rst,stop;

initial begin
  rst = 1'b0;
  stop = 1'b1;
end

wire [7:0] number;
wire timeout;

wire [7:0] LED_CAT;
wire [7:0] LED_NUM;

numberdriver numberdriver1(
  .clk(clk),
  .rst(rst),
  .number(number),
  .LED_CAT_out(LED_CAT),
  .LED_NUM(LED_NUM)
);

timechecker #(
  .OneSecClk(2500 - 1)
) timechecker1(
  .clk(clk),
  .rst(rst),
  .stop(stop),
  .number(number),
  .timeout(timeout)
);

initial begin
  #20 stop = 1'b0;
  wait(timeout == 1'b1)begin
    stop = 1'b1;
    #20 rst = 1'b1;
    #20 rst = 1'b0;
    #20 $finish;
  end
end




endmodule // timechecker_test