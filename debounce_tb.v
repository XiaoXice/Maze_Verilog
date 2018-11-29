// 按键消抖测试电路

// 时间单位
`timescale 1ns/10ps

// module
module  debounce_tb;

    // time period parameter
    localparam T = 20;

    // variable
    reg clk, nrst;
    reg key_in;
    wire key_out;

    // instantiate
    debounce uut(
        .clk    (clk    ),
        .nrst   (nrst   ),
        .key_in (key_in ),
        .key_out(key_out)
    );

    // clock
    initial begin
        clk = 1;
        forever #(T/2) clk = ~clk;
    end

    // reset
    initial begin
        nrst = 1;
        @(negedge clk) nrst = 0;
        @(negedge clk) nrst = 1;
    end

    // key_in
    initial begin
        // initial value
        key_in = 0;
        
        // wait reset
        repeat(3) @(negedge clk);
        
        // no bounce
        // key down
        key_in = 1;

        // last 60ms
        repeat(3000) @(negedge clk);

        // key up
        key_in = 0;

        // wait 50ms
        repeat(2500) @(negedge clk);

        // down 5ms, up 15ms
        // key down, bounce 5ms
        repeat(251) @(negedge clk) key_in = ~key_in;

        // last 60ms
        repeat(3000) @(negedge clk);

        // key up, bounce 15ms
        repeat(751) @(negedge clk) key_in = ~key_in;

        // wait 50ms
        repeat(2500) @(negedge clk);

        // down 19ms, up 19ms
        // key down, bounce 19ms
        repeat(951) @(negedge clk) key_in = ~key_in;

        // last 60ms
        repeat(3000) @(negedge clk);

        // key up, bounce 19ms
        repeat(951) @(negedge clk) key_in = ~key_in;

        // wait 50ms
        repeat(2500) @(negedge clk);
        
        // additional, this situation shoud not ever happen
        // down 25ms, up 25ms
        // key down, bounce 25ms
        repeat(1251) @(negedge clk) key_in = ~key_in;

        // last 60ms
        repeat(3000) @(negedge clk);

        // key up, bounce 25ms
        repeat(1251) @(negedge clk) key_in = ~key_in;

        // wait 50ms
        repeat(2500) @(negedge clk);

        // stop
        $stop;
    end
endmodule