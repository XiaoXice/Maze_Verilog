module memory(
  input clk; // 50Mhz
  input [5:0] address;
  input command;
  inout [`MEMORYSIZE-1:0] data;
);

reg [63:0] mem [`MEMORYSIZE-1:0];

wire [`MEMORYSIZE-1:0] data_in;

assign data_in = data;

assign data = command ? mem[address] : {`MEMORYSIZE{1'bz}};

always @(posedge clk) begin
  if (command)
    mem[address] <= mem[address];
  else
    mem[address] <= data_in;
end

endmodule // memory