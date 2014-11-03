import rawpi
import json
import time

startingMatchId = 1515876
nMatches = 1000

def isValid(match):
    if match.status_code != 200:
        return False
    return True

def isClassicMatch(match):
    j = match.json()
    return j['matchMode'] == "CLASSIC"

def rateLimitExceeded(match):
    if int(match.status_code) == 429:
        return True
    return False

region = "na"
counter = 0
i = 0
while counter < nMatches:
    try:
        m = rawpi.get_match(region, i+startingMatchId, True)
        if not rateLimitExceeded(m):
            if isValid(m) and isClassicMatch(m):
                try:
                    f = open("dump/"+str(i+startingMatchId)+".json", 'w+')
                    f.write(m.text)
                    counter += 1
                    print(counter)
                except:
                    pass
            i += 1
        else:
            print("sleeping")
            time.sleep(10)
    except:
        pass