#!/usr/bin/python3

import re

f=open("BlockMap.c")
filestr=f.read()

print(type(filestr))
print(re.match(r"const",'111\n const',re.S))

# print(filestr)

f.close()