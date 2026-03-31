module tb();

    reg clk;
    reg rst_n;
    reg req;
    reg grant;
    reg addr_valid;
    reg data_ready;
    reg error;
    reg timeout;
    reg cancel;
    wire busy;
    wire done;
    wire err_flag;
    wire state;

    bus_controller_fsm fsm (.*);

    bind bus_controller_fsm properties m1(.*);

    initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

    initial begin
    // Initialize
    rst_n = 0;
    req = 0;
    grant = 0;
    addr_valid = 0;
    data_ready = 0;
    error = 0;
    timeout = 0;
    cancel = 0;

    #10 rst_n = 1;

    // -------------------------
    // 1. NORMAL FLOW
    // -------------------------
    #10 req = 1; #10 req = 0;
    #10 grant = 1; #10 grant = 0;
    #10 addr_valid = 1; #10 addr_valid = 0;
    #10 data_ready = 1; #10 data_ready = 0;

    // -------------------------
    // 2. ARBIT CANCEL
    // -------------------------
    #20 req = 1; #10 req = 0;
    #10 cancel = 1; #10 cancel = 0;

    // -------------------------
    // 3. ARBIT WAIT (no grant)
    // -------------------------
    #20 req = 1; #10 req = 0;
    #30; // stay in ARBIT

    // -------------------------
    // 4. ADDR HOLD
    // -------------------------
    #10 grant = 1; #10 grant = 0;
    #30; // addr_valid = 0

    // -------------------------
    // 5. DATA → ERROR
    // -------------------------
    #10 addr_valid = 1; #10 addr_valid = 0;
    #10 error = 1; #10 error = 0;

    // -------------------------
    // 6. DATA → TIMEOUT
    // -------------------------
    #20 req = 1; #10 req = 0;
    #10 grant = 1; #10 grant = 0;
    #10 addr_valid = 1; #10 addr_valid = 0;
    #10 timeout = 1; #10 timeout = 0;

    // -------------------------
    // 7. DATA WAIT (no signals)
    // -------------------------
    #20 req = 1; #10 req = 0;
    #10 grant = 1; #10 grant = 0;
    #10 addr_valid = 1; #10 addr_valid = 0;
    #30; // no data_ready/error/timeout

    // -------------------------
    // 8. DATA → COMPLETE again
    // -------------------------
    #10 data_ready = 1; #10 data_ready = 0;

    #50 $finish;
end

endmodule
