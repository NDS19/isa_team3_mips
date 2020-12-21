#include <iostream>
#include <string>
#include <cmath>
#include <cstdlib>
#include <ctime>

using namespace std;

/*
TO DO
1. Adjust unsigned instructions and understand how we should handle them
    ADDIU ADDU
2. Possibly create randomised instructions for lw and sw
3. Update instructions that use pre-defined data to take them relative to the
    reset address
4. Possibly move instructions to the signed output depending on the output of %d
    from the test bench verilog file
*/

// when finding offsets, take them relative to the address AFTER the reset address
// since the instruction after the reset address is executed first (which is
// always the addiu instruction)

// function that returns the expected result
// unsigned
int u_instr_exec_and_print(string instruction, u_int32_t regS, u_int32_t regT, u_int16_t immediate, int i)
{
    if (!instruction.compare("ADDIU"))
    {
        //cout << instruction << " detected" << endl;
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base

        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1

        // loading a0 with the 32-bit value regS
        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // line 3, address 2

        cout << "tc" << i << " : " << "ADDIU $V0, $a0, " << immediate << endl; // line 4, address 3
        //indiicating the end of the sequence of instructions
        cout << "tc" << i << " : " << "JR $zero" << endl; // line 5, address 4
        //therefore telling the CPU to halt
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // line 6, address 5

        int MSB = immediate >> 15;
        u_int32_t ext_imm;

        if (MSB == 1) // sign extend with a 1
        {
            ext_imm = 4294901760;
            ext_imm = ext_imm + immediate;
        } else
        {
            ext_imm = 0;
            ext_imm = ext_imm + immediate;
        }
        // data values pre-loading
        cout << "tc" << i << " : " << ".data " << regS << endl; // line 7, address 6
        cout << endl;
        cout << "RESULT" << i << " : " << regS + ext_imm << endl;
        cout << endl;

        return 1;
    }
    else if (!instruction.compare("ADDU")) //TODO
    {
        // preloading registers with addresses of data values to then LW
        // t0 stores the address of the datavalue
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, 49088" << endl; // line 1, address 0
        cout << "tc" << i << " : " << "SLL $t0, $t0, 16" << endl; // 1

        // loading a0 with the 32-bit value regS
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        // regT
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "ADDU $V0, $a0, $a1" << endl; // 4
        //indiicating the end of the sequence of instructions
        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        //therefore telling the CPU to halt
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        // data values pre-loading
        cout << "tc" << i << " : " << ".data " << regS << endl; // 7
        cout << "tc" << i << " : " << ".data " << regT << endl; // 8

        cout << endl;
        cout << "RESULT" << i << " : " << regS + regT << endl;
        cout << endl;
        return 1;
    }
    else if (!instruction.compare("DIVU"))
    {
        return 0;
    }
    else if (!instruction.compare("SLTIU"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2

        cout << "tc" << i << " : " << "SLTIU $V0, $a0, " << immediate <<  endl; // 3

        cout << "tc" << i << " : " << "JR $zero" << endl; // 4
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6

        //sign extend
        int MSB = immediate >> 15;
        u_int32_t ext_imm;

        if (MSB == 1) // sign extend with a 1
        {
            ext_imm = 4294901760;
            ext_imm = ext_imm + immediate;
        } else
        {
            ext_imm = 0;
            ext_imm = ext_imm + immediate;
        }

        if (regS < ext_imm)
        {
            cout << "RESULT" << i << " : " << 1 << endl;
        } else
        {
            cout << "RESULT" << i << " : " << 0 << endl;
        }
        return 1;
    }
    else if (!instruction.compare("SLTU"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "SLTU $V0, $a0, $a1" << endl; // 4

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        cout << "tc" << i << " : " << ".data " << regS << endl; // 7
        cout << "tc" << i << " : " << ".data " << regT << endl; // 8

        if (regS < regT)
        {
            cout << "RESULT" << i << " : " << 1 << endl;
        } else
        {
            cout << "RESULT" << i << " : " << 0 << endl;
        }
        return 1;
    }
    else if (!instruction.compare("SUBU"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "SUBU $V0, $a0, $a1" << endl; // 4

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        cout << "tc" << i << " : " << ".data " << regS << endl; // 7
        cout << "tc" << i << " : " << ".data " << regT << endl; // 8

        cout << "RESULT" << i << " : " << (regS - regT) << endl;

        return 1;
    }
    else if (!instruction.compare("SRL")) // zeroes shifted in
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2

        int shift = rand() % 31; //represents the shamt field

        cout << "tc" << i << " : " << "SRL $V0, $a0, " << shift << endl; // 3

        cout << "tc" << i << " : " << "JR $zero" << endl; // 4
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6

        cout << "RESULT" << i << " : " << (regS >> shift) << endl;
        return 1;
    }
    else if (!instruction.compare("SRLV"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "SRLV $V0, $a0, $a1" << endl; // 4

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        int shift = rand() % 31;

        cout << "tc" << i << " : " << ".data " << regS << endl; // 7
        cout << "tc" << i << " : " << ".data " << shift << endl; // 8

        cout << "RESULT" << i << " : " << (regS >> shift) << endl;
        return 1;
    }
}

// signed
int instr_exec_and_print(string instruction, int32_t regS, int32_t regT, int16_t immediate, int i)
{
    //TODO : OR, ORI, SB, SH, SLL, SLLV,

    // determining the final output based on the instructions and the general inputs
        // main instructions
    cout << instruction << " detected" << endl;

    if (!instruction.compare("JR")) //MANUAL
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
    else if (!instruction.compare("LW")) //MANUAL or AUTO, using AUTO to cover more occurences
    {
        return 1;
    }
    else if (!instruction.compare("SW")) //MANUAL or AUTO
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2

        cout << "tc" << i << " : " << "SW $a0, 32($t0)" << endl; // 3
        cout << "tc" << i << " : " << "LW $V0, 32($t0)" << endl; // 4

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        cout << "tc" << i << " : " << ".data " << regS << endl; // 7

        cout << "RESULT" << i << " : " << regS << endl;
        return 1;
    }
    /*
    else if (instruction.compare("LUI"))
    {
        return
    } */ // all other instructions
    else if (!instruction.compare("ADDU")) //working
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
        // making data relative to the reset address
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        // t0 and t1 now store the reset address and we can load relative to this

        // can just use offsets from the reset address to get the data values loaded in
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "AND $V0, $a0, $a1" << endl; // 4
        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6, burner instruction to take up the branch delay slot

        cout << "tc" << i << " : " << ".data " << regS << endl; // 7
        cout << "tc" << i << " : " << ".data " << regT << endl; // 8
        cout << endl;

        cout << "RESULT" << i << " : " << (regS & regT) << endl;
        cout << endl;
        return 1;
    }
    else if (!instruction.compare("ANDI"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1

        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2

        cout << "tc" << i << " : " << "ANDI $V0, $a0, " << immediate << endl; // 3
        cout << "tc" << i << " : " << "JR $zero" << endl; // 4
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; //5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6
        cout << endl;

        // zero extend
        u_int16_t u_imm = immediate;

        u_int32_t ext_imm = 0;
        ext_imm = ext_imm + u_imm;

        cout << "RESULT" << i << " : " << (regS & ext_imm) << endl;;
        return 1;
    }
    /*
    else if (!instruction.compare("DIV"))
    { // testing remainder / HI
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1

        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 28($t0)" << endl; // 3

        cout << "tc" << i << " : " << "DIV $a0, $a1" << endl; // 4
        // cout << "tc" << i << " : " << "MFLO $V0" << endl;
        cout << "tc" << i << " : " << "MFHI $V0" << endl; // 5

        cout << "tc" << i << " : " << "JR $zero" << endl;
        cout << "tc" << i << " : " << ".data " << regS << endl; // 6
        cout << "tc" << i << " : " << ".data " << regT << endl; // 7

        cout << "RESULT" << i << " : " << (regS % regT) << endl; // 8

        return 1;
    }
    else if (!instruction.compare("DIV"))
    { // testing quotient / LO
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1

        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "DIV $a0, $a1" << endl; // 4
        cout << "tc" << i << " : " << "MFLO $V0" << endl;

        cout << "tc" << i << " : " << "JR $zero" << endl;
        cout << "tc" << i << " : " << ".data " << regS << endl; // 6
        cout << "tc" << i << " : " << ".data " << regT << endl; // 7

        cout << "RESULT" << i << " : " << (regS / regT) << endl; // 8

        return 1;
    } */
    else if (!instruction.compare("OR"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1

        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "OR $V0, $a0, $a1" << endl; // 4

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        cout << "tc" << i << " : " << ".data " << regS << endl; // 7
        cout << "tc" << i << " : " << ".data " << regT << endl; // 8

        cout << "RESULT" << i << " : " << (regS | regT) << endl; // 9

        return 1;
    } else if (!instruction.compare("ORI"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1

        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2

        cout << "tc" << i << " : " << "ORI $V0, $a0, " << immediate << endl; // 3

        cout << "tc" << i << " : " << "JR $zero" << endl; // 4
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6

        // zero-extend
        u_int16_t u_imm = immediate;

        int32_t ext_imm = 0;
        ext_imm = ext_imm + u_imm;

        cout << "RESULT" << i << " : " << (regS | ext_imm) << endl; // 7

        return 1;
    }
    else if (!instruction.compare("SB"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2, load the data value in
        cout << "tc" << i << " : " << "SB $a0, 32($t0)" << endl; // 3, storing in address $t0 + 28

        cout << "tc" << i << " : " << "LW $V0, 32($t0)" << endl; // 4, load the data value in

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        cout << "tc" << i << " : " << ".data " << regT << endl; // 7

        cout << "RESULT" << i << " : " << (regT & 0x000000ff) << endl;
        //cout << "tc" << i << " : " <<
        return 1;
    }
    else if (!instruction.compare("SH"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2, load the data value in
        cout << "tc" << i << " : " << "SH $a0, 32($t0)" << endl; // 3, storing in address $t0 + 28

        cout << "tc" << i << " : " << "LW $V0, 32($t0)" << endl; // 4, load the data value in

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        cout << "tc" << i << " : " << ".data " << regT << endl; // 7

        cout << "RESULT" << i << " : " << (regT & 0x0000ffff) << endl;
        //cout << "tc" << i << " : " <<
        return 1;
    }
    else if (!instruction.compare("SLL"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2

        int shift = rand() % 31; //represents the shamt field

        cout << "tc" << i << " : " << "SLL $V0, $a0, " << shift << endl; // 3

        cout << "tc" << i << " : " << "JR $zero" << endl; // 4
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6

        cout << "RESULT" << i << " : " << (regS << shift) << endl;
        return 1;
    }
    else if (!instruction.compare("SLLV"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "SLLV $V0, $a0, $a1" << endl; // 4

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        int shift = rand() % 31;

        cout << "tc" << i << " : " << ".data " << regS << endl; // 7
        cout << "tc" << i << " : " << ".data " << shift << endl; // 8

        cout << "RESULT" << i << " : " << (regS << shift) << endl;
        return 1;
    }
    else if (!instruction.compare("SLT"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "SLT $V0, $a0, $a1" << endl; // 4

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        cout << "tc" << i << " : " << ".data " << regS << endl; // 7
        cout << "tc" << i << " : " << ".data " << regT << endl; // 8

        if (regS < regT)
        {
            cout << "RESULT" << i << " : " << 1 << endl;
        } else
        {
            cout << "RESULT" << i << " : " << 0 << endl;
        }
        return 1;
    }
    else if (!instruction.compare("SLTI"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2

        cout << "tc" << i << " : " << "SLTI $V0, $a0, " << immediate <<  endl; // 3

        cout << "tc" << i << " : " << "JR $zero" << endl; // 4
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6

        int MSB = immediate >> 15;
        int32_t ext_imm;

        if (MSB == 1) // sign extend with a 1
        {
            ext_imm = 4294901760;
            ext_imm = ext_imm + immediate;
        } else
        {
            ext_imm = 0;
            ext_imm = ext_imm + immediate;
        }

        if (regS < ext_imm)
        {
            cout << "RESULT" << i << " : " << 1 << endl;
        } else
        {
            cout << "RESULT" << i << " : " << 0 << endl;
        }
        return 1;
    }
    else if (!instruction.compare("XOR"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1

        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "XOR $V0, $a0, $a1" << endl; // 4

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        cout << "tc" << i << " : " << ".data " << regS << endl; // 7
        cout << "tc" << i << " : " << ".data " << regT << endl; // 8

        cout << "RESULT" << i << " : " << (regS ^ regT) << endl; // 9

        return 1;
    }
    else if (!instruction.compare("XORI"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1

        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2

        cout << "tc" << i << " : " << "XORI $V0, $a0, " << immediate << endl; // 3

        cout << "tc" << i << " : " << "JR $zero" << endl; // 4
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6

        u_int16_t u_imm = immediate;

        int32_t ext_imm = 0;
        ext_imm = ext_imm + u_imm;

        cout << "RESULT" << i << " : " << (regS ^ ext_imm) << endl; // 7

        return 1;
    }
    else if (!instruction.compare("SRA"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2

        int shift = rand() % 31; //represents the shamt field

        cout << "tc" << i << " : " << "SRA $V0, $a0, " << shift << endl; // 3

        cout << "tc" << i << " : " << "JR $zero" << endl; // 4
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6

        cout << "RESULT" << i << " : " << (regS >> shift) << endl;
        return 1;
    }
    else if (!instruction.compare("SRAV"))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 28($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 32($t0)" << endl; // 3

        cout << "tc" << i << " : " << "SRAV $V0, $a0, $a1" << endl; // 4

        cout << "tc" << i << " : " << "JR $zero" << endl; // 5
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; // 6

        int shift = rand() % 31;

        cout << "tc" << i << " : " << ".data " << regS << endl; // 7
        cout << "tc" << i << " : " << ".data " << shift << endl; // 8

        cout << "RESULT" << i << " : " << (regS >> shift) << endl;
        return 1;
    }
    else if (!instruction.compare("DIV"))
    { // testing remainder / HI
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1

        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2
        cout << "tc" << i << " : " << "LW $a1, 28($t0)" << endl; // 3

        cout << "tc" << i << " : " << "DIV $a0, $a1" << endl; // 4
        // cout << "tc" << i << " : " << "MFLO $V0" << endl;
        cout << "tc" << i << " : " << "MFHI $V0" << endl; // 5

        cout << "tc" << i << " : " << "JR $zero" << endl;
        cout << "tc" << i << " : " << ".data " << regS << endl; // 6
        cout << "tc" << i << " : " << ".data " << regT << endl; // 7

        cout << "RESULT" << i << " : " << (regS % regT) << endl; // 8

        return 1;
    }   /*
    else if (!instruction.compare(""))
    {
        cout << "tc" << i << " : " << "ADDIU $t0, $zero, " << 49088 << endl; // 0, represents offset from base
        cout << "tc" << i << " : " << "SLL $t0, $t0, " << 16 << endl; // 1
        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2


        cout << "tc" << i << " : " << "JR $zero" << endl; // 4
        cout << "tc" << i << " : " << "ADDIU $t0, $t0, 0" << endl; //5

        cout << "tc" << i << " : " << ".data " << regS << endl; // 6
        cout << "tc" << i << " : " << "LW $a0, 24($t0)" << endl; // 2

        cout << "RESULT" << i << " : " << (regS & regT) << endl;
        cout << "tc" << i << " : " <<


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

    // declaring unsigned variables
    u_int32_t u_regS; // represents the source register
    u_int32_t u_regT = 0; // represents the secondary argument register
    u_int16_t u_immediate = 0; // represents the immediate input

    u_int32_t u_lower = 0;
    u_int32_t u_upper = pow(2, 32) - 1;

    u_int16_t u_im_lower = 0;
    u_int16_t u_im_upper = pow(2, 16) - 1;

    // declaring signed variables
    int32_t regS;
    int32_t regT = 0;
    int16_t immediate = 0;

    int32_t lower = -pow(2, 31);
    int32_t upper = pow(2, 31) - 1;

    int16_t im_lower = -pow(2, 15);
    int16_t im_upper = pow(2, 15) - 1;

    // unsigned instructions, could probably make this a single function and just call it twice
    if (!instr.compare("ADDIU") || !instr.compare("ADDU")  || !instr.compare("SLTU")  || !instr.compare("SLTIU") || !instr.compare("SUBU") || !instr.compare("SRL") || !instr.compare("SRLV"))
    {
        // generating the lower test-cases

        u_regS = u_lower;
        u_regT = 0;
        u_immediate = u_im_lower;

        int n = u_instr_exec_and_print(instr, u_regS, u_regT, u_immediate, 0);
        if (n == 0)
        {
            cout << "Instruction not detected" << endl;
        }

        cout << "Immediate : " << u_immediate << endl;
        cout << "Test case : " << 0 << endl;
        cout << endl;

        u_regS = u_lower;
        u_regT = u_lower;
        u_immediate = 0;

        u_instr_exec_and_print(instr, u_regS, u_regT, u_immediate, 1);
        cout << "Immediate : " << u_immediate << endl;
        cout << "Test case : " << 1 << endl;
        cout << endl;

        srand((unsigned)time(NULL));

        // generating randomised values in between the corner cases
        for (int i = 2; i != 5; i++) // 3 test cases
        {
            // generate randomised value
            u_regS = (rand() % upper) - upper/2;
            u_regT = (rand() % upper) - upper/2;
            u_immediate =  rand() % upper + lower;

            u_instr_exec_and_print(instr, u_regS, u_regT, u_immediate, i);
            cout << "Immediate : " << u_immediate << endl;
            cout << "Test case : " << i << endl;
            cout << endl;
        }

        // generating the upper test cases

        u_regS = u_upper;
        u_regT = u_upper;
        u_immediate = 0;

        u_instr_exec_and_print(instr, u_regS, u_regT, u_immediate, 5);
        cout << "Immediate : " << u_immediate << endl;
        cout << "Test case : " << 5 << endl;
        cout << endl;

        u_regS = u_upper;
        u_regT = 0;
        u_immediate = u_im_upper;

        u_instr_exec_and_print(instr, u_regS, u_regT, u_immediate, 6);
        cout << "Immediate : " << u_immediate << endl;
        cout << "Test case : " << 6 << endl;
        cout << endl;

    } else
    {
        // generating the lower test-cases

        regS = lower;
        regT = 0;
        immediate = im_lower;

        int n = instr_exec_and_print(instr, regS, regT, immediate, 0);
        if (n == 0)
        {
            cout << "Instruction not detected" << endl;
        }

        cout << "Immediate : " << immediate << endl;
        cout << "Test case : " << 0 << endl;
        cout << endl;

        regS = lower;
        regT = lower;
        immediate = 0;

        instr_exec_and_print(instr, regS, regT, immediate, 1);
        cout << "Immediate : " << immediate << endl;
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
            cout << "Immediate : " << immediate << endl;
            cout << "Test case : " << i << endl;
            cout << endl;
        }

        // generating the upper test cases

        regS = upper;
        regT = upper;
        immediate = 0;

        instr_exec_and_print(instr, regS, regT, immediate, 5);
        cout << "Immediate : " << immediate << endl;
        cout << "Test case : " << 5 << endl;
        cout << endl;

        regS = upper;
        regT = 0;
        immediate = im_upper;

        instr_exec_and_print(instr, regS, regT, immediate, 6);
        cout << "Immediate : " << immediate << endl;
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
}
