import rawpi
import json
import time


# Constants
STARTING_MATCH_ID = 1517866989
N_MATCHES = 10000
REGION = "na"
STATUS_OK = 200
STATUS_RATE_LIMIT_EXCEEDED = 429


def isValid(match):
    if match.status_code != STATUS_OK:
        return False
    return True

def isClassicMatch(match):
    j = match.json()
    return j['matchMode'] == "CLASSIC"

def rateLimitExceeded(match):
    if int(match.status_code) == STATUS_RATE_LIMIT_EXCEEDED:
        return True
    return False


counter = 0
i = 0
while counter < N_MATCHES:
    try: # get_match might have a connection time-out
        m = rawpi.get_match(REGION, i + STARTING_MATCH_ID, True)
        if not rateLimitExceeded(m):
            if isValid(m) and isClassicMatch(m):
                try:
                    f = open("dump/"+str(i + STARTING_MATCH_ID)+".json", 'w+')
                    f.write(m.text)
                    counter += 1
                    print(counter)
                    f.close()
                except:
                    pass
            i += 1
        else:
            print("sleeping")
            time.sleep(10)
    except:
        pass