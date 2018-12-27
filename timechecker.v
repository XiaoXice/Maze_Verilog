module timechecker(
  input clk,
  input rst,
  input stop,
  output reg [7:0] number,
  output wire timeout
);

parameter OneSecClk = 25_000_000 - 1;

reg [24:0] count;
reg clk_1HZ;

initial begin
  number = 8'h30;
  // timeout = 1'b0;
  count = {25{1'b0}};
  clk_1HZ = 1'b0;
end

always @(posedge clk or posedge rst) begin
  if(rst) begin
    
    // timeout <= 1'b0;
    count <= {25{1'b0}};
    clk_1HZ <= 1'b0;
  end
  else begin
    if(count == OneSecClk)begin
      count <= {25{1'b0}};
      clk_1HZ <= ~clk_1HZ;
    end
    else 
      count <= count + 1;
  end
end

always @(posedge clk_1HZ or posedge rst) begin
  if(rst) begin
    number <= 8'h30;
  end
  else if(!stop) begin
    if(number[3:0] == 0)begin
      number[7:4] <= number[7:4] - 1;
      number[3:0] <= 4'h9;
    end
    else begin
      number[3:0] <= number[3:0] - 1;
    end
  end
  else begin
    number <= number;
  end
end

assign timeout = number == 8'h00 ? 1'b1 : 1'b0;

// always @(posedge clk_1HZ) begin
//   if(number > 8'h30)begin
//     timeout <= 1'b1;
//   end
//   else begin
//     timeout <= 1'b0;
//   end
// end

endmodule // timechecker