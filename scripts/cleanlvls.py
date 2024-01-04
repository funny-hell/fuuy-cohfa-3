# Remove levels that aren't in map.csv (warning, very slow!)

import os

map_path = "../data/map.csv"
map_file = open(map_path, "r")
map_data = map_file.read()
map_file.close()

for filename in os.listdir("../tilemaps"):
    lvlname = filename.removesuffix(".lvl")
    
    canidates = [str(lvlname + ','), str(',' + lvlname), str(lvlname + '\n'), str('\n' + lvlname)]
    
    found = False
    
    for c in canidates:
        found = found or c in map_data
        
    if not found:
        os.remove("../tilemaps/" + filename)