module commend(
  input clk,
  input nst,
  input [3:0] key_value,
  output reg [5:0] address,
  output reg commend,
  output reg NVcommend,
  inout [`MEMORYSIZE-1:0] data
);

wire data_in;

reg data_out;

assign data = ~commend ? data_out : {`MEMORYSIZE{1'bz}};
assign data_in = commend ? data : {`MEMORYSIZE{1'bz}};

reg [2:0] status;

reg [5:0] k;

reg [5:0] cnt;

reg [1:0] OtherStatus;

initial begin
  status = 0;
  address = 0;
  commend = 1;
  NVcommend = 0;
  OtherStatus = 0;
  k = 0;
  cnt = 0;
end

always @(posedge clk or posedge nst) begin
  if(nst)begin
    status <= 0;
    address <= 0;
    commend <= 1;
    NVcommend <= 0;
    OtherStatus <= 0;
    k <= 0;
    cnt <= 0;
  end
  else
  case (status)
    0: begin
      cnt <= cnt + 1;
      if(cnt == 0)begin
        address <= k;
        data_out <= OtherStatus + 1;
        k <= k + 1;
        OtherStatus <= OtherStatus + 1;
        NVcommend <= 1'bz;
        commend <= 1'b1;
      end
      else begin
        commend <= 1'bz;
        address <= {6{1'bz}};
        NVcommend <= 1'b1;
      end
    end
    default: begin
      status <= 0;
    end
  endcase
end

endmodule // commend