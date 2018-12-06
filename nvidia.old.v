`define MEMORYSIZE 2
module nvidia(
  input clk, //50MHz
  input nrst,
  input [`MEMORYSIZE-1:0] data,
  input enable,
  output reg [5:0] address,
  output wire command,
  output reg [7:0] row,
  output reg [7:0] r_col,
  output reg [7:0] g_col
);

reg [7:0] row_tmp,r_col_tmp,g_col_tmp;

parameter TIME = 1_000_000 / 8 / 4 / 8; // 50Hz

reg [11:0] cnt;

reg [1:0] status;
reg [2:0] col_cnt;

initial begin
  row_tmp = 8'b11111110;
  address = 0;
  cnt = 0;
  status = 0;
  col_cnt = 0;
end

always @(posedge clk or posedge nrst) begin
  if(nrst == 1)
    cnt <= {20{1'b0}};
  else if(enable)
    cnt <= cnt + 1'b1;
  else if(cnt == TIME -1)
    cnt <= {20{1'b0}};
end

assign command = enable ? 1 : 1'bz;

// reg clk_50Hz;

// always @(posedge clk or posedge nrst) begin
//   if(cnt == 0)
//     clk_50Hz <= 1;
//   else
//     clk_50Hz <= 0;
// end


always @(posedge clk or posedge nrst) begin
  if(nrst == 1) begin
    row_tmp <= 8'b11111110;
    address <= 0;
    r_col_tmp <= {8{1'b0}};
    g_col_tmp <= {8{1'b0}};
  end
  else if(enable && cnt == 0) begin
    // if(status == 0) begin
    //   col_cnt <= col_cnt + 1'b1;
    //   address <= address + 1'b1;
    // end
    case (status)
    0:begin
      case (data)
        0:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b0;
        end
        1:begin
          r_col_tmp[col_cnt] = 1'b1;
          g_col_tmp[col_cnt] = 1'b0;
        end
        2:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b1;
        end
        3:begin
          r_col_tmp[col_cnt] = 1'b1;
          g_col_tmp[col_cnt] = 1'b1;
        end
        default:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b0;
        end
      endcase
      // status <= 1;
    end
    1: begin
      case (data)
        0:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b0;
        end
        1:begin
          r_col_tmp[col_cnt] = 1'b1;
          g_col_tmp[col_cnt] = 1'b0;
        end
        2:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b1;
        end
        3:begin
          r_col_tmp[col_cnt] = 1'b1;
          g_col_tmp[col_cnt] = 1'b1;
        end
        default:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b0;
        end
      endcase
      // status <= 2;
    end
    2: begin
      case (data)
        0:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b0;
        end
        1:begin
          r_col_tmp[col_cnt] = 1'b1;
          g_col_tmp[col_cnt] = 1'b0;
        end
        2:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b1;
        end
        3:begin
          r_col_tmp[col_cnt] = 1'b1;
          g_col_tmp[col_cnt] = 1'b1;
        end
        default:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b0;
        end
      endcase
      // status <= 3;
    end
    3: begin
      case (data)
        0:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b0;
        end
        1:begin
          r_col_tmp[col_cnt] = 1'b1;
          g_col_tmp[col_cnt] = 1'b0;
        end
        2:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b1;
        end
        3:begin
          r_col_tmp[col_cnt] = 1'b1;
          g_col_tmp[col_cnt] = 1'b1;
        end
        default:begin
          r_col_tmp[col_cnt] = 1'b0;
          g_col_tmp[col_cnt] = 1'b0;
        end
      endcase
      // status <= 0;
    end
    default: begin
      case (data)
        0:begin
          r_col_tmp[col_cnt] = 1'bz;
          g_col_tmp[col_cnt] = 1'bz;
        end
        1:begin
          r_col_tmp[col_cnt] = 1'bz;
          g_col_tmp[col_cnt] = 1'bz;
        end
        2:begin
          r_col_tmp[col_cnt] = 1'bz;
          g_col_tmp[col_cnt] = 1'bz;
        end
        3:begin
          r_col_tmp[col_cnt] = 1'bz;
          g_col_tmp[col_cnt] = 1'bz;
        end
        default:begin
          r_col_tmp[col_cnt] = 1'bz;
          g_col_tmp[col_cnt] = 1'bz;
        end
      endcase
      // status <= 0;
    end 
    endcase
    if(col_cnt == 7)begin
      row <= row_tmp;
      r_col <= r_col_tmp;
      g_col <= g_col_tmp;
      row_tmp = {row_tmp[6:0],row_tmp[7]};
      r_col_tmp <= {8{1'b0}};
      g_col_tmp <= {8{1'b0}};
      if(row_tmp == 8'b01111111)
        status <= status + 1;
    end
    col_cnt <= col_cnt + 1'b1;
    address <= address + 1'b1;
  end
end

endmodule // nvidia