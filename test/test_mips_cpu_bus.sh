#!/bin/bash

# this file should be in the test folder so take inputs relative to this
# however, the spec says to make executions from the root directory

# Things to do:
# 1. Replace templates with actual file names
# 2. Complete the test bench verilog file
# 3. Make the OUT instruction and test how it operates with general test cases
# 4. 

# Possible future improvements
# 1. The for loop going through each instruction test case could be summarised
#   into one for loop and have everything related to it in that single for loop
#   rather than have multiple for loops

set -e #exit immediately if a command exits with a non-zero status
# DT's file uses 'set -eou pipefail'

# Capturing the input arguments in source_directory and instruction
# $1 and $2 are the input arguments
if [$# -eq 0]
    then
        echo "No arguments supplied"
        exit
fi

source_directory = "$1" # represents the directory of the CPU
if [$# -eq 2] # if there are two input arguments
    then
      instruction = "$2" # represents the instruction we are testing
      # input should be lower-case
      TESTCASES = "test/0-instructions_assembly/${instruction}_*.asm.txt"
      # TESTCASES holds all the test files for the current instruction
      # with the suffix .asm.txt
      # The * selects all different test-cases of the instruction

      >%2 echo "Testing CPU : ${source_directory} with instruction : ${instruction}"
      # start assembly for testing a single instruction
      >&2 echo " 1 - Assembling test files for ${instruction}"
      # iterating through the test cases, i represents the file name e.g. addiu_1
      for i in ${TESTCASES} ; do
          [assembler executable file] <test/0-instructions_assembly/${i}.asm.txt \
          >test/1-binary/${i}.hex.txt
      done
      >&2 echo " Successfully assembled test files for ${instruction}"
      # instruction assembly files have now been compiled into their hex binary files

      >&2 echo " 2 - Compiling test-bench"
      # compile all components needed for the test-bench and forming an
      # executable file which runs the CPU with the instructions input into
      # RAM;
      for i in ${TESTCASES} ; do
          iverilog -g 2012 \
          [cpu file.v] [cpu file tb.v] [ram.v] [any components we have separate] \
          -s [cpu file tb.v] # set the test-bench as top level since this instantiates everything
          -P [cpu file tb.v].[ram file] =\"test/1-binary/${i}.hex.txt\" # having the test case file input into the RAM
          -o test/2-simulator/CPU_MU0_bus_tb_${i} # output executable file for this instruction testcase
      done
      >&2 echo " Successfully compiled test-bench"

      >&2 echo " 3 - Running the test-bench"
      # Running the executable cpu file we just made and capturing the output
      # display instructions to an output file
      # If we just use $display for the OUT instruction, we can output the value
      # at the destination register

      test/2-simulator/CPU_MU0_bus_tb_${i} > test/3-output/CPU_MU0_bus_${i}.stdout
      # output file would be called e.g. CPU_MUO_bus_addiu_1.stdout

      >&2 echo " Successfully ran the test-bench"

      >&2 echo " 4 - Comparing to the reference output files"
      # Here we compare the generated output files from part 3 with the pre-generated
      # output files in 4-reference

      set +e # +e used to stop the script failing if an error occurs
      diff -w test/4-reference/${i}.out test/3-output/CPU_MU0_bus_${i}.out
      RESULT=$? # output of this diff line stored in RESULT
      set -e

      # Based on whether differences were found, either pass or fail
      if [[ "${RESULT}" -ne 0 ]] ; then
         echo "  ${instruction}, ${i}, FAIL"
      else
         echo "  ${instruction}, ${i}, pass"
      fi

    else # if nothing is specified for $2, all test-cases should be run
      >%2 echo "Testing CPU : ${source_directory} for all instructions"

      TESTCASES = "test/0-instructions_assembly/*.asm.txt"
      # TESTCASES holds all the test files for the current instruction
      # with the suffix .asm.txt

      # start assembly for testing for all instructions
      >&2 echo " 1 - Assembling test files for all instructions"
      # iterating through the test cases, i represents the file name e.g. addiu_1
      # here it is all test case file names
      for i in ${TESTCASES} ; do
          [assembler executable file] <test/0-instructions_assembly/${i}.asm.txt \
          >test/1-binary/${i}.hex.txt
      done
      >&2 echo " Successfully assembled test files"
      # instruction assembly files have now been compiled into their hex binary files

      >&2 echo " 2 - Compiling test-bench"
      # compile all components needed for the test-bench and forming an
      # executable file which runs the CPU with the instructions input into
      # RAM;
      for i in ${TESTCASES} ; do
          iverilog -g 2012 \
          [cpu file.v] [cpu file tb.v] [ram.v] [any components we have separate] \
          -s [cpu file tb.v] # set the test-bench as top level since this instantiates everything
          -P [cpu file tb.v].[ram file] =\"test/1-binary/${i}.hex.txt\" # having the test case file input into the RAM
          -o test/2-simulator/CPU_MU0_bus_tb_${i} # output executable file for this instruction testcase
      done
      >&2 echo " Successfully compiled test-bench"

      >&2 echo " 3 - Running the test-bench"
      # Running the executable cpu file we just made and capturing the output
      # display instructions to an output file
      # If we just use $display for the OUT instruction, we can output the value
      # at the destination register

      test/2-simulator/CPU_MU0_bus_tb_${i} > test/3-output/CPU_MU0_bus_${i}.stdout
      # output file would be called e.g. CPU_MUO_bus_addiu_1.stdout

      >&2 echo " Successfully ran the test-bench"

      >&2 echo " 4 - Comparing to the reference output files"
      # Here we compare the generated output files from part 3 with the pre-generated
      # output files in 4-reference

      set +e # +e used to stop the script failing if an error occurs
      diff -w test/4-reference/${i}.out test/3-output/CPU_MU0_bus_${i}.out
      RESULT=$? # output of this diff line stored in RESULT
      set -e

      # Based on whether differences were found, either pass or fail
      if [[ "${RESULT}" -ne 0 ]] ; then
         echo "  ${instruction}, ${i}, FAIL"
      else
         echo "  ${instruction}, ${i}, pass"
      fi
fi
