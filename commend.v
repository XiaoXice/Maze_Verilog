`define MEMORYSIZE 2
module commend(
  input clk,
  input nst,
  input [3:0] key_value,
  output reg [5:0] address,
  output reg commend,
  output reg NVcommend,
  inout [`MEMORYSIZE-1:0] data
);

wire [`MEMORYSIZE-1:0] data_in;

reg [`MEMORYSIZE-1:0] data_out;

assign data = ~commend ? data_out : {`MEMORYSIZE{1'bz}};
assign data_in = commend ? data : {`MEMORYSIZE{1'bz}};

reg [3:0] status;
reg [3:0] key_value_tmp;
reg [5:0] k;

reg [20:0] cnt;

reg [1:0] OtherStatus;

initial begin
  status = 0;
  address = {6{1'bz}};
  commend = 1'bz;
  NVcommend = 1'b1;
  OtherStatus = 0;
  k = 0;
  cnt = 0;
  key_value_tmp = 4'hz;
end

always @(posedge clk or posedge nst) begin
  if(nst)begin
    status <= 0;
    address <= {6{1'bz}};
    commend <= 1'bz;
    NVcommend <= 1'b1;
    OtherStatus <= 0;
    k <= 0;
    cnt <= 0;
    key_value_tmp <= 4'hz;
  end
  else
    case (status)
      0: begin
      if(!(key_value_tmp === key_value))
        case (key_value)
          7:begin
            key_value_tmp <= key_value;
            NVcommend <= 1'b0;
            address <= k;
            commend <= 1'b1;
            status <= 1;
          end
          5:begin
            key_value_tmp <= key_value;
            NVcommend <= 1'b0;
            address <= k;
            commend <= 1'b1;
            status <= 1;
          end
          2:begin
            key_value_tmp <= key_value;
            NVcommend <= 1'b0;
            address <= k;
            commend <= 1'b1;
            status <= 1;
          end
          10:begin
            key_value_tmp <= key_value;
            NVcommend <= 1'b0;
            address <= k;
            commend <= 1'b1;
            status <= 1;
          end
          default: begin
            key_value_tmp <= 4'hz;
            NVcommend <= 1'b1;
            address <= {6{1'bz}};
            commend <= 1'bz;
          end 
        endcase
      end
      1:begin
        if(data_in == 2)begin
          status <= 2;
        end
        else begin
          k <= k + 1;
          address <= k + 1;
        end
      end
      2:begin
        case (key_value_tmp)
          7:begin
            address[5:3] <= address[5:3] - 1'b1;
          end
          5:begin
            address[5:3] <= address[5:3] + 1'b1;
          end
          2:begin
            address[2:0] <= address[2:0] - 1'b1;
          end
          10:begin
            address[2:0] <= address[2:0] + 1'b1;
          end
          default: status <= 0;
        endcase
        status <= 3;
      end
      3:begin
        case (data_in)
          0:begin
            if(address[2:0] == 3'b111)begin
              status <= 6;
            end
            else begin
              commend <= 1'b0;
              data_out <= 2;
              status <= 4;
            end
          end
          1:begin
            status <= 0;
          end 
          default: status <= 0;
        endcase
      end
      4:begin
        address <= k;
        data_out  <= 0;
        status <= 5;
        k <= 0;
        OtherStatus <= 0;
      end
      5:begin
        status <= 0;
        address <= {6{1'bz}};
        commend <= 1'bz;
        NVcommend <= 1'b1;
        k <= 0;
        // key_value_tmp <= 4'hz;
      end
      6:begin
        cnt <= cnt + 1;
        if(cnt == 0)begin
          if(k == 0) OtherStatus <= OtherStatus + 1;
          if(OtherStatus == 2) status <= 7;
          address <= k;
          data_out <= 2;
          k <= k + 1;
          NVcommend <= 1'b0;
          commend <= 1'b0;
        end
        else begin
          commend <= 1'bz;
          address <= {6{1'bz}};
          NVcommend <= 1'b1;
        end
      end
      7: begin
        commend <= 1'bz;
        address <= {6{1'bz}};
        NVcommend <= 1'b1;
      end
      default: status <= 0;
    endcase
  // case (status)
  //   0: begin
  //     cnt <= cnt + 1;
  //     if(cnt == 0)begin
  //       address <= k;
  //       data_out <= OtherStatus + 1;
  //       k <= k + 1;
  //       OtherStatus <= OtherStatus + 1;
  //       NVcommend <= 1'b0;
  //       commend <= 1'b0;
  //     end
  //     else begin
  //       commend <= 1'bz;
  //       address <= {6{1'bz}};
  //       NVcommend <= 1'b1;
  //     end
  //   end
  //   default: begin
  //     status <= 0;
  //   end
  // endcase

end

endmodule // commend