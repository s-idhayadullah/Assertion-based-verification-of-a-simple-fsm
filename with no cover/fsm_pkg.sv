package fsm_pkg;

    typedef enum logic [2:0] {
        IDLE,
        ARBIT,
        ADDR,
        DATA,
        COMPLETE,
        ERROR_S,
        TIMEOUT_S
    } state_t;

endpackage
