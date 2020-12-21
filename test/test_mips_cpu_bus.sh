#!/bin/bash
set -eou pipefail

# sudo apt install python3

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
# 5. Move testing all instructions into one for loop [tick]
# 6. Recover early exit code in section 3 when the CPU is fully functional
# 7. Adjust directory and script to compile every verilog file in the mips_cpu
#     folder [tick]
# 8. Send relative outputs from running the script to stderr rather than stdout
#     This means things like the output of diff [tick]
# 9. Might need a stderr output on the compile line (update based on the Friday sanity check) [not needed]
# 10. Ensure all instructions have a test case with the _0 suffix [tick]
# 11. Fix unsigned output for the link instructions [tick]
# 12. Fix test-case output for when the instruction == and, repeatedely outputting
#   andi_0 and Pass etc. [tick]

# Possible future improvements
# 1. The for loop going through each instruction test case could be summarised
#   into one for loop and have everything related to it in that single for loop
#   rather than have multiple for loops
#       This avoids having to call the same TESTNAME=$(basename ${i} .asm.txt) lines
#       at every loop [tick]
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

    >&2 echo "Testing CPU from : ${source_directory} with instruction : ${instruction}"

    for i in ${TESTCASES} ; do
    # iterating through the test cases, i represents the file name e.g. addiu_1
        TESTNAME=$(basename ${i} .asm.txt)
        # removing the .asm.txt suffix and directory prefix
        # start assembly for testing a single instruction
        >&2 echo " 1 - Assembling test files for ${TESTNAME}"
        echo test/0-instructions_assembly/${TESTNAME}.asm.txt | python3 test/Assembler/Assembler.py \
        > test/1-hex/${TESTNAME}.hex.txt
        #>&2 echo " Successfully assembled test files for ${instruction}"
        # instruction assembly files have now been compiled into their hex binary files

        >&2 echo " 2 - Compiling test-bench for ${TESTNAME}"
        # compile all components needed for the test-bench and forming an
        # executable file which runs the CPU with the instructions input into
        # RAM;

        # -P is used to adjust the parameter in the testbench verilog so we can
        # input a file that is read in
        iverilog -g 2012 \
        ${source_directory}/mips_cpu_*.v test/mips_cpu_bus_tb.v test/RAM_8x4096.v \
        ${source_directory}/mips_cpu/*.v \
        -s mips_cpu_bus_tb \
        -P mips_cpu_bus_tb.RAM_INIT_FILE=\"test/1-hex/${TESTNAME}.hex.txt\" \
        -P mips_cpu_bus_tb.INSTRUCTION=\"${instruction}\" \
        -o test/2-simulator/CPU_MU0_bus_tb_${TESTNAME} # set the test-bench as top level since this instantiates everything # having the test case file input into the RAM
        # output executable file for this instruction testcase
        # MAKE SURE TO ADJUST THIS BLOCK OF CODE FOR POSSIBLE CHANGES IN DIRECTORY

        >&2 echo " 3 - Running the test-bench for ${TESTNAME}"
        # Running the executable cpu file we just made and capturing the output
        # display instructions to an output file
        set +e

        test/2-simulator/CPU_MU0_bus_tb_${TESTNAME} > test/3-output/CPU_MU0_bus_${TESTNAME}.stdout
        # output file would be called e.g. CPU_MUO_bus_addiu_1.stdout

        RESULT=$?
        set -e

        if [[ "${RESULT}" -ne 0 ]] ; then
          # fail condition
           echo "${TESTNAME} ${instruction} Fail"
           continue
           #exit TODO, might not need to recover this exit code
        fi

        # we now need to extract the necessary lines with the prefix "RESULT : "
        # The associated value is then output and written into a .out file
        # so that we can compare it to the reference output result files
        PATTERN="RESULT : "
        NOTHING=""

        set +e
        # grep grabs the lines with the prefix described by PATTERN and outputs them to a new file
        grep "${PATTERN}" test/3-output/CPU_MU0_bus_${TESTNAME}.stdout > \
        test/3-output/CPU_MU0_bus_${TESTNAME}.result-lines

        # Now we need to remove the "RESULT : " bit and maintain the correct value
        set -e
        sed -e "s/${PATTERN}/${NOTHING}/g" test/3-output/CPU_MU0_bus_${TESTNAME}.result-lines \
        > test/3-output/CPU_MU0_bus_${TESTNAME}.out
        # Actual final result of the test case is stored in a .out file
        # Note that the output of this will have spaces before the actual value but
        # this shouldn't have an effect when comparing to the reference files

        >&2 echo " 4 - Comparing to the reference output files for ${TESTNAME}"
        # Here we compare the generated output files from part 3 with the pre-generated
        # output files in 4-reference

        set +e # +e used to stop the script failing if an error occurs
        >&2 diff -w test/4-reference/${TESTNAME}.out test/3-output/CPU_MU0_bus_${TESTNAME}.out
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
    >&2 echo "Testing CPU in ${source_directory} for all instructions"

    INSTRUCTIONS="test/0-instructions_assembly/*_0.asm.txt"
    # Holds EVERY INSTRUCTION with the prefix _1/asm.txt therefore holding every
    # instruction assuming every instruction has the _0 suffix
    for i in ${INSTRUCTIONS} ; do
        instruction=$(basename ${i} _0.asm.txt)
        # Removes the _0.asm.txt and the directory path to just get the instruction name
        TESTCASES="test/0-instructions_assembly/${instruction}_*.asm.txt"
        # TESTCASES holds all the test files for the CURRENT instruction
        # with the suffix .asm.txt; for the addiu instruction, it holds addiu_0,
        # addiu_1, addiu_2 etc.
        # We need to remove the suffix at every loop where we access the TESTCASES

        # start assembly for testing for all instructions
        >&2 echo "  1 - Assembling test files for instruction : ${instruction}"
        # iterating through the test cases, i represents the file name e.g. addiu_1
        # here it is all test case file names
        for i in ${TESTCASES} ; do
            TESTNAME=$(basename ${i} .asm.txt)
            echo test/0-instructions_assembly/${TESTNAME}.asm.txt | python3 test/Assembler/Assembler.py \
            >test/1-hex/${TESTNAME}.hex.txt
            # instruction assembly files have now been compiled into their hex binary files

            >&2 echo " 2 - Compiling test-bench for ${TESTNAME}"
            # compile all components needed for the test-bench and forming an
            # executable file which runs the CPU with the instructions input into
            # RAM;
            iverilog -g 2012 \
            ${source_directory}/mips_cpu_*.v test/mips_cpu_bus_tb.v test/RAM_8x4096.v \
            ${source_directory}/mips_cpu/*.v \
            -s mips_cpu_bus_tb \
            -P mips_cpu_bus_tb.RAM_INIT_FILE=\"test/1-hex/${TESTNAME}.hex.txt\" \
            -P mips_cpu_bus_tb.INSTRUCTION=\"${instruction}\" \
            -o test/2-simulator/CPU_MU0_bus_tb_${TESTNAME} # output executable file for this instruction testcase

            >&2 echo " 3 - Running the test-bench for ${TESTNAME}"
            # Running the executable cpu file we just made and capturing the output
            # display instructions to an output file

            set +e

            test/2-simulator/CPU_MU0_bus_tb_${TESTNAME} > test/3-output/CPU_MU0_bus_${TESTNAME}.stdout
            # output file would be called e.g. CPU_MUO_bus_addiu_1.stdout
            # this contains the printed lines from running the testbench verilog,

            RESULT=$?
            set -e

            # return a fail if there is an error when outputting the result value into the output
            if [[ "${RESULT}" -ne 0 ]] ; then
              # fail condition
               echo "${TESTNAME} ${instruction} Fail"
               continue
               # exit
            fi

            # we now need to extract the necessary lines with the prefix "RESULT : "
            # The associated value is then output and written into a .out file
            # so that we can compare it to the reference output result files
            PATTERN="RESULT : "
            NOTHING=""

            set +e
            grep "${PATTERN}" test/3-output/CPU_MU0_bus_${TESTNAME}.stdout > \
            test/3-output/CPU_MU0_bus_${TESTNAME}.result-lines

            # Now we need to remove the "RESULT : " bit and maintain the correct value
            set -e
            sed -e "s/${PATTERN}/${NOTHING}/g" test/3-output/CPU_MU0_bus_${TESTNAME}.result-lines \
            > test/3-output/CPU_MU0_bus_${TESTNAME}.out
            # Actual final result of the test case is stored in a .out file
            # Note that the output of this will have spaces before the actual value but
            # this shouldn't have an effect when comparing to the reference files

            >&2 echo " 4 - Comparing to the reference output files"
            # Here we compare the generated output files from part 3 with the pre-generated
            #  output files in 4-reference

            TESTNAME=$(basename ${i} .asm.txt)
            set +e # +e used to stop the script failing if an error occurs
            >&2 diff -w test/4-reference/${TESTNAME}.out test/3-output/CPU_MU0_bus_${TESTNAME}.out
            RESULT=$? # output of this diff line stored in RESULT
            set -e

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
