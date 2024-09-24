import random
import sys
file = open("mips_code.txt", "w")


def rand(a, b, exception):
    res = random.randint(a, b)
    if exception and res == 1:
        return 0
    return res


def valueGene(small, sizeDm):
    val = {}
    for i in small:
        val[i] = rand(0, 100, False) * 4
    return val


def get_small(smallReg):
    small = [value for value in range(0, 27)]
    for i in range(1, 27):
        temp = rand(1, 26, False)
        small[i], small[temp] = small[temp], small[i]
    for i in range(1, smallReg + 1):
        small[i] += 1
    small = small[0:smallReg+1]
    return small


def notSmall(small):
    while True:
        u = rand(0, 27, 1)
        if u not in small:
            return u


size_im = 900
size_dm = 3072
size_op = 9  # operation types
small_reg = 8  # register designed for lw and sw
cnt = 0
branch = {}
small = get_small(small_reg)
value = valueGene(small, size_dm)
operation_list = []
for i in range(0, small_reg):
    Operation = [4, small[i], 0, value[small[i]]]
    operation_list.append(Operation)

for i in range(small_reg, size_im):
    Operation = []
    op0 = rand(0, size_op - 1, 0)
    if op0 == 0:  # nop
        Operation = [0, 0, 0, 0]
    if op0 == 1 or op0 == 2:  # add and sub
        Operation = [op0, notSmall(small), rand(
            0, 27, True), rand(0, 27, True)]
    if op0 == 3 or op0 == 4:  # lui and ori
        Operation = [op0, notSmall(small), rand(
            0, 27, True), rand(0, 65535, False)]
    if op0 == 5:  # lw
        r1 = rand(100, 200, False) *4
        r2 = rand(1, small_reg, False)
        Operation = [op0, notSmall(small), small[r2], (r1-value[small[r2]])]
    if op0 == 6:  # sw
        r1 = rand(100, 200, False) *4
        r2 = rand(1, small_reg, False)
        Operation = [op0, rand(0, 27, True), small[r2],
                     (r1-value[small[r2]])]
    if op0 == 7:
        r3 = rand(i, size_im - 1, False)
        cnt += 1
        Operation = [op0, rand(0, 27, True), rand(0, 27, True), cnt]
        if r3 not in branch:
            branch[r3] = [cnt]
        else:
            branch[r3].append(cnt)
    if op0 == 8: #jal
        r3 = rand(i ,size_im - 1,False)
        cnt += 1
        Operation = [op0, cnt]
        if r3 not in branch:
            branch[r3] = [cnt]
        else:
            branch[r3].append(cnt)
    if op0 == 9:
        Operation = [op0]
    operation_list.append(Operation)
for line,op in enumerate(operation_list):
    if op[0] == 0:
        print("nop", file=file)
    elif op[0] == 1:
        print(f"add ${op[1]},${op[2]},${op[3]}", file=file)
    elif op[0] == 2:
        print(f"sub ${op[1]},${op[2]},${op[3]}", file=file)
    elif op[0] == 3:
        print(f"lui ${op[1]},{op[3]}", file=file)
    elif op[0] == 4:
        print(f"ori ${op[1]},${op[2]},{op[3]}", file=file)
    elif op[0] == 5:
        print(f"lw ${op[1]},{op[3]}(${op[2]})", file=file)
    elif op[0] == 6:
        print(f"sw ${op[1]},{op[3]}(${op[2]})", file=file)
    elif op[0] == 7:
        print(f"beq ${op[1]},${op[2]},branch{op[3]}", file=file)
    elif op[0] == 8:
        print(f"jal branch{op[1]}",file = file)
    elif op[0] == 9:
        print(f"jr $ra")
    if line in branch:
        for br in branch[line]:
            print(f"branch{br}:", file=file)
