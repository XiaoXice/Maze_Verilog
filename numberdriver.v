module numberdriver(
  input clk,
  input rst,
  input [7:0] number,
  output wire [7:0] LED_CAT_out,
  output reg [7:0] LED_NUM
);
reg [1:0] LED_CAT;
assign LED_CAT_out = {6'b111111,LED_CAT};
reg [7:0] number_list [10:0];
reg [5:0] count;
initial begin
  LED_CAT = 1'b01;
  LED_NUM = 9'h00;
  count = {6{1'b0}};
  number_list[0]= 8'b00111111; // 0
  number_list[1]= 8'b00000110; // 1
  number_list[2]= 8'b01011011; // 2
  number_list[3]= 8'b01001111; // 3
  number_list[4]= 8'b01100110; // 4
  number_list[5]= 8'b01101101; // 5
  number_list[6]= 8'b01111101; // 6
  number_list[7]= 8'b00100111; // 7
  number_list[8]= 8'b01111111; // 8
  number_list[9]= 8'b01100111; // 9
end

always @(posedge clk or posedge rst) begin
  if(rst) begin
    LED_CAT <= 1'b01;
    LED_NUM <= 8'h00;
    count <= {6{1'b0}};
  end
  else begin
    count <= count + 1;
    if(count == {6{1'b0}})begin
      case (LED_CAT)
        2'b10:begin
          LED_NUM <= number_list[number[7:4]];
          LED_CAT <= 2'b01;
        end
        2'b01:begin
          LED_NUM <= number_list[number[3:0]];
          LED_CAT <= 2'b10;
        end
        default: LED_NUM <= 8'h00;
      endcase
    end
    else if(count == {6{1'b1}})begin
      LED_NUM <= 8'h00;
    end

    // case (status)
    //   0:begin
    //     LED_NUM <= 8'h00;
    //   end
    //   1:begin
    //     LED_CAT <= 2'b10;
    //     LED_NUM <= number_list[number[3:0]];
    //   end
    //   3:begin
    //     LED_NUM <= 8'h00;
    //   end
    //   4:begin
    //     LED_CAT <= 2'b01;
    //     LED_NUM <= number_list[number[3:0]]
    //   end
    //   default: 
    // endcase
  end
end

endmodule // numberdrover