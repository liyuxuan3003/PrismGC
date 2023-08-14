#!/usr/bin/python3
def hex_to_mif(hex_file, mif_file, depth, width):
    with open(hex_file, 'r') as f:
        lines = f.readlines()

    data = []
    for line in lines:
        line = line.strip()
        if line:
            try:
                val = int(line, 16)
                data.append(val)
            except ValueError:
                print(f"Ignoring invalid line: {line}")

    # 将数据写入.mif文件
    with open(mif_file, 'w') as f:
        f.write(f'DEPTH = {depth};\n')
        f.write(f'WIDTH = {width};\n')
        f.write('ADDRESS_RADIX = HEX;\n')
        f.write('DATA_RADIX = HEX;\n')
        f.write('CONTENT\n')
        f.write('BEGIN\n')

        for addr, val in enumerate(data):
            f.write('{:X} : {:0{width}X};\n'.format(addr, val, width=width//4))

        f.write('END;\n')

# 示例用法
hex_file = '../Objects/code.hex'
mif_file = '../Objects/code.mif'
depth = 16384
width = 32
hex_to_mif(hex_file, mif_file, depth, width)