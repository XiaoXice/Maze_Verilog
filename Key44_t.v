`timescale 10ns/10ns
module K44_test();

reg clk;
initial begin
  clk = 1'b0;
end
always clk = #1 ~clk;
initial
begin
$dumpfile("K44_test.vcd");
$dumpvars(0, K44_test);
end
reg rst;
reg [3:0] row;

initial begin
	rst = 1'b0;
	row = 4'b0000;
end

wire [3:0] col, key_value;

Key44 Key441(
	.clk(clk),
	.reset(rst),
	.row(row),
	.col(col),
	.key_value(key_value)
);

integer count, layout;

initial begin
	count = 0;
	layout = 0;
end


reg [3:0] last_col;

initial last_col = 4'h0;

always @(clk) begin
	case (col)
		4'b0000: row = 4'b1110;
		4'b1110: row = 4'b1111;
		4'b1101: row = 4'b1111;
		4'b1011: row = 4'b1111;
		4'b0111: begin row = 4'b1110; count = count + 1; end
		default: row = 4'b1111;
	endcase
	if(count == 3000) $finish;
end


endmodule // K44_test