`define MEMORYSIZE 2
module commend(
  input clk,
  input nst,
  input [3:0] key_value,
  output reg [5:0] address,
  input wire timeout,
  output reg commend,
  output reg timecheckstop,
  output reg NVcommend,
  inout [`MEMORYSIZE-1:0] data
);

wire [`MEMORYSIZE-1:0] data_in;

reg [`MEMORYSIZE-1:0] data_out;

assign data = ~commend ? data_out : {`MEMORYSIZE{1'bz}};
assign data_in = commend ? data : {`MEMORYSIZE{1'bz}};

reg [4:0] status;
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
  timecheckstop = 1'b1;
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
    timecheckstop <= 1'b1;
  end
  else if(timeout)begin
    timecheckstop <= 1'b1;
    cnt <= cnt + 1;
    if(cnt == 0)begin
      if(k == 0) OtherStatus <= OtherStatus + 1;
      if(OtherStatus == 2) begin
        commend <= 1'bz;
        address <= {6{1'bz}};
        NVcommend <= 1'b1;
      end
      else begin
        address <= k;
        data_out <= 1;
        k <= k + 1;
        NVcommend <= 1'b0;
        commend <= 1'b0;
      end
    end
    else begin
      commend <= 1'bz;
      address <= {6{1'bz}};
      NVcommend <= 1'b1;
    end
  end
  else
    case (status)
      0: begin // 等待键盘
      if(!(key_value_tmp === key_value))begin
        timecheckstop <= 1'b0;
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
      end
      1:begin // 找人
        if(data_in == 2)begin
          status <= 2;
        end
        else begin
          k <= k + 1;
          address <= k + 1;
        end
      end
      2:begin //看墙
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
      3:begin //撞墙
        case (data_in)
          0:begin
            if(address[2:0] == 3'b111)begin
              timecheckstop <= 1'b1;
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
      4:begin // 走
        address <= k;
        data_out  <= 0;
        status <= 5;
        k <= 0;
        OtherStatus <= 0;
      end
      5:begin //恢复
        status <= 0;
        address <= {6{1'bz}};
        commend <= 1'bz;
        NVcommend <= 1'b1;
        k <= 0;
        // key_value_tmp <= 4'hz;
      end
      6:begin //赢了
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
      7: begin //结束
        commend <= 1'bz;
        address <= {6{1'bz}};
        NVcommend <= 1'b1;
      end
      default: status <= 0;
    endcase
end

endmodule // commend