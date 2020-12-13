0-input_instructions_assembly

This folder contains all of the test inputs for each instruction.

Each test input needs the suffix .asm.txt

Each file name is the lowercase MIPS name to allow the testbench script to
find the needed instruction test-cases without complications. Also requires
less computational power since the input in the command-line is a lower-case
instruction word

All test cases need to begin execution of the instruction at the reset address
and once we have finished the sequence of instructions, we jump to the 0th
address which signals the CPU to halt.
