  test_mips_cpu_bus.sh
This script runs the test bench on instructions depending on the input parameters.

THIS NEEDS TO BE RUN FROM THE MAIN DIRECTORY therefore execution begins with
./test/test_mips_cpu_bus.sh

For the following:
<source_directory> represents the DIRECTORY (not file name) of the main cpu file
<instruction> is the lower-case instruction name we want to test

To test all of the instructions:
./test/test_mips_cpu_bus.sh <source_directory>

To test a single instruction:
./test/test_mips_cpu_bus.sh <source_directory> <instruction>
