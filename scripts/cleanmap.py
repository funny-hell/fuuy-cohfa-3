# Remove levels that don't actually exist from map.csv

import os
import csv

map_path = '../data/map.csv'
nmap_path = '../data/nmap.csv'
extracted_path = 'C:/Program Files (x86)/Steam/steamapps/common/theendisnigh/extracted/'

map_file = open(map_path, 'r')
map_csv = csv.reader(map_file)

nmap_file = open(nmap_path, 'w')
nmap_csv = csv.writer(nmap_file)

for row in map_csv:
    nrow = []
    
    for column in row:
        foo = column
        
        if foo == '..':
            nrow.append(str('..'))
            continue
        if foo == '':
            nrow.append('')
            continue
        
        if not foo.endswith('.lvl'):
            foo += '.lvl'
        
        if os.path.exists('../tilemaps/' + foo) or os.path.exists(extracted_path + 'tilemaps/' + foo):
            nrow.append(str(column))
        else:
            nrow.append('')
        
    print(nrow)
    nmap_csv.writerow(nrow)

nmap_file.close()
map_file.close()