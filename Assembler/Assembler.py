#Input the filenmae of the assembly to start

def isDigit(x):
    try:
        x = int(x)
        return True
    except:
        return False

def bitString(x,bits):
    #print(x)
    binary = format(x, '0' + str(bits) + 'b')
    #print(len(binary))
    #print(binary)
    #print(binary)
    #print(binary)
    if(x < 0):
        #print("hello")
        if(len(binary)==bits+1):
            binary = binary[1:]
        else:
            binary = "0" + binary[1:]
        #print(binary)
        flipped = ""
        for i in binary:
            if i == "0": 
                flipped += "1"
            if i=="1":
                flipped += "0"
        #print(flipped)
        flipped = int(flipped,2)
        #print(flipped)
        #flipped = ~ binary#
        #print(binary)
        twoscomplement = flipped + 1
       # print(twoscomplement)
        bits = bitString(twoscomplement,bits)
        return bits
        #twoscomplement = 
        #while(len(twoscomplement) < bits):
        #    twoscomplement = twoscomplement[0] + twoscomplement
        #return format(x, '0' + str(bits) + 'b')
        #return twoscomplement
    return binary

def reg(reg_code):
    registers = {"$zero":0,
        "$at":1,
        "$v0":2,
        "$v1":3,
        "$a0":4,
        "$a1":5,
        "$a2":6,
        "$a3":7,
        "$t0":8,
        "$t1":9,
        "$t2":10,
        "$t3":11,
        "$t4":12,
        "$t5":13,
        "$t6":14,
        "$t7":15,
        "$s0":16,
        "$s1":17,
        "$s2":18,
        "$s3":19,
        "$s4":20,
        "$s5":21,
        "$s6":22,
        "$s7":23,
        "$t8":24,
        "$t9":25,
        "$k0":26,
        "$k1":27,
        "$gp":28,
        "$sp":29,
        "$fp":30,
        "$ra":31
    }
    
    reg_code = registers[reg_code.lower()]
    output = format(reg_code,'05b')
    return output

def decode(line,parameters,line_names):
    line = line.replace(",","")
    output = ""
    opcodes = {"ADDIU":["r","001001"],
        #"ADDU":"000000",
        #"AND":"000000",
        "ANDI":["r","001100"],
        "BEQ":["r","000100"],
        "BNE":["r","000101"],
        "BGEZ":["b","000001"],
        "BGEZAL":["b","000001"],
        "BGTZ":["b","000111"],
        "BLEZ":["b","000110"],
        "BLTZ":["b","000001"],
        "BLTZAL":["b","000001"],
        "J":["j","000010"],   ##TODO
        "JAL":["j","000011"],
        "LB":["ls","100000"],
        "LBU":["ls","100100"],
        "LH":["ls","100001"],
        "LHU":["ls","100101"],
        "LUI":["li","001111"],##TODO
        "LW":["ls","100011"],
        "LWL":["ls","100010"],
        "LWR":["ls","100110"],
        "ORI":["r","001101"],
        "SB":["ls","101000"],
        "SH":["ls","101001"],
        "SLTI":["r","001010"],
        "SLTIU":["r","001011"],
    # "SLTU":["ls","101001"],
        "SW":["ls","101011"],
        "XORI":["r","001110"]
    }
    branch_codes = {
        "BGEZ":"00001",
        "BGEZAL":"10001",
        "BGTZ":"00000",
        "BLEZ":"00000",
        "BLTZ":"00000",
        "BLTZAL":"10000",
    }

    rtype_func = {"ADDU":["a","100001"],
        "AND":["a","000000"], #arithmatic syntac  #arithmatic
        "DIV":["md","011010"], #mult div syntax    #arithmatic     
        "DIVU":["md","011011"],               
        "JR":["j","001000"], #jump syntax          #JUMP
        "JALR":["jl","000001"], ##TODO              #JUMP
        "MTHI":["m","010001"],                      #MOVE
        "MTLO":["m","010011"],                      #MOVE
        "MULT":["md","011000"],
        "MULTU":["md","011001"],
        "OR":["a","100101"],
        "SLL":["s","000000"], #shift syntax         
        "SLLV":["a","000100"],
        "SLT":["a","101010"],
        "SLTU":["a","101011"],
        "SRA":["s","000011"],
        "SRL":["s","000010"],
        "SRLV":["sa","000110"],
        "SRAV":["sa","000111"],
        "SLA":["s","000010"],
        "SLAV":["a","000110"],
        "SUBU":["a","100011"],
        "XOR":["a","100110"]
    }

    line = line.split()
    #print(line)
    #if this is not an rtype instruction
    if line[0] == ".data":
        output = bitString(int(line[1]),32)
    elif line[0] not in rtype_func:
        #print("not r type")
        opcode = line[0]
        #if opcode in reg_2_type:
        if opcodes[opcode][0] == "r":
            reg1 = line[1]
            reg2 = line[2]
            const = line[3]
            output += opcodes[opcode][1]
            output += reg(reg2)
            output += reg(reg1)
            if isDigit(const):
                output += bitString(int(const),16)
            else:
                #print(parameters)
                #print(const)
                output +=  bitString(int(parameters[const]),16)
        #elif opcode in jmp_type:
        elif opcodes[opcode][0] == "b":
            reg1 = line[1]
            const = line[2]
            output += opcodes[opcode][1]
            output += reg(reg1)
            output += branch_codes[opcode]
            if isDigit(const):
                output += bitString(int(const),16)
            elif output in parameters:
                output += bitString(int(parameters[const]),16)
            else:
                output += bitString(int(line_names[const]),16)
        
        elif opcodes[opcode][0] == "j":
            const = line[1]
            output += opcodes[opcode][1]
            if isDigit(const):
                output += bitString(int(const),26)
            elif output in parameters:
                output += bitString(int(parameters[const]),26)
            else:
                output += bitString(int(line_names[const]),26)

        #elif opcode in load_store_type:
        elif opcodes[opcode][0] == "ls":
            reg1 = line[1]
            reg2 = line[2].split("(")[1][:-1]
            const = line[2].split("(")[0]
            output += opcodes[opcode][1]
            output += reg(reg2)
            output += reg(reg1)
            if isDigit(const):
                output += bitString(int(const),16)
            elif const in parameters:
                output += bitString(int(parameters[const]),16)
            else:
                output += bitString(int(line_names[const]),216)


        elif opcodes[opcode][0] == "li":
            reg1 = line[1]
            const = line[2]
            output += opcodes[opcode][1]
            output += bitString(0,5)
            output += reg(reg1)
            if isDigit(const):
                output += bitString(int(const),16)
            else:
                output += bitString(int(parameters[const]),16)
    else:
        output += bitString(0,6)
        opcode = line[0]
        #if opcode in arithmatic_rtype:
        if rtype_func[opcode][0] == "a":
            reg1 = line[1]
            reg2 = line[2]
            reg3 = line[3]
            output += reg(reg2) + reg(reg3) + reg(reg1) + "00000"
        #elif opcode in mt_rtype:
        elif rtype_func[opcode][0] == "m":
            reg1 = line[1]
            #output += bitString(0,10)
            output += reg(reg1)
            output += bitString(0,15)
        #elif opcode in mult_div:
        elif rtype_func[opcode][0] == "md":
            reg1 = line[1]
            reg2 = line[2]
            output += reg(reg1) + reg(reg2) + bitString(0,10)
        #elif opcode in j_rtype:
        elif rtype_func[opcode][0] == "j":
            reg1 = line[1]
            output += reg(reg1)
            output += bitString(0,15)
        
        elif rtype_func[opcode][0] == "jl":
            if len(line) == 2:
                reg1 = line[1]
                reg2 = "$31"
            else:
                reg1 = line[1]
                reg2 = line[2]
            output += reg(reg2) + bitString(0,5) + reg(reg1) + bitString(0,5)

        elif rtype_func[opcode][0] == "s":
            reg1 = line[1]
            reg2 = line[2]
            const = line[3]
            #reg3 = line[3]
            output += bitString(0,5) + reg(reg2) + reg(reg1) #+ reg(reg3)
            if isDigit(const):
                output += bitString(int(const),5)
            elif output in parameters:
                output += bitString(int(parameters[const]),5)

        elif rtype_func[opcode][0] == "sa":
            reg1 = line[1]
            reg2 = line[2]
            reg3 = line[3]
            output +=  reg(reg3) + reg(reg2) + reg(reg1) + bitString(0,5)
        #elif opcode in mt_rtype:
        output += rtype_func[opcode][1]
    #print(output)
    return output

def writeOutput(output,output_file):
    #print(output)
    #print(len(output))
    #_f = open(output_file, 'w')
    output_string = ""
    n = 0

    byte_1 = hex(int(output[24:28],2))[2] + hex(int(output[28:32],2))[2]
    byte_2 = hex(int(output[16:20],2))[2] + hex(int(output[20:24],2))[2]
    byte_3 = hex(int(output[8:12],2))[2] + hex(int(output[12:16],2))[2]
    byte_4 = hex(int(output[0:4],2))[2] + hex(int(output[4:8],2))[2]

    output_string = byte_1 + " " + byte_2 + " " + byte_3 + " " + byte_4

    # for i in range(len(output)):
    #     if i % 4 == 0:
    #         x = output[i:i+4]
    #         #print(x)
    #         x = hex(int(x,2))[2]
    #         #print(x)
    #         #_f.write(x)
    #         output_string += x
    #     if (i+4) % 8 == 0 and i != 0:
    #         output_string += " "
    #_f.write("\n")
    #_f.close()
    print(output_string)


f = open(input(), 'r')
#f = open("test.txt", 'r')
lines = f.readlines()

parameters = {}
line_names = {}

output_file = "output.hex"

#find all the line names and parameters
for i in range(len(lines)):
    if len(lines[i].split(":")) > 1:
        line = lines[i].split(":")
        if isDigit(line[1]):
            parameters[line[0]] = int(line[1])
        else:
            line_names[line[0]] = i * 4
            #(i + 3217031168 ) & (pow(2,27)-1)

#assemble all the lines
for line in lines:
    if len(line.split(":")) > 1:
        if isDigit(line.split(":")[1]):
            continue
        else:
            line = line.split(":")[1]   
    output = decode(line,parameters,line_names)
    writeOutput(output,output_file)



f.close()