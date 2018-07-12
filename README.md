# e2hdl_check_alignment
Bottom line:
   
   Run this:

     xrun -snprecom "set e2hdl checks" monitor_ver_2.sv checker.e -exit

* Title : e2hdl compatibility check 
* Version : 1.0
* Requires : Specman {17.04..}
* Modified : July 2018
* Description :

[ More e code examples in https://github.com/efratcdn/spmn-e-utils ]


This example demonstrates how to check compatibility of SV and e enumeration 
types.



The small env consists of monitor.sv and checker.e. Both define a similar 
enum, indicating the transfer state.

sv:
 typedef enum   {IDLE, ARBI, ADDRESS, DATA} state_t;

e:
 type state_t : [IDLE, ARBI, ADDRESS, DATA];


Running the example:

   xrun monitor.sv checker.e -exit


Assume someone modified the sv code and added a state. If this someone forgot 
to update the checker owner, the two enums have different values:

sv:
 typedef enum   {IDLE, ARBI, PREAMBLE, ADDRESS, DATA} state_t;

e:
 type state_t : [IDLE, ARBI, ADDRESS, DATA];


Running this example:
   
   xrun monitor_ver_2.sv checker.e -exit


This run fails with a DUT error. The source of the error is that the checker 
thinks we are in DATA state (DATA == 3, in the e enum), but in the SV the 
state is ADDRESS (ADDRESS == 3, in the SV enum).

Actually, we are lucky here. A DUT error is reported, and after a debugging 
session. - hopefully someone will realize the cause of this bug, and will 
modify the e enum. It can be worse - we might not get an immediate DUT error,
and the testbench will continue executing not realizing of this misalignment.


To avoid such cases, you can use the e2hdlcheck. 


  xrun -snprecom "set e2hdl checks" monitor_ver_2.sv checker.e -exit


No need to run it every time, just every once in a while. e.g. - when checking
in a modified file.
