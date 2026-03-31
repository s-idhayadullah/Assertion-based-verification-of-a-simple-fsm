import fsm_pkg::*;

module properties (
    input logic clk,
    input logic rst_n,
    input logic req,
    input logic grant,
    input logic addr_valid,
    input logic data_ready,
    input logic error,
    input logic timeout,
    input logic cancel,
    input logic busy,
    input logic done,
    input logic err_flag,
    input state_t state
);

/*    typedef enum logic [2:0] {
        IDLE,
        ARBIT,
        ADDR,
        DATA,
        COMPLETE,
        ERROR_S,
        TIMEOUT_S
    } state_t;            */

    // state_t state;

   default disable iff(!rst_n);

   default clocking defclk @(posedge clk);
   endclocking

   property p1;
       ((state == IDLE) && req) |=> (state == ARBIT);
   endproperty

   property p01;
       ((state == IDLE) && !req) |=> (state == IDLE);
   endproperty

   property p2;
       ((state == ARBIT) && cancel) |=> (state == IDLE);
   endproperty

   property p3;
       ((state == ARBIT) && !cancel && grant) |=> (state == ADDR);
   endproperty

   property p03;
       ((state == ARBIT) && !cancel && !grant) |=> (state == ARBIT);
   endproperty

   property p4;
       ((state == ADDR) && addr_valid) |=> (state == DATA);
   endproperty

   property p04;
       ((state == ADDR) && ~addr_valid) |=> (state == ADDR);
   endproperty

   property p5;
       ((state == DATA) && error) |=> (state == ERROR_S);
   endproperty

   property p6;
       ((state == DATA) && !error && timeout) |=> (state == TIMEOUT_S);
   endproperty

   property p7;
       ((state == DATA) && !error && !timeout && data_ready) |=> (state == COMPLETE);
   endproperty

   property p07;
       ((state == DATA) && !error && !timeout && !data_ready) |=> (state == DATA);
   endproperty

   property p8;
       (state == COMPLETE) |=> (state == IDLE);
   endproperty

   property p9;
       (state == ERROR_S) |=> (state == IDLE);
   endproperty

   property p10;
       (state == TIMEOUT_S) |=> (state == IDLE);
   endproperty


   //output check

   property po1;
       (state != IDLE) |-> busy;
   endproperty

   property po2;
       (state == COMPLETE) |-> done;
   endproperty

   property po3;
       (state == ERROR_S) |-> err_flag;
   endproperty

  /* property po4;
       busy |=> (state != IDLE);
   endproperty

   property po5;
       done |-> (state == COMPLETE);
   endproperty

   property po6;
       err_flag |=> (state == ERROR_S);
   endproperty */



   A1 : assert property (p1);
   A01 : assert property (p01);
   A2 : assert property (p2);
   A3 : assert property (p3);
   A03 : assert property (p03);
   A4 : assert property (p4);
   A04 : assert property (p04);
   A5 : assert property (p5);
   A6 : assert property (p6);
   A7 : assert property (p7); 
   A07 : assert property (p07);
   A8 : assert property (p8);
   A9 : assert property (p9);
   A10 : assert property (p10);

   Ao1 : assert property (po1);
   Ao2 : assert property (po2);
   Ao3 : assert property (po3);
   //Ao4 : assert property (po4);
   //Ao5 : assert property (po5);
   //Ao6 : assert property (po6);

   S1 : assume property ( !(grant & cancel));
  
endmodule
