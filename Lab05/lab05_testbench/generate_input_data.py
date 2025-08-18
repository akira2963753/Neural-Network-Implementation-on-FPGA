import random

NUM_DATA = 128
OUTPUT_FILE = "C:/verilog/NCUE/LAB5/input_data.txt"

with open(OUTPUT_FILE, "w") as f:
    for _ in range(NUM_DATA):
        # 產生一筆隨機 32-bit 資料（有正有負）
        value = random.randint(0, 0xFFFFFFFF)
        # 寫入十六進位（小寫字母），前面補 0 至 8 位數
        f.write(f"{value:08x}\n")

print(f"已產生 {NUM_DATA} 筆 32-bit 資料到 {OUTPUT_FILE}")
