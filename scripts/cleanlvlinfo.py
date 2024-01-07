# Remove levels that don't actually exist from levelinfo.txt.append

import os

inf_path = "../data/levelinfo.txt.append"
ninf_path = "../data/nlevelinfo.txt.append"

inf_file = open(inf_path, "r")
inf_str = inf_file.read()
inf_file.close()

inf_array = inf_str.split('\n')
ninf_array = []

for i in range(len(inf_array)):
    
    if len(inf_array[i].strip()) < 1:
        ninf_array.append(inf_array[i])
        continue
    
    if inf_array[i].strip()[0] == '#':
        ninf_array.append(inf_array[i])
        continue
    
    inf_file = inf_array[i].split('"')[1]
    
    inf_file = "../tilemaps/" + inf_file + ".lvl"
    
    if os.path.exists(inf_file):
        ninf_array.append(inf_array[i])

ninf_str = "\n".join(ninf_array)
ninf_file = open(ninf_path, "w")
ninf_file.write(ninf_str)
ninf_file.close()