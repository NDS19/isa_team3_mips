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

Test case structure

    Use test case names : {instruction}_{i}.asm.txt where i > 6
    Store in the folder test/0-instructions_assembly

    Loading values defined with .data onto registers
Creating the base from the reset address
ADDIU $t0, $zero, 49088
SLL $t0, $t0, 16

Loading the value in that address to a register
LW $a0, [(line number of .data1 - 1)x4]($t0)
  Load more data values onto another register if needed
LW $a1, [(line number of .data2 - 1)x4]($t0)

  $a0 now holds the 32-bit value of regS
  $a1 now holds the 32-bit value of regT

    Testing the instruction
This can be variable in size depending on the instructions:
  -Arithemetic instructions:
ADDU $V0, $a0, $a1
  The final value is stored in $V0 as desired

    -Jump instructions:
BEQ $a0, $a1, 8
ADDIU $V0, $zero, 1
ADDIU $V0, $zero, 100
ADDIU $V0, $zero, 10
  The final value should be 11 due to the addiu in the branch delay slot
  and the addiu from jumping 2 addresses (from the next instruction: PC + I + 4)

    - Other instructions may require unique testing like this

    Finishing the instruction sequence
JR $zero
ADDIU $t0, $t0, 0;
The ADDIU is just a useless instruction put into the delay slot of JR $zero
so that nothing happens

    Defining the data values
.data [value you want to input into regS]
.data [value you want to input into regT]
  These may not be needed, it depends on if you need stored 32-bit values or if
  you only need one or if you don't need either.

  Example test-case for LW

  ADDIU $t0, $zero, 49088
  SLL $t0, $t0, 16
  LW $V0, 20($t0)
  JR $zero
  ADDIU $t0, $zero, 1
  .data 20

    Storing the reference result
Create a file in test/4-reference called {instruction}_{i}.out with the output
from your test-case. This file just contains the int output value

Once the register v0 error has been fixed, run the testbench using
./test/test_mips_cpu_bus.sh rtl {instruction}
to test your sequence of instructions and verify that the cpu outputs the correct
value.
  If the test-case fails, it will say '{instruction}_${i} {instruction} Fail'.
Additionally, above it will have a < and >.
  - The value next to < represents the expected output which you wrote into the
  reference folder
  - The value next to the > represents the output of the cpu

Have fun :)
