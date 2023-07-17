#!/usr/bin/python3

import re

file=open("Data")
filestr=file.read()

obj=eval(filestr)

mapId=0
for map in obj:
    mapId=mapId+1
    fileTex=open("Map{:02d}.tex".format(mapId),'w+')
    fileTex.write(r'\documentclass{xMap}'+'\n\n')
    fileTex.write(r'\begin{document}'+'\n')
    fileTex.write(r'\begin{tikzpicture}'+'\n')
    i=0
    for blockLine in map[0]:
        j=0
        for block in blockLine:
            fileTex.write(r"\Block"+block[2:5]+"{"+str(i)+"}"+"{"+str(j)+"}\n")
            j+=1
        i+=1

    fileTex.write(r"\MainCht"+"{"+str(map[1][0])+"}{"+str(map[1][1])+"}\n")
    for apple in map[2]:
        fileTex.write(r"\Apple"+"{"+str(apple[0])+"}{"+str(apple[1])+"}\n")
    fileTex.write(r'\end{tikzpicture}'+'\n')
    fileTex.write(r'\end{document}'+'\n')
    fileTex.close()

file.close()