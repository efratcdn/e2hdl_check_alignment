//
// checker.e
//
// using the smp.e, which defines an enum similar to the one defined in
// the sv monitor.
//
// for running with aligned monitor 
//       xrun monitor.sv checker.e -exit
// for running with misaligned monitor 
//       xrun monitor_ver_2.sv checker.e -exit

<'
import smp;

unit checker {
    !smp   : signal_map;
    !state : state_t;
    
    event clock is @smp.clock;
    
    event state_changed is change(smp.state_p$) @clock;
    on state_changed {
        state = smp.state_p$;
        message(LOW, "New state is ", state);
        
        if state == DATA {
            check that smp.valid_p$ == 1 else
              dut_error("in DATA phase valid must be 1");
        };
    };
};

unit env {
    checker is instance;
    signal_map is instance;
    
    connect_pointers() is also {
        checker.smp = signal_map;
    };
    
    keep hdl_path() == "monitor";
};

extend sys {
    env is instance;
    watchdog() @any is {
        wait [300] * cycle;
        stop_run();
    };
    run() is also {
        start watchdog();
    };
};


'>
