module testMap(
  input clk,
  input rst,
  output reg command,
  output reg enable,
  output reg [5:0] address,
  output reg [`MEMORYSIZE-1:0] data
);

initial address = 0;
parameter TIME = 4;

reg [1:0] cnt;

always @(posedge clk or posedge rst) begin
  if(rst == 1)begin
    cnt <= {2{1'b0}};
  end
  else if(!enable)begin
    cnt <= cnt + 1'b1;
  end
end

always @(posedge clk or posedge rst) begin
  if(rst == 1)begin
    enable <= 1'b0;
  end
  if(!enable && address == 63)begin
    #4 enable <= 1'b1;
    #4 address <= 6'bzzzzzz;
    #4 data <= 2'bzz;
  end
  else if(!enable && cnt == 0)begin
    address <= address + 1'b1;
    case (address)
      0: data <= 2'b1;
      1: data <= 2'b1;
      2: data <= 2'b1;
      3: data <= 2'b1;
      4: data <= 2'b1;
      5: data <= 2'b1;
      6: data <= 2'b1;
      7: data <= 2'b1;
      8: data <= 2'b1;
      9: data <= 2'b1;
      10: data <= 2'b1;
      11: data <= 2'b1;
      12: data <= 2'b0;
      13: data <= 2'b0;
      14: data <= 2'b0;
      15: data <= 2'b1;
      16: data <= 2'b1;
      17: data <= 2'b0;
      18: data <= 2'b0;
      19: data <= 2'b0;
      20: data <= 2'b0;
      21: data <= 2'b1;
      22: data <= 2'b0;
      23: data <= 2'b1;
      24: data <= 2'b1;
      25: data <= 2'b0;
      26: data <= 2'b1;
      27: data <= 2'b0;
      28: data <= 2'b1;
      29: data <= 2'b1;
      30: data <= 2'b0;
      31: data <= 2'b1;
      32: data <= 2'b1;
      33: data <= 2'b0;
      34: data <= 2'b1;
      35: data <= 2'b0;
      36: data <= 2'b1;
      37: data <= 2'b0;
      38: data <= 2'b0;
      39: data <= 2'b1;
      40: data <= 2'b1;
      41: data <= 2'b0;
      42: data <= 2'b1;
      43: data <= 2'b0;
      44: data <= 2'b1;
      45: data <= 2'b0;
      46: data <= 2'b1;
      47: data <= 2'b1;
      48: data <= 2'b0;
      49: data <= 2'b0;
      50: data <= 2'b1;
      51: data <= 2'b1;
      52: data <= 2'b1;
      53: data <= 2'b0;
      54: data <= 2'b0;
      55: data <= 2'b0;
      56: data <= 2'b1;
      57: data <= 2'b1;
      58: data <= 2'b1;
      59: data <= 2'b1;
      60: data <= 2'b1;
      61: data <= 2'b1;
      62: data <= 2'b1;
      63: data <= 2'b1;
      default: data <= 2'bzz;
    endcase
  end
end

endmodule // testMap