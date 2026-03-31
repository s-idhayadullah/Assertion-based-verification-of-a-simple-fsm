import fsm_pkg::*;

module bus_controller_fsm (
    input  logic clk,
    input  logic rst_n,
    input  logic req,
    input  logic grant,
    input  logic addr_valid,
    input  logic data_ready,
    input  logic error,
    input  logic timeout,
    input  logic cancel,
    output logic busy,
    output logic done,
    output logic err_flag,
    output state_t state
);

/*   typedef enum logic [2:0] {
       IDLE,
       ARBIT,
       ADDR,
       DATA,
       COMPLETE,
       ERROR_S,
       TIMEOUT_S
   } state_t;          */

state_t next_state;

// State register
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        state <= IDLE;
    else
        state <= next_state;
end

// Next state logic
always_comb begin
    next_state = state;

    case (state)

        IDLE:
            if (req)
                next_state = ARBIT;

        ARBIT:
            if (cancel)
                next_state = IDLE;
            else if (grant)
                next_state = ADDR;

        ADDR:
            if (addr_valid)
                next_state = DATA;

        DATA:
            if (error)
                next_state = ERROR_S;
            else if (timeout)
                next_state = TIMEOUT_S;
            else if (data_ready)
                next_state = COMPLETE;

        COMPLETE:
            next_state = IDLE;

        ERROR_S:
            next_state = IDLE;

        TIMEOUT_S:
            next_state = IDLE;

    endcase
end

// Outputs
assign busy     = (state != IDLE);
assign done     = (state == COMPLETE);
assign err_flag = (state == ERROR_S);

endmodule
