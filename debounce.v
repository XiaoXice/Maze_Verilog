module debounce(
    input wire clk, nrst,
    input wire [N-1:0] key_in,
    output reg [N-1:0] key_out
    );

//    localparam TIME_20MS = 1_000_000;
    localparam TIME_20MS = 1_000;       // just for test
    parameter N = 1; //要消除的按键的数量
    reg [N-1:0] key_cnt;
    reg [20:0] cnt;

    always @(posedge clk or negedge nrst) begin
        if(nrst == 0)
            key_cnt <= {N{0'b1}};
        else if(key_cnt == {N{0'b1}} && key_out != key_in)
            key_cnt <= key_in;
        else if(cnt == TIME_20MS - 1)
            key_cnt <= {N{0'b1}};
    end

    always @(posedge clk or negedge nrst) begin
        if(nrst == 0)
            cnt <= 0;
        else if(key_cnt > 0)
            cnt <= cnt + 1'b1;
        else
            cnt <= 0;
    end

    always @(posedge clk or negedge nrst) begin
        if(nrst == 0)
            key_out <= {N{0'b1}};
        else if(key_cnt == 0 && key_out != key_in)
            key_out <= key_in;
    end
endmodule