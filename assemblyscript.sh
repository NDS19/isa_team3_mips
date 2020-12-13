#!/bin/bash
set -e

TESTCASES = "test/0-instructions_assembly/*.asm.txt"
# captures all testcases in the TESTCASES parameter with the suffix
# .asm.txt

for i in ${TESTCASES} ; do
    TESTNAME=$(basename ${i} .asm.txt)
    python Assembler/Assembler.py # please fill in the rest of this execution line
    # file to input : every file held by the test case parameter
    #  test/0-instructions_assembly/${i}

    # file to output to : test/1-binary/${TESTNAME}.bin.out
done
