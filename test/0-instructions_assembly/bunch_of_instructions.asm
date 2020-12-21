ADDIU $t0, $zero, 49088
SLL $t0, $t0, 16
ADD $V, $zero, $zero
loop: SLTI $8, $V, 10
BEQ $8, $zero, end
LUI $8, 0x1234
ORI $8, $8, 0x5678
SLL $9, $V, 2
ADD $8, $8, $9
SW $zero, 0($8)
ADDIU $V, $V, 1
BEQ $zero, $zero, loop
end: JR $zero
ADDIU $t0, $t0, 0
.data