
#Description
This example shows how to create an input and data store channel on the 
Arty A7 using the BTN0 and BTN1 buttons. In this example “nibbles” can 
be loaded into two registers. For reliable data entry, it is necessary 
to suppress button bouncing and synchronize the input. This is achieved 
with the modules btn_debouncer.v and synchro-register-module.v. The 
data load to one or the other register is selected by means of the 
switch SW0. The registers can be reset using the BTN2  button. For the 
elimination of the rebounds, a transient regime of 2 ms has been 
assumed until the signal stabilizes. The btn_debouncer.v module is 
designed to calculate the slow_clk signal for the flip-flops to filter 
out the noise from the bounces. However (for now) for the synthesis and 
implementation it is necessary to previously set the values of COUNT_BIT 
and SEMI_PERIOD for the specific value of T_TRANS.
