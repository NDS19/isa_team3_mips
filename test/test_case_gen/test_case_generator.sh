#!/bin/bash
set -e

TESTCASE="$1"

g++ test_case_gen/select_test_case_gen.cpp -o test_case_gen/select

echo ${TESTCASE} | ./test_case_gen/select > test_case_gen/filedump/${TESTCASE}.stdout

for i in 0 1 2 3 4 5 6 ; do
    # extract the instruction lines to a temp file
    PATTERN="tc${i} : "
    OUTPUT="RESULT${i} : "
    NOTHING=""

    set +e

    grep "${PATTERN}" test_case_gen/filedump/${TESTCASE}.stdout > test_case_gen/filedump/${TESTCASE}_${i}.asm.stdout
    grep "${OUTPUT}" test_case_gen/filedump/${TESTCASE}.stdout > test_case_gen/filedump/${TESTCASE}_${i}.stdout

    set -e

    sed -e "s/${PATTERN}/${NOTHING}/g" test_case_gen/filedump/${TESTCASE}_${i}.asm.stdout \
    > 0-instructions_assembly/${TESTCASE}_${i}.asm.txt
    sed -e "s/${OUTPUT}/${NOTHING}/g" test_case_gen/filedump/${TESTCASE}_${i}.stdout \
    > 4-reference/${TESTCASE}_${i}.out
done
