def bitString(x,bits):
    binary = format(x, '0' + str(bits) + 'b')
    if(x < 0):
        binary = "0" + binary[1:]
        #print(binary)
        flipped = ""
        for i in binary:
            if i == "0": 
                flipped += "1"
            if i=="1":
                flipped += "0"
        flipped = int(flipped,2)
        print(flipped)
        #flipped = ~ binary#
        #print(binary)
        twoscomplement = flipped + 1
        print(twoscomplement)
        return bitString(twoscomplement,bits)
        #twoscomplement = 
        #while(len(twoscomplement) < bits):
        #    twoscomplement = twoscomplement[0] + twoscomplement
        #return format(x, '0' + str(bits) + 'b')
        #return twoscomplement
    return binary

print(bitString(-1,7))

print(bin(4294477959))
print(bin(2147483648))