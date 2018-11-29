module nvidia(
  input clk, //50MHz
  input nrst,
  input [`MEMORYSIZE-1:0] data,
  input enable,
  output [5:0] address,
  output command,
  output reg [7:0] row,
  output reg [7:0] r_col,
  output reg [7:0] g_col
);

parameter TIME = 1_000_000 / 8 / 4 / 8; // 50Hz

reg [11:0] cnt;

reg [1:0] status;
reg [2:0] col_cnt;

initial row = 8'b11111110;

always @(posedge clk or posedge nrst) begin
  if(nrst == 1)
    cnt <= {20{1'b0}};
  else if(enable)
    cnt <= cnt + 1'b1;
  else if(cnt == TIME -1)
    cnt <= {20{1'b0}}
end

always @(posedge clk or posedge nrst) begin
  if(nrst == 1) begin
    row <= {7{1'b0}};
    r_col <= {7{1'b0}};
    g_col <= {7{1'b0}};
  end
  else if(enable && status == 0) begin
    col_cnt <= col_cnt + 1'b1;
    address <= address + 1'b1;
  end
  else if(enable && col_cnt == 7) begin
    r_col <= {r_col[6:0],r_col[7]};
  end
  else if(enable && cnt == 0) begin
    case (status)
      0:begin
        case (data)
          0:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
          1:begin
            r_col[col_cnt] <= 1'b1;
            g_col[col_cnt] <= 1'b0;
          end
          2:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b1;
          end
          3:begin
            r_col[col_cnt] <= 1'b1;
            g_col[col_cnt] <= 1'b0;
          end
          default:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
        endcase
        status <= 1;
      end
      1: begin
        case (data)
          0:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
          1:begin
            r_col[col_cnt] <= 1'b1;
            g_col[col_cnt] <= 1'b0;
          end
          2:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b1;
          end
          3:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b1;
          end
          default:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
        endcase
        status <= 2;
      end
      2: begin
        case (data)
          0:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
          1:begin
            r_col[col_cnt] <= 1'b1;
            g_col[col_cnt] <= 1'b0;
          end
          2:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b1;
          end
          3:begin
            r_col[col_cnt] <= 1'b1;
            g_col[col_cnt] <= 1'b0;
          end
          default:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
        endcase
        status <= 3;
      end
      3: begin
        case (data)
          0:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
          1:begin
            r_col[col_cnt] <= 1'b1;
            g_col[col_cnt] <= 1'b0;
          end
          2:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b1;
          end
          3:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b1;
          end
          default:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
        endcase
        status <= 0;
      end
      default: begin
        case (data)
          0:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
          1:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
          2:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
          3:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
          default:begin
            r_col[col_cnt] <= 1'b0;
            g_col[col_cnt] <= 1'b0;
          end
        endcase
        status <= 0;
      end 
    endcase
  end
end

endmodule // nvidia