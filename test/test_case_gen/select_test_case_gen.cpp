#include <iostream>
#include <string>
#include <cmath>
#include <cstdlib>
#include <ctime>

using namespace std;

/*
TO DO
1. Adjust unsigned instructions and understand how we should handle them
2. Possibly create randomised instructions for lw and sw
*/

// function that returns the expected result
int instr_exec_and_print(string instruction, int regS, int regT, int immediate, int i)
{
    // determining the final output based on the instructions and the general inputs
        // main instructions
    cout << instruction << " detected" << endl;
    string ADDIU = "ADDIU";
    if (!instruction.compare("ADDIU"))
    {
        //cout << instruction << " detected" << endl;
        // preloading registers with addresses of data values to then LW
        // t0 stores the address of the datavalue
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, 4" << endl; // line 1, address 0
        // loading a0 with the 32-bit value regS
        cout << "tc" << i << " : " << "LW $a0, 0($t0)" << endl; // line 2, address 1

        cout << "tc" << i << " : " << "ADDIU $v0, $a0, " << immediate << endl; // line 3, address 2
        //indiicating the end of the sequence of instructions
        cout << "tc" << i << " : " << "JR $zero" << endl; // line 4, address 3
        //therefore telling the CPU to halt

        // data values pre-loading
        cout << "tc" << i << " : " << ".data " << regS << endl; // line 5, address 4
        cout << endl;
        cout << "RESULT" << i << " : " << regS + immediate << endl;
        cout << endl;

        return 1;
    }
    /*
    else if (!instruction.compare("JR")) //MANUAL
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, 4" << endl; // 0
        cout << "tc" << i << " : " << "JR $t0" << endl; // 1
        cout << "tc" << i << " : " << "ADDIU $v0, $zero, 15" << endl; // 2, delay slot which must be executed
        cout << "tc" << i << " : " << "ADDIU $v0, $v0, 5" << endl; // 3, should be skipped
        cout << "tc" << i << " : " << "ADDIU $v0, $v0, 15" << endl; // 4, should be jumped to
        cout << "tc" << i << " : " << "JR $zero" << endl;

        cout << endl;
        cout << "tc" << i << " : " << "RESULT" << i << " : " << 30 << endl;
        cout << endl;
        return 1;
    }
    */
    else if (!instruction.compare("LW")) //MANUAL or AUTO
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, <address line for data>" << endl;
        cout << "tc" << i << " : " << "SW $t0," << immediate << "($)" << endl;
        cout << "tc" << i << " : " << "LW $V0, " << immediate << "($t0)" << endl;
        cout << "tc" << i << " : " << ".data " << 21 << endl;
        return 1;
    }
    else if (!instruction.compare("SW")) //MANUAL or AUTO
    {
        return 0;
    }
    /*
    else if (instruction.compare("LUI"))
    {
        return
    } */ // all other instructions
    else if (!instruction.compare("ADDU")) //TODO
    {
        // preloading registers with addresses of data values to then LW
        // t0 stores the address of the datavalue
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, 4" << endl; // line 1, address 0
        // loading a0 with the 32-bit value regS
        cout << "tc" << i << " : " << "LW $a0, 0($t0)" << endl; // line 2, address 1

        cout << "tc" << i << " : " << "ADDIU $v0, $a0, " << immediate << endl; // line 3, address 2
        //indiicating the end of the sequence of instructions
        cout << "tc" << i << " : " << "JR $zero" << endl; // line 4, address 3
        //therefore telling the CPU to halt

        // data values pre-loading
        cout << "tc" << i << " : " << ".data " << regS << endl; // line 5, address 4
        cout << endl;
        cout << "RESULT" << i << " : " << regS + immediate << endl;
        cout << endl;
        return 0;
    } else if (!instruction.compare("AND")) // working
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, 6" << endl; // 0
        cout << "tc" << i << " : " << "ADDIU $t1, $zero, 7" << endl; // 1

        cout << "tc" << i << " : " << "LW $a0, 0($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 0($t1)" << endl; // 3

        cout << "tc" << i << " : " << "AND $V0, $a0, $a1" << endl; // 4
        cout << "tc" << i << " : " << "JR $zero" << endl; // 5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6
        cout << "tc" << i << " : " << ".data " << regT << endl; // 7
        cout << endl;

        cout << "RESULT" << i << " : " << (regS & regT) << endl;;
        cout << endl;
        return 1;
    }
    else if (!instruction.compare("ANDI"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, 6" << endl; // 0
        cout << "tc" << i << " : " << "ADDIU $t1, $zero, 7" << endl; // 1

        cout << "tc" << i << " : " << "LW $a0, 0($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 0($t1)" << endl; // 3

        cout << "tc" << i << " : " << "AND $V0, $a0, $a1" << endl; // 4
        cout << "tc" << i << " : " << "JR $zero" << endl; // 5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6
        cout << "tc" << i << " : " << ".data " << regT << endl; // 7
        cout << endl;

        cout << "RESULT" << i << " : " << (regS & immediate) << endl;;
        cout << endl;
        return 1;
    } /*
    else if (instruction.compare("BEQ"))
    {
        return
    } else if (instruction.compare(""))
    {
        return
    } else if (instruction.compare(""))
    {
        return
    } else if (instruction.compare(""))
    {
        return
    } else if (instruction.compare(""))
    {
        return
    } else if (instruction.compare(""))
    {
        return
    }
    */
    return 0;
}

int main()
{
    //expected input to be in capitals
    string instr;
    cin >> instr;

    // convert to upper case
    for (int i = 0; i < instr.length(); i++)
    {
        instr[i] = toupper(instr[i]);
    }

    // unsigned instructions
    /*
    if (instr.compare("ADDIU")|| instr.compare("ADDU"))
    {
        u_int32_t regS; // represents the source register
        u_int32_t regT = 0; // represents the secondary argument register
        u_int16_t immediate = 0; // represents the immediate input
    } else //signed instructions
    */

    // declaring signed variables
    int32_t regS;
    int32_t regT = 0;
    int16_t immediate = 0;

    int32_t lower = -pow(2, 31);
    int32_t upper = pow(2, 31) - 1;

    int16_t im_lower = -pow(2, 15);
    int16_t im_upper = pow(2, 15) - 1;

    // generating the lower test-cases

    regS = lower;
    regT = 0;
    immediate = im_lower;

    int n = instr_exec_and_print(instr, regS, regT, immediate, 0);
    if (n == 0)
    {
        cout << "Instruction not detected" << endl;
    }

    cout << "Test case : " << 0 << endl;
    cout << endl;

    regS = lower;
    regT = lower;
    immediate = 0;

    instr_exec_and_print(instr, regS, regT, immediate, 1);
    cout << "Test case : " << 1 << endl;
    cout << endl;

    srand((unsigned)time(NULL));

    // generating randomised values in between the corner cases
    for (int i = 2; i != 5; i++) // 3 test cases
    {
        // generate randomised value
        regS = (rand() % upper) - upper/2;
        regT = (rand() % upper) - upper/2;
        immediate =  rand() % upper + lower;

        instr_exec_and_print(instr, regS, regT, immediate, i);
        cout << "Test case : " << i << endl;
        cout << endl;
    }

    // generating the upper test cases

    regS = upper;
    regT = upper;
    immediate = 0;

    instr_exec_and_print(instr, regS, regT, immediate, 5);
    cout << "Test case : " << 5 << endl;
    cout << endl;

    regS = upper;
    regT = 0;
    immediate = im_lower;

    instr_exec_and_print(instr, regS, regT, immediate, 6);
    cout << "Test case : " << 6 << endl;
    cout << endl;

    /*
    cout << "Manual testing" << endl;
    regS = 5;
    regT = 9;
    instr_exec_and_print(instr, regS, regT, immediate);
    cout << endl;
    */
}
