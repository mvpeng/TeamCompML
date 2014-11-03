import os
import json
import requests
__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))

# THIS HANDLES NO ERRORS AND IS JUST A RAW CONNECTION TO THE LOL API;
# USE THE API MODULE TO GET ERROR FALLBACK METHODS

with open(os.path.join(__location__, 'config'), 'r') as f:
    try:
        config = json.load(f)
    except ValueError:
        config = {'key': ""}

KEY = config["key"]
GLOBAL_ENDPOINT = "https://global.api.pvp.net/api/lol/static-data/{}/"
REGION_ENDPOINT = "https://{0}.api.pvp.net/api/lol/{0}/"


def set_api_key(key):
    global KEY
    with open('config', 'w') as f:
        json.dump({"key": key}, f)
    KEY = key


# CHAMPION-v1.2


def get_champions(region, freetoplay="false"):
    """
    Retrieve all champions.
    """
    return requests.get(
        (REGION_ENDPOINT + "v1.2/champion?freeToPlay={1}&api_key={2}").
        format(region, freetoplay, KEY))


def get_champion(region, championId):
    """
    Retrieve champion by ID.
    """
    return requests.get(
        (REGION_ENDPOINT + "v1.2/champion/{1}?api_key={2}").
        format(region, championId, KEY))

# GAME-v1.3


def get_recent_games(region, summonerId):
    """
    Get recent games by summoner ID.
    """
    return requests.get(
        (REGION_ENDPOINT + "v1.3/game/by-summoner/{1}/recent?api_key={2}").
        format(region, summonerId, KEY))

# LEAGUE-v2.5


def get_league(region, summonerIds):
    """
    Get leagues mapped by summoner ID for a given list of summoner IDs.
    """
    return requests.get(
        (REGION_ENDPOINT + "v2.5/league/by-summoner/{1}?api_key={2}").
        format(region, summonerIds, KEY))


def get_league_entry(region, summonerIds):
    """
    Get league entries mapped by summoner ID
    for a given list of summoner IDs.
    """
    return requests.get(
        (REGION_ENDPOINT + "v2.5/league/by-summoner/{1}/entry?api_key={2}").
        format(region, summonerIds, KEY))


def get_league_by_team(region, teamIds):
    """
    Get leagues mapped by team ID for a given list of team IDs.
    """
    return requests.get(
        (REGION_ENDPOINT + "v2.5/league/by-team/{1}?api_key={2}").
        format(region, teamIds, KEY))


def get_league_entry_by_team(region, teamIds):
    """
    Get league entries by team ID for a given list of team IDs.
    """
    return requests.get(
        (REGION_ENDPOINT + "v2.5/league/by-team/{1}?api_key={2}").
        format(region, teamIds, KEY))


def get_challenger_league_tiers(region, queuetype):
    """
    Get challenger tier leagues.
    """
    return requests.get(
        (REGION_ENDPOINT + "v2.5/league/challenger?type={1}&api_key={2}").
        format(region, queuetype, KEY))

# LOL-STATIC-DATA-v1.2


def get_champion_list(
        region, locale="", version="",
        dataById="", champData=""):
    """
    Retrieves champion list.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/champion?locale={1}&version={2}"
         "&dataById={3}&champData={4}&api_key={5}").
        format(region, locale, version, dataById, champData, KEY))


def get_champion_list_by_id(
        region, championId, locale="", version="", champData=""):
    """
    Retrieves a champion by its id.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/champion/{1}?locale={2}"
         "&version={3}&champData={4}&api_key={5}")
        .format(region, championId, locale, version, champData, KEY))


def get_item_list(
        region, locale="", version="", itemListData=""):
    """
    Retrieves item list.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/item?locale={1}&version={2}"
         "&itemListData={3}&api_key={4}").
        format(region, locale, version, itemListData, KEY))


def get_item_list_by_id(
        region, itemId, locale="", version="", itemData=""):
    """
    Retrieves item by its unique id.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/item/{1}?locale={2}"
         "&version={3}&itemData={4}&api_key={5}")
        .format(region, itemId, locale, version, itemData, KEY))


def get_mastery_list(
        region, locale="", version="", masteryListData=""):
    """
    Retrieves mastery list.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/mastery?locale={1}&version={2}"
         "&masteryListData={3}&api_key={4}").
        format(region, locale, version, masteryListData, KEY))


def get_mastery_list_by_id(
        region, masteryId, locale="", version="", masteryData=""):
    """
    Retrieves mastery item by its unique id.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/item/{1}?locale={2}"
         "&version={3}&masteryData={4}&api_key={5}")
        .format(region, masteryId, locale, version, masteryData, KEY))


def get_realm_data(region):
    """
    Retrieves realm data.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/realm?api_key={1}").
        format(region, KEY))


def get_rune_list(region, locale="", version="", runeListData=""):
    """
    Retrieves rune list.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/rune?locale={1}&version={2}"
         "&runeListData={3}&api_key={4}").
        format(region, locale, version, runeListData, KEY))


def get_rune_list_by_id(
        region, runeId, locale="", version="", runeData=""):
    """
    Retrieves rune by its unique id.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/rune/{}?locale={1}"
         "&version={2}&runeData={3}&api_key={4}")
        .format(region, runeId, locale, version, runeData, KEY))


def get_spell_list(
        region, locale="", version="",
        dataById="", spellData=""):
    """
    Retrieves summoner spell list.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/summoner-spell?locale={1}&version={2}"
         "&dataById={3}&spellData={4}&api_key={5}").
        format(region, locale, version, dataById, spellData, KEY))


def get_spell_list_by_id(
        region, spellId, locale="", version="", spellData=""):
    """
    Retrieves summoner spell by its unique id.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/summoner-spell/{1}?locale={2}"
         "&version={3}&spellData={4}&api_key={5}")
        .format(region, spellId, locale, version, spellData, KEY))


def get_version_data(region):
    """
    Retrieves version data.
    """
    return requests.get(
        (GLOBAL_ENDPOINT + "v1.2/versions?api_key={1}").
        format(region, KEY))

# LOL-STATUS-v1.0


def get_shards():
    """
    Get shard list.
    """
    return requests.get("http://status.leagueoflegends.com/shards")


def get_shard_status(region):
    """
    Get shard status.
    Returns the data available on the status.leagueoflegends.com website
    for given region.
    """
    return requests.get("http://status.leagueoflegends.com/shards/{}"
                        .format(region))

# MATCH-v2.2


def get_match(region, matchId, includeTimeline):
    """
    Retrieve match by match ID.
    """
    return requests.get(
        (REGION_ENDPOINT + "v2.2/match/{1}?"
         "api_key={2}&includeTimeline={3}").
        format(region, matchId, KEY, includeTimeline))

# MATCHHISTORY-v2.2


def get_matchhistory(region, summonerId):
    """
    Retrieve match history by summoner ID.
    """
    return requests.get(
        (REGION_ENDPOINT + "v2.2/matchhistory/{1}?"
         "api_key={2}").
        format(region, summonerId, KEY))

# STATS-v1.3


def get_ranked_stats(region, summonerId, season=""):
    """
    Get ranked stats by summoner ID.
    """
    return requests.get(
        (REGION_ENDPOINT + "v1.3/stats/by-summoner/{1}/ranked?"
         "api_key={2}&season={3}").
        format(region, summonerId, KEY, season))


def get_stats(region, summonerId, season=""):
    """
    Get player stats summaries by summoner ID.
    """
    return requests.get(
        (REGION_ENDPOINT +
         "v1.3/stats/by-summoner/{1}/summary?api_key={2}&season={3}").
        format(region, summonerId, KEY, season))

# SUMMONER-v1.4


def get_summoner_by_name(region, summonerNames):
    """
    Get summoner objects mapped by standardized summoner name
    for a given list of summoner names.
    """
    return requests.get(
        (REGION_ENDPOINT + "v1.4/summoner/by-name/{1}?&api_key={2}").
        format(region, summonerNames, KEY))


def get_summoner_by_id(region, summonerIds):
    """
    Get summoner objects mapped by summoner ID
    for a given list of summoner IDs.
    """
    return requests.get(
        (REGION_ENDPOINT + "v1.4/summoner/{1}?api_key={2}").
        format(region, summonerIds, KEY))


def get_masteries(region, summonerIds):
    """
    Get mastery pages mapped by summoner ID
    for a given list of summoner IDs.
    """
    return requests.get(
        (REGION_ENDPOINT + "v1.4/summoner/{1}/masteries?api_key={2}").
        format(region, summonerIds, KEY))


def get_name(region, summonerIds):
    """
    Get summoner names mapped by summoner ID
    for a given list of summoner IDs.
    """
    return requests.get(
        (REGION_ENDPOINT + "v1.4/summoner/{1}/name?api_key={2}").
        format(region, summonerIds, KEY))


def get_runes(region, summonerIds):
    """
    Get rune pages mapped by summoner ID
    for a given list of summoner IDs.
    """
    return requests.get(
        (REGION_ENDPOINT + "v1.4/summoner/{1}/runes?api_key={2}").
        format(region, summonerIds, KEY))

# TEAM-v2.4


def get_teams_by_summonerid(region, summonerIds):
    """
    Get teams mapped by summoner ID
    for a given list of summoner IDs.
    """
    return requests.get(
        (REGION_ENDPOINT + "v2.4/team/by-summoner/{1}?api_key={2}").
        format(region, summonerIds, KEY))


def get_teams(region, teamIds):
    """
    Get teams mapped by team ID
    for a given list of team IDs.
    """
    return requests.get(
        (REGION_ENDPOINT + "v2.4/team/{1}?api_key={2}").
        format(region, teamIds, KEY))
