#!/usr/bin/python3

import re

file=open("Cht.txt")
filestr=file.read()

obj=eval(filestr)

for cht in obj:
    i=0
    for line in cht:
        j=line[0]
        for pixel in line[2]:
            print(r"\Pixel{"+str(i)+"}{"+str(j)+"}{"+pixel.replace("_","")+"}")
            j+=1
        i+=1
    print("-----------------------------------")
    

# mapId=0
# for map in obj:
#     mapId=mapId+1
#     fileTex=open("Map{:02d}.tex".format(mapId),'w+')
#     fileTex.write(r'\documentclass{xMap}'+'\n\n')
#     fileTex.write(r'\begin{document}'+'\n')
#     fileTex.write(r'\begin{tikzpicture}'+'\n')
#     i=0
#     for blockLine in map[0]:
#         j=0
#         for block in blockLine:
#             if block[2:5] not in ["POR","DIR"]:
#                 fileTex.write(r"\Block"+block[2:5]+"{"+str(i)+"}"+"{"+str(j)+"}\n")
#             else:
#                 fileTex.write(r"\Block"+block[2:5]+"{"+str(i)+"}"+"{"+str(j)+"}"+"{"+str(block[1])+"}\n")
#             j+=1
#         i+=1

#     fileTex.write(r"\MainCht"+"{"+str(map[1][0])+"}{"+str(map[1][1])+"}\n")
#     for apple in map[2]:
#         fileTex.write(r"\Apple"+"{"+str(apple[0])+"}{"+str(apple[1])+"}\n")
#     fileTex.write(r'\end{tikzpicture}'+'\n')
#     fileTex.write(r'\end{document}'+'\n')
#     fileTex.close()

file.close()