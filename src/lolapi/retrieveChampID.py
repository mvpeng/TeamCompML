import json
import os

def writetoFile(fileName,data):
   fileName.write(str(data))

DUMP_DIR = '../../dump/'
counter = 0
championIDs = open('championIDs.csv','w+')
smallConst = 1e-15   #Don't divide by zero

for f in os.listdir(DUMP_DIR):
   if f.find('json') != -1:
      json_data = open(DUMP_DIR+f)
      data = json.load(json_data)
      json_data.close()

      if len(data['participants']) == 10:  #verify valid game with all players
         counter += 1
         for i in range(0,10):  # printing loop
            participant = data['participants'][i]
            writetoFile(championIDs,participant['championId'])
            writetoFile(championIDs,'\n')
