This directory contains the testbenches and the executables used to directly
test individual components of the CPU.

The .v verilog files are treated as wrapper files where they instantiate the
component we are testing and artificially pass signals into that component.
The expected output value is then compared to the generated output from the
testbench.
