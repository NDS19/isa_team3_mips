#!/bin/bash
set -eou pipefail

sudo apt install python3

# installing required files, place pre-installed execution or install commands here

# basename /path/to/file.tar.gz .gz – Strip directory and suffix from filenames
#>&2 prints values to stderror

# This file should be executed from the root directory
# ./test_mips_cpu_bus.sh [cpu file directory] [instruction]
#   to test a single instruction
# ./test_mips_cpu_bus.sh [cpu file directory]
#   to test all instructions

# Things to do:
# 1. Replace templates with actual file names [tick]
# 2. Complete the test bench verilog file [tick]
# 3. Check if syntax is correct for this bash script file since DT's file uses
#     different syntax which doesn't work here (if statements)
#     UPDATE : if statements are actually the same apart from a ; at the end
#     of fi. Also other syntax differences turned out that we could actually use DT's
# 4. Adjust files to be able to handle the changes in directories

# Possible future improvements
# 1. The for loop going through each instruction test case could be summarised
#   into one for loop and have everything related to it in that single for loop
#   rather than have multiple for loops
#       This avoids having to call the same TESTNAME=$(basename ${i} .asm.txt) lines
#       at every loop
#

set +e # doesn't exit immediately if a command exits with a non-zero status
# DT's file uses 'set -eou pipefail'

# Capturing the input arguments in source_directory and instruction
# $1 and $2 are the input arguments
# $0 represents the command
if [ $# -eq 0 ] ; then
    echo "No arguments supplied"
exit
fi;

set -e

source_directory="$1" # represents the directory of the CPU
if [ $# -eq 2 ] ; then # if there are two input arguments
    echo " 2 arguments detected"
    instruction="$2" # represents the instruction we are testing
    # input should be lower-case
    TESTCASES="test/0-instructions_assembly/${instruction}_*.asm.txt"
    # TESTCASES holds all the test files for the current instruction
    # with the suffix .asm.txt e.g. addiu_1.asm.txt
    # The * selects all different test-cases of the instruction

    # Extracting the test-names from the testcases

    #for i in ${TESTCASES} ; do
        # Extract just the testcase name from the filename. See `man basename` for what this command does.
        # Removing the .asm.txt suffix
    #    TESTNAME=$(basename ${i} .asm.txt)
        #TESTNAME now just contains the test-case name e.g. addiu_1
    #done

    >&2 echo "Testing CPU : ${source_directory} with instruction : ${instruction}"
    # start assembly for testing a single instruction
    >&2 echo " 1 - Assembling test files for ${instruction}"
    # iterating through the test cases, i represents the file name e.g. addiu_1
    for i in ${TESTCASES} ; do
      TESTNAME=$(basename ${i} .asm.txt)
      # TESTNAME now doesn't have the .am.txt suffix
      echo test/0-instructions_assembly/${TESTNAME}.asm.txt | python3 Assembler/Assembler.py \
      > test/1-binary/${TESTNAME}.hex.txt
    done
    >&2 echo " Successfully assembled test files for ${instruction}"
    # instruction assembly files have now been compiled into their hex binary files

    >&2 echo " 2 - Compiling test-bench"
    # compile all components needed for the test-bench and forming an
    # executable file which runs the CPU with the instructions input into
    # RAM;
    for i in ${TESTCASES} ; do
      TESTNAME=$(basename ${i} .asm.txt)
      # -P is used to adjust the parameter in the testbench verilog so we can
      # input a file that is read in
      iverilog -g 2012 \
      ${source_directory}/mips_cpu_bus.v test/mips_cpu_bus_tb.v RAM_8x4096.v \
      Alu/ALU_all.v Alu/ALU.v Alu/Div.v Alu/MSB.v Alu/Mult.v Alu/Sign_Inverter.v Alu/Sign_Inverter64.v \
      datapath/*.v register_file.v Decoder.v \
      -s test/mips_cpu_bus_tb  \  # set the test-bench as top level since this instantiates everything
      -P test/mips_cpu_bus_tb.RAM_INIT_FILE=\"test/1-binary/${TESTNAME}.hex.txt\" \ # having the test case file input into the RAM
      -o test/2-simulator/CPU_MU0_bus_tb_${TESTNAME} # output executable file for this instruction testcase
    done
    # MAKE SURE TO ADJUST THIS BLOCK OF CODE FOR POSSIBLE CHANGES IN DIRECTORY
    >&2 echo " Successfully compiled test-bench"

    >&2 echo " 3 - Running the test-bench"
    # Running the executable cpu file we just made and capturing the output
    # display instructions to an output file
    # If we just use $display for the OUT instruction, we can output the value
    # at the destination register

    for i in ${TESTCASES} ; do
      TESTNAME=$(basename ${i} .asm.txt)
      set +e

      test/2-simulator/CPU_MU0_bus_tb_${TESTNAME} > test/3-output/CPU_MU0_bus_${TESTNAME}.stdout
      # output file would be called e.g. CPU_MUO_bus_addiu_1.stdout

      RESULT = $?
      set -e

      if [[ "${RESULT}" -ne 0 ]] ; then
        # fail condition
        # need to find a way to obtain the word 'instruction'
         echo "${TESTNAME} ${instruction} Fail"
         exit
      fi

      # we now need to extract the necessary lines with the prefix "RESULT : "
      # The associated value is then output and written into a .out file
      # so that we can compare it to the reference output result files
      >&2 echo " Extracting final results"
      PATTERN="RESULT : "
      NOTHING=""

      set +e
      # grep grabs the lines with the prefix described by PATTERN and outputs them to
      # a new file
      grep "${PATTERN}" test/3-output/CPU_MU0_bus_${TESTNAME}.stdout > \
      test/3-output/CPU_MU0_bus_${TESTNAME}.result-lines

      # Now we need to remove the "RESULT : " bit and maintain the correct value
      set -e
      sed -e "s/${PATTERN}/${NOTHING}/g" test/3-output/CPU_MU0_bus_${TESTNAME}.result-lines \
      > test/3-output/CPU_MU0_bus_${TESTNAME}.out
      # Actual final result of the test case is stored in a .out file
      # Note that the output of this will have spaces before the actual value but
      # this shouldn't have an effect when comparing to the reference files
    done

    >&2 echo " Successfully ran the test-bench"

    >&2 echo " 4 - Comparing to the reference output files"
    # Here we compare the generated output files from part 3 with the pre-generated
    # output files in 4-reference

    for i in ${TESTCASES} ; do
      TESTNAME=$(basename ${i} .asm.txt)
      set +e # +e used to stop the script failing if an error occurs
      diff -w test/4-reference/${TESTNAME}.out test/3-output/CPU_MU0_bus_${TESTNAME}.out
      RESULT=$? # output of this diff line stored in RESULT
      set -e

      # Based on whether differences were found, either pass or fail
      if [[ "${RESULT}" -ne 0 ]] ; then
        # fail condition
         echo "${TESTNAME} ${instruction} Fail"
      else
        # pass condition
         echo "${TESTNAME} ${instruction} Pass"
      fi
    done

elif [ $# -eq 1 ] ; then  # if nothing is specified for $2, all test-cases should be run
    >&2 echo "Testing CPU : ${source_directory} for all instructions"

    INSTRUCTIONS="test/0-instructions_assembly/*_1.asm.txt"
    # Holds every instruction with the prefix _1/asm.txt therefore holding every
    # instruction assuming every instruction is test
    for i in ${INSTRUCTIONS} ; do
        instruction=$(basename ${i} _1.asm.txt)
        # Removes the _1.asm.txt to just get the instruction name
        TESTCASES="test/0-instructions_assembly/${instruction}*.asm.txt"
        # TESTCASES holds all the test files for the current instruction
        # with the suffix .asm.txt; for the addiu instruction, it holds addiu_1,
        # addiu_2 and addiu_3
        # We need to remove the suffix at every loop where we access the TESTCASES

        # start assembly for testing for all instructions
        >&2 echo " 1 - Assembling test files for all instructions"
        # iterating through the test cases, i represents the file name e.g. addiu_1
        # here it is all test case file names
        for i in ${TESTCASES} ; do
            TESTNAME=$(basename ${i} .asm.txt)
            echo test/0-instructions_assembly/${TESTNAME}.asm.txt | python3 Assembler/Assembler.py \
            >test/1-binary/${TESTNAME}.hex.txt
        done
        >&2 echo " Successfully assembled test files"
        # instruction assembly files have now been compiled into their hex binary files

        >&2 echo " 2 - Compiling test-bench"
        # compile all components needed for the test-bench and forming an
        # executable file which runs the CPU with the instructions input into
        # RAM;
        for i in ${TESTCASES} ; do
            TESTNAME=$(basename ${i} .asm.txt)
            iverilog -g 2012 \
            ${source_directory}/mips_cpu_bus.v test/mips_cpu_bus_tb.v RAM_8x4096.v \
            Alu/ALU_all.v Alu/ALU.v Alu/Div.v Alu/MSB.v Alu/Mult.v Alu/Sign_Inverter.v Alu/Sign_Inverter64.v \
            datapath/*.v register_file.v Decoder.v\
            -s mips_cpu_bus_tb \ # set the test-bench as top level since this instantiates everything
            -P mips_cpu_bus_tb.RAM_INIT_FILE =\"test/1-binary/${TESTNAME}.hex.txt\" \ # having the test case file input into the RAM
            -o test/2-simulator/CPU_MU0_bus_tb_${TESTNAME} # output executable file for this instruction testcase
        done
        >&2 echo " Successfully compiled test-bench"

        >&2 echo " 3 - Running the test-bench"
        # Running the executable cpu file we just made and capturing the output
        # display instructions to an output file
        # If we just use $display for the OUT instruction, we can output the value
        # at the destination register

        for i in ${TESTCASES} ; do
            TESTNAME=$(basename ${i} .asm.txt)
            set +e

            test/2-simulator/CPU_MU0_bus_tb_${TESTNAME} > test/3-output/CPU_MU0_bus_${TESTNAME}.stdout
            # output file would be called e.g. CPU_MUO_bus_addiu_1.stdout
            # this contains the printed lines from running the testbench verilog,

            RESULT = $?
            set -e

            if [[ "${RESULT}" -ne 0 ]] ; then
              # fail condition
              # need to find a way to obtain the word 'instruction'
               echo "${TESTNAME} ${instruction} Fail"
               exit
            fi

            # we now need to extract the necessary lines with the prefix "RESULT : "
            # The associated value is then output and written into a .out file
            # so that we can compare it to the reference output result files
            >&2 echo " Extracting final results"
            PATTERN="RESULT : "
            NOTHING=""

            set +e
            grep "${PATTERN}" test/3-output/CPU_MU0_bus_${TESTNAME}.stdout > \
            test/3-output/CPU_MU0_bus_${TESTNAME}.result-lines

            # Now we need to remove the "RESULT : " bit and maintain the correct value
            set -e
            sed -e "s/${PATTERN}/${NOTHING}/g" test/3-output/CPU_MU0_bus_${TESTNAME}.out-lines \
            > test/3-output/CPU_MU0_bus_${TESTNAME}.out
            # Actual final result of the test case is stored in a .out file
            # Note that the output of this will have spaces before the actual value but
            # this shouldn't have an effect when comparing to the reference files
        done

        >&2 echo " Successfully ran the test-bench"

        >&2 echo " 4 - Comparing to the reference output files"
        # Here we compare the generated output files from part 3 with the pre-generated
        # output files in 4-reference

        for i in ${TESTCASES} ; do
            TESTNAME=$(basename ${i} .asm.txt)
            set +e # +e used to stop the script failing if an error occurs
            diff -w test/4-reference/${TESTNAME}.out test/3-output/CPU_MU0_bus_${TESTNAME}.out
            RESULT=$? # output of this diff line stored in RESULT
            set -e

            # need to capture the instruction name we are testing

            # Based on whether differences were found, either pass or fail
            if [[ "${RESULT}" -ne 0 ]] ; then
              # fail condition
               echo "${TESTNAME} ${instruction} Fail"
            else
              # pass condition
               echo "${TESTNAME} ${instruction} Pass"
            fi;
        done
    done
else
    echo "Incorrect number of parameters"
    exit
fi;

echo "  Testbench complete"
