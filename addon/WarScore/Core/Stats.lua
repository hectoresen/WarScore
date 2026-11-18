local _, ns = ...
ns.Stats = {}

local BG = {
    { id = 53, name = "Valle de Alterac" },
    { id = 55, name = "Cuenca de Arathi" },
    { id = 52, name = "Garganta Grito de Guerra" },
    { id = 64179, name = "Islas Lanza Negra" },
}

function ns.Stats.Parse(value)
    if type(value) == "number" then return value end
    if type(value) ~= "string" or value == "" or value == "--" then return nil end
    local cleaned = value:gsub("[%s,%.]", "")
    return tonumber(cleaned)
end

function ns.Stats.Ratio(numerator, denominator)
    if type(numerator) ~= "number" or type(denominator) ~= "number" or denominator <= 0 then return nil end
    return numerator / denominator
end

function ns.Stats.Percent(numerator, denominator)
    local ratio = ns.Stats.Ratio(numerator, denominator)
    return ratio and ratio * 100 or nil
end

local function read(id)
    if type(GetStatistic) ~= "function" then return nil end
    local ok, result = pcall(GetStatistic, id)
    return ok and ns.Stats.Parse(result) or nil
end

local function zeroIfNoActivity(value)
    -- Only duels 319/320 have been compared against the native zero-activity panel.
    return value or 0
end

function ns.Stats.FavoriteBattleground(values)
    local highest, chosen, tied = 0, nil, false
    for _, bg in ipairs(BG) do
        local value = values[bg.id]
        if type(value) == "number" and value > highest then
            highest, chosen, tied = value, bg.name, false
        elseif type(value) == "number" and value > 0 and value == highest then
            tied = true
        end
    end
    if tied then return "Empate", highest, true end
    return chosen, chosen and highest or nil, false
end

function ns.Stats.ReadHistorical()
    local hk = read(588)
    if hk == nil and type(GetPVPLifetimeStats) == "function" then
        local ok, lifetime = pcall(GetPVPLifetimeStats)
        if ok then hk = ns.Stats.Parse(lifetime) end
    end

    -- Current spendable honor, not lifetime honor earned. Confirmed by
    -- /wsdiag honor on Forever; nil when the API cannot be read safely.
    local honor
    if type(UnitHonor) == "function" then
        local ok, current = pcall(UnitHonor, "player")
        if ok and type(current) == "number" and current >= 0 then
            honor = current
        end
    end

    local deaths = read(1501)
    local duelsWon = zeroIfNoActivity(read(319))
    local duelsLost = zeroIfNoActivity(read(320))
    local bgPlayed, bgWon = read(839), read(840)
    local byBg = {}
    for _, bg in ipairs(BG) do byBg[bg.id] = read(bg.id) end
    local favorite, favoritePlayed, tied = ns.Stats.FavoriteBattleground(byBg)

    return {
        honorableKills = hk,
        honorCurrent = honor,
        pvpDeaths = deaths,
        hkDeathRatio = ns.Stats.Ratio(hk, deaths),
        killingBlows = nil,
        kbDeathRatio = nil, -- 1487 is not validated as PvP-only
        pvpRank = nil, -- rank source not yet validated
        duelsWon = duelsWon,
        duelsLost = duelsLost,
        duelWinRate = ns.Stats.Percent(duelsWon, duelsWon + duelsLost),
        battlegroundsPlayed = bgPlayed,
        battlegroundsWon = bgWon,
        bgWinRate = ns.Stats.Percent(bgWon, bgPlayed),
        favoriteBattleground = favorite,
        favoriteBattlegroundPlayed = favoritePlayed,
        favoriteBattlegroundTied = tied,
    }
end
