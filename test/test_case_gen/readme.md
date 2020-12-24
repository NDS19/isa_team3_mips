This directory contains the main construction point used for generating
randomised test-cases. It consists of:
-select_test_case_gen.cpp, a c++ file used that detects an input string and
  outputs the skeleton for the test-cases with randomised input values to stdout.
  7 sets of test-cases are produced : 2 to test lower edge-cases, 2 to test upper
  edge-cases and 3 test-cases to test randomised values.
  Additionally, this automatically generates the results for the test-cases and
  outputs them too.
-test_case_generator.sh, a script that compiles the c++ file and passes an input
  string containing the instruction into the executable file.
  The outputs sent to stdout are then filtered out so that the test-cases and
  their corresponding results are named properly and go to the correct
  directories for use in the main test script.
