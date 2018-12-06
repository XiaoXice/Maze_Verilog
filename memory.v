`define MEMORYSIZE 2
module memory(
  input clk, // 50Mhz
  input [5:0] address,
  input command,
  inout [`MEMORYSIZE-1:0] data
);

reg [`MEMORYSIZE-1:0] mem [63:0];

initial begin
  mem[0] = 2'b1;
  mem[1] = 2'b1;
  mem[2] = 2'b1;
  mem[3] = 2'b1;
  mem[4] = 2'b1;
  mem[5] = 2'b1;
  mem[6] = 2'b1;
  mem[7] = 2'b1;
  mem[8] = 2'b1;
  mem[9] = 2'b1;
  mem[10] = 2'b1;
  mem[11] = 2'b1;
  mem[12] = 2'b0;
  mem[13] = 2'b0;
  mem[14] = 2'b0;
  mem[15] = 2'b1;
  mem[16] = 2'b1;
  mem[17] = 2'b0;
  mem[18] = 2'b0;
  mem[19] = 2'b0;
  mem[20] = 2'b0;
  mem[21] = 2'b1;
  mem[22] = 2'b0;
  mem[23] = 2'b1;
  mem[24] = 2'b1;
  mem[25] = 2'b0;
  mem[26] = 2'b1;
  mem[27] = 2'b0;
  mem[28] = 2'b1;
  mem[29] = 2'b1;
  mem[30] = 2'b0;
  mem[31] = 2'b1;
  mem[32] = 2'b1;
  mem[33] = 2'b0;
  mem[34] = 2'b1;
  mem[35] = 2'b0;
  mem[36] = 2'b1;
  mem[37] = 2'b0;
  mem[38] = 2'b0;
  mem[39] = 2'b1;
  mem[40] = 2'b1;
  mem[41] = 2'b0;
  mem[42] = 2'b1;
  mem[43] = 2'b0;
  mem[44] = 2'b1;
  mem[45] = 2'b0;
  mem[46] = 2'b1;
  mem[47] = 2'b1;
  mem[48] = 2'b0;
  mem[49] = 2'b0;
  mem[50] = 2'b1;
  mem[51] = 2'b1;
  mem[52] = 2'b1;
  mem[53] = 2'b0;
  mem[54] = 2'b0;
  mem[55] = 2'b0;
  mem[56] = 2'b1;
  mem[57] = 2'b1;
  mem[58] = 2'b1;
  mem[59] = 2'b1;
  mem[60] = 2'b1;
  mem[61] = 2'b1;
  mem[62] = 2'b1;
  mem[63] = 2'b1;
end

wire [`MEMORYSIZE-1:0] data_in;

assign data_in = ~command ? data : {`MEMORYSIZE{1'bz}};

// assign data = 2'b1;
assign data = command ? mem[address] : {`MEMORYSIZE{1'bz}};

always @(posedge clk) begin
  if (command)
    mem[address] <= mem[address];
  else
    mem[address] <= data_in;
end

endmodule // memory