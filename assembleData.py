import json
import os


def insertComma(fileName):
   fileName.write(' , ')

def writetoFile(fileName,data):
   fileName.write(str(data))
   insertComma(fileName)

counter = 0
trainingData = open('training.csv','w+')
smallConst = 1e-15   #Don't divide by zero

trainingData.write('matchID, particpantID, Win, FirstBlood, FirstBloodAssist, firstTower, firstTowerAssist, Kills, Assists, Deaths, GoldEarned, GoldSpent, TotalDamageDealt, MagicDamageDealt, PhysicalDamageDealt, TotalDamageTaken, MinionsKilled, CrowdControl, WardsPlaced\n')

for f in os.listdir('dump'):
   if f.find('json') != -1:

      json_data = open('dump/'+f)
      data = json.load(json_data)
      json_data.close()

      if len(data['participants']) == 10:  #verify valid game with all players
         counter += 1

         teamKills = [smallConst,smallConst]
         teamAssists = [smallConst,smallConst]
         teamDeaths = [smallConst,smallConst]
         teamGoldEarned = [smallConst, smallConst]
         teamGoldSpent = [smallConst, smallConst]
         teamDamageDealt = [smallConst, smallConst]
         teamMagicDamageDealt = [smallConst, smallConst]
         teamPhysicalDamageDealt = [smallConst, smallConst]
         teamTotalDamageTaken = [smallConst, smallConst]
         teamMinionsKilled = [smallConst, smallConst]
         teamCrowdControl= [smallConst, smallConst]
         teamWards = [smallConst, smallConst]

         for i in range(0,10): # summing loop for normalization
            stats = data['participants'][i]['stats']
            if data['participants'][i]['teamId'] == data['teams'][0]['teamId']:  #team 0
               teamKills[0] += stats['kills']
               teamAssists[0] += stats['assists']
               teamDeaths[0] += stats['deaths']
               teamGoldEarned[0] += stats['goldEarned']
               teamGoldSpent[0] += stats['goldSpent']
               teamDamageDealt[0] += stats['totalDamageDealt']
               teamMagicDamageDealt[0] += stats['magicDamageDealt']
               teamPhysicalDamageDealt[0] += stats['physicalDamageDealt']
               teamTotalDamageTaken[0] += stats['totalDamageTaken']
               teamMinionsKilled[0] += stats['minionsKilled']
               teamCrowdControl[0] += stats['totalTimeCrowdControlDealt']
               teamWards[0] += stats['wardsPlaced']

            else: # team 1
               teamKills[1] += stats['kills']
               teamAssists[1] += stats['assists']
               teamDeaths[1] += stats['deaths']
               teamGoldEarned[1] += stats['goldEarned']
               teamGoldSpent[1] += stats['goldSpent']
               teamDamageDealt[1] += stats['totalDamageDealt']
               teamMagicDamageDealt[1] += stats['magicDamageDealtToChampions']
               teamPhysicalDamageDealt[1] += stats['physicalDamageDealt']
               teamTotalDamageTaken[1] += stats['totalDamageTaken']
               teamMinionsKilled[1] += stats['minionsKilled']
               teamCrowdControl[1] += stats['totalTimeCrowdControlDealt']
               teamWards[1] += stats['wardsPlaced']

         for i in range(0,10):  # printing loop


            teamID = 0 if data['participants'][i]['teamId'] == data['teams'][0]['teamId'] else 1
            stats = data['participants'][i]['stats']

            # General Info -- not used for clustering
            writetoFile(trainingData,data['matchId'])
            writetoFile(trainingData,data['participantIdentities'][i]['participantId'])

            # Booleans -- NOT NORMALIZED
            writetoFile(trainingData,int(data['teams'][teamID]['winner']))
            writetoFile(trainingData,int(stats['firstBloodKill']))
            writetoFile(trainingData,int(stats['firstBloodAssist']))
            writetoFile(trainingData,int(stats['firstTowerKill']))
            writetoFile(trainingData,int(stats['firstTowerAssist']))


            writetoFile(trainingData, stats['kills']/teamKills[teamID])
            writetoFile(trainingData, stats['assists']/teamAssists[teamID])
            writetoFile(trainingData, stats['deaths']/teamDeaths[teamID])
            writetoFile(trainingData, stats['goldEarned']/teamGoldEarned[teamID])
            writetoFile(trainingData, stats['goldSpent']/teamGoldSpent[teamID])
            writetoFile(trainingData, stats['totalDamageDealt']/teamDamageDealt[teamID])
            writetoFile(trainingData, stats['magicDamageDealt']/teamMagicDamageDealt[teamID])
            writetoFile(trainingData, stats['physicalDamageDealt']/teamMagicDamageDealt[teamID])
            writetoFile(trainingData, stats['totalDamageTaken']/teamTotalDamageTaken[teamID])
            writetoFile(trainingData, stats['minionsKilled']/teamMinionsKilled[teamID])
            writetoFile(trainingData, stats['totalTimeCrowdControlDealt']/teamCrowdControl[teamID])
            writetoFile(trainingData, stats['wardsPlaced']/teamWards[teamID])

            trainingData.write('\n')

      if counter>100:
         exit(-1)
