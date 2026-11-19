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

    -- Forever honor is currency 1792 (not the obsolete UnitHonor balance).
    -- The currency list API accepts an INDEX; find the target by currency ID.
    local honor, honorMax
    local currencyAPI = C_CurrencyInfo
    local sizeFn = currencyAPI and currencyAPI.GetCurrencyListSize
    local infoFn = currencyAPI and currencyAPI.GetCurrencyListInfo
    if type(sizeFn) == "function" and type(infoFn) == "function" then
        local ok, count = pcall(sizeFn)
        if ok and type(count) == "number" and count >= 0 then
            for index = 1, math.min(math.floor(count), 1000) do
                local readOk, info = pcall(infoFn, index)
                if readOk and type(info) == "table"
                    and (tonumber(info.currencyTypesID) == 1792
                        or tonumber(info.currencyID) == 1792) then
                    local amount = tonumber(info.quantity or info.count)
                    local maximum = tonumber(info.maxQuantity)
                    if amount and amount >= 0 then
                        honor = amount
                        if maximum and maximum > 0 then honorMax = maximum end
                    end
                    break
                end
            end
        end
    end

    -- Forever PvP ranks are Major Faction 2800, not legacy UnitPVPRank.
    -- The renown level is the current rank; the earned value is progress
    -- toward its renownLevelThreshold. A zero level is an unranked character.
    local rankLevel, rankPoints, rankThreshold, rankMaxLevel
    local majorAPI = C_MajorFactions
    if majorAPI and type(majorAPI.GetMajorFactionProgressionInfo) == "function" then
        local ok, info = pcall(majorAPI.GetMajorFactionProgressionInfo, 2800)
        if ok and type(info) == "table" then
            local level = tonumber(info.renownLevel)
            local earned = tonumber(info.renownReputationEarned)
            local threshold = tonumber(info.renownLevelThreshold)
            local maximum = tonumber(info.maxLevel)
            if level and level >= 0 then rankLevel = math.floor(level) end
            if earned and earned >= 0 then rankPoints = earned end
            if threshold and threshold > 0 then rankThreshold = threshold end
            if maximum and maximum > 0 then rankMaxLevel = math.floor(maximum) end
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
        honorMaximum = honorMax,
        pvpDeaths = deaths,
        hkDeathRatio = ns.Stats.Ratio(hk, deaths),
        killingBlows = nil,
        kbDeathRatio = nil, -- 1487 is not validated as PvP-only
        pvpRank = rankLevel,
        pvpRankPoints = rankPoints,
        pvpRankThreshold = rankThreshold,
        pvpRankMaxLevel = rankMaxLevel,
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
