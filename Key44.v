module key(
  input wire clk,reset; //50MHZ
  input wire [3:0] row; //行
  output reg [3:0] col; //列
  output reg [3:0] key_value; //键值
);
reg [5:0] count;  //delay_20ms
reg [2:0] state;  //状态标志
reg key_flag;   //按键标志位
reg clk_500khz;  //500KHZ时钟信号
reg [3:0] col_reg;  //寄存扫描列值
reg [3:0] row_reg;  //寄存扫描行值
always @(posedge clk or negedge reset)
  if(!reset) begin
    clk_500khz<=0;
    count<=0;
  end
  else begin
    if(count>=50) begin clk_500khz<=~clk_500khz;count<=0;end
    else count<=count+1;
  end
always @(posedge clk_500khz or negedge reset)
  if(!reset) begin col<=4'b0000;state<=0;end
  else begin
    case (state)
      0:begin
          col[3:0]<=4'b0000;
          key_flag<=1'b0;
          if(row[3:0]!=4'b1111) begin //有键按下，扫描第一行
            state<=1;
            col[3:0]<=4'b1110;
          end
          else state<=0;
        end
      1:begin  //判断是否是第一行
          if(row[3:0]!=4'b1111)
            state<=5;
          else begin
            state<=2;
            col[3:0]<=4'b1101;  //扫描第二行
          end
        end
      2:begin    //判断是否是第二行
          if(row[3:0]!=4'b1111)
            state<=5;
          else begin
            state<=3;
            col[3:0]<=4'b1011;  //扫描第三行
          end
        end
      3:begin    //判断是否是第三一行
          if(row[3:0]!=4'b1111)
            state<=5;
          else begin
            state<=4;  //扫描第四行
            col[3:0]<=4'b0111;
          end
        end
      4:begin //判断是否是第一行
          if(row[3:0]!=4'b1111)
            state<=5;
          else
            state<=0;
        end
      5:begin
          if(row[3:0]!=4'b1111) begin
              col_reg<=col;  //保存扫描列值
              row_reg<=row;  //保存扫描行值
              state<=5;
              key_flag<=1'b1;  //有键按下
            end
          else  state<=0;
        end
    endcase
  end
always @(clk_500khz or col_reg or row_reg) begin
  if(key_flag==1'b1)
    begin
      case ({col_reg,row_reg})
        8'b1110_1110:key_value<=0;
        8'b1110_1101:key_value<=1;
        8'b1110_1011:key_value<=2;
        8'b1110_0111:key_value<=3;
        8'b1101_1110:key_value<=4;
        8'b1101_1101:key_value<=5;
        8'b1101_1011:key_value<=6;
        8'b1101_0111:key_value<=7;
        8'b1011_1110:key_value<=8;
        8'b1011_1101:key_value<=9;
        8'b1011_1011:key_value<=10;
        8'b1011_0111:key_value<=11;
        8'b0111_1110:key_value<=12;
        8'b0111_1101:key_value<=13;
        8'b0111_1011:key_value<=14;
        8'b0111_0111:key_value<=15;
      endcase
    end
end
endmodule