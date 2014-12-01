import json
import os

def insertComma(fileName):
   fileName.write(' , ')

def writetoFile(fileName,data):
   fileName.write(str(data))
   insertComma(fileName)

DUMP_DIR = '../../dump/'
counter = 0
trainingData = open('training_full_v2.csv','w+')
smallConst = 1e-15   #Don't divide by zero

labels = """
         Win, FirstBlood, FirstTower, FirstTowerAssist, Kills, Assists,
         Deaths, GoldEarned, TotalDamageDealt, MagicDamageDealt, PhysicalDamageDealt, 
         TotalDamageDealtToChampions, TotalDamageTaken, MinionsKilled, NeutralMinionsKilled, 
         CrowdControl, WardsPlaced, TowerKills, LargestMultiKill, LargestKillingSpree, LargestCritStrike, TotalHealAmount\n
         """

trainingData.write(labels)

for f in os.listdir(DUMP_DIR):
   if f.find('json') != -1:

      json_data = open(DUMP_DIR+f)
      data = json.load(json_data)
      json_data.close()

      if len(data['participants']) == 10:  #verify valid game with all players
         counter += 1

         teamKills = [smallConst,smallConst]
         teamAssists = [smallConst,smallConst]
         teamDeaths = [smallConst,smallConst]
         teamGoldEarned = [smallConst, smallConst]
         # teamGoldSpent = [smallConst, smallConst]
         teamDamageDealt = [smallConst, smallConst]
         teamMagicDamageDealt = [smallConst, smallConst]
         teamPhysicalDamageDealt = [smallConst, smallConst]
         teamDamageDealtToChampions = [smallConst, smallConst]
         teamTotalDamageTaken = [smallConst, smallConst]
         teamMinionsKilled = [smallConst, smallConst]
         teamNeutralMinionsKilled = [smallConst, smallConst]
         teamCrowdControl= [smallConst, smallConst]
         teamWards = [smallConst, smallConst]
         teamTowerKills = [smallConst, smallConst]
         teamLargestMultiKill = [smallConst, smallConst] # tracks largest
         teamLargestKillingSpree = [smallConst, smallConst] # tracks largest
         teamLargestCriticalStrike = [smallConst, smallConst] # tracks largest
         teamTotalHealAmount = [smallConst, smallConst]

         for i in range(0,10): # summing loop for normalization
            stats = data['participants'][i]['stats']
            if data['participants'][i]['teamId'] == data['teams'][0]['teamId']:  #team 0
               teamKills[0] += stats['kills']
               teamAssists[0] += stats['assists']
               teamDeaths[0] += stats['deaths']
               teamGoldEarned[0] += stats['goldEarned']
               # teamGoldSpent[0] += stats['goldSpent']
               teamDamageDealt[0] += stats['totalDamageDealt']
               teamMagicDamageDealt[0] += stats['magicDamageDealt']
               teamPhysicalDamageDealt[0] += stats['physicalDamageDealt']
               teamDamageDealtToChampions[0] += stats['totalDamageDealtToChampions']
               teamTotalDamageTaken[0] += stats['totalDamageTaken']
               teamMinionsKilled[0] += stats['minionsKilled']
               teamNeutralMinionsKilled[0] += stats['neutralMinionsKilled']
               teamCrowdControl[0] += stats['totalTimeCrowdControlDealt']
               teamWards[0] += stats['wardsPlaced']
               teamTowerKills[0] += stats['towerKills']

               if teamLargestMultiKill[0] < stats['largestMultiKill']: 
                  teamLargestMultiKill[0] = stats['largestMultiKill']

               if teamLargestKillingSpree[0] < stats['largestKillingSpree']:
                  teamLargestKillingSpree[0] = stats['largestKillingSpree']

               if teamLargestCriticalStrike[0] < stats['largestCriticalStrike']:
                  teamLargestCriticalStrike[0] = stats['largestCriticalStrike']

               teamTotalHealAmount[0] += stats['totalHeal']

            else: # team 1
               teamKills[1] += stats['kills']
               teamAssists[1] += stats['assists']
               teamDeaths[1] += stats['deaths']
               teamGoldEarned[1] += stats['goldEarned']
               # teamGoldSpent[1] += stats['goldSpent']
               teamDamageDealt[1] += stats['totalDamageDealt']
               teamMagicDamageDealt[1] += stats['magicDamageDealt']
               teamPhysicalDamageDealt[1] += stats['physicalDamageDealt']
               teamDamageDealtToChampions[1] += stats['totalDamageDealtToChampions']
               teamTotalDamageTaken[1] += stats['totalDamageTaken']
               teamMinionsKilled[1] += stats['minionsKilled']
               teamNeutralMinionsKilled[1] += stats['neutralMinionsKilled']
               teamCrowdControl[1] += stats['totalTimeCrowdControlDealt']
               teamWards[1] += stats['wardsPlaced']
               teamTowerKills[1] += stats['towerKills']

               if teamLargestMultiKill[1] < stats['largestMultiKill']: 
                  teamLargestMultiKill[1] = stats['largestMultiKill']

               if teamLargestKillingSpree[1] < stats['largestKillingSpree']:
                  teamLargestKillingSpree[1] = stats['largestKillingSpree']

               if teamLargestCriticalStrike[1] < stats['largestCriticalStrike']:
                  teamLargestCriticalStrike[1] = stats['largestCriticalStrike']

               teamTotalHealAmount[1] += stats['totalHeal']

         for i in range(0,10):  # printing loop


            teamID = 0 if data['participants'][i]['teamId'] == data['teams'][0]['teamId'] else 1
            stats = data['participants'][i]['stats']

            # General Info -- not used for clustering
            #writetoFile(trainingData,data['matchId'])
            #writetoFile(trainingData,data['participantIdentities'][i]['participantId'])

            # Booleans -- NOT NORMALIZED
            writetoFile(trainingData,int(data['teams'][teamID]['winner']))
            if stats.has_key('firstBloodKill'):
               writetoFile(trainingData,int(stats['firstBloodKill']))
               #writetoFile(trainingData,int(stats['firstBloodAssist']))   not working
            else:
               writetoFile(trainingData, 0)
               #writetoFile(trainingData, 0)

            writetoFile(trainingData,int(stats['firstTowerKill']))
            writetoFile(trainingData,int(stats['firstTowerAssist']))

            writetoFile(trainingData, stats['kills']/teamKills[teamID])
            writetoFile(trainingData, stats['assists']/teamAssists[teamID])
            writetoFile(trainingData, stats['deaths']/teamDeaths[teamID])
            writetoFile(trainingData, stats['goldEarned']/teamGoldEarned[teamID])
            # writetoFile(trainingData, stats['goldSpent']/teamGoldSpent[teamID])
            writetoFile(trainingData, stats['totalDamageDealt']/teamDamageDealt[teamID])
            writetoFile(trainingData, stats['magicDamageDealt']/teamMagicDamageDealt[teamID])
            writetoFile(trainingData, stats['physicalDamageDealt']/teamMagicDamageDealt[teamID])
            writetoFile(trainingData, stats['totalDamageDealtToChampions']/teamDamageDealtToChampions[teamID])
            writetoFile(trainingData, stats['totalDamageTaken']/teamTotalDamageTaken[teamID])
            writetoFile(trainingData, stats['minionsKilled']/teamMinionsKilled[teamID])
            writetoFile(trainingData, stats['neutralMinionsKilled'/teamNeutralMinionsKilled[teamID]])
            writetoFile(trainingData, stats['totalTimeCrowdControlDealt']/teamCrowdControl[teamID])
            writetoFile(trainingData, stats['wardsPlaced']/teamWards[teamID])
            writetoFile(trainingData, stats['towerKills']/teamTowerKills[teamID])
            writetoFile(trainingData, stats['largestMultiKill']/teamLargestMultiKill[teamID])
            writetoFile(trainingData, stats['largestKillingSpree']/teamLargestKillingSpree[teamID])
            writetoFile(trainingData, stats['largestCriticalStrike']/teamLargestCriticalStrike[teamID])
            writetoFile(trainingData, stats['totalHeal']/teamTotalHealAmount[teamID])

            trainingData.write('\n')
            #print counter
