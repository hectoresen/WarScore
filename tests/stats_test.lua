-- Isolated Lua 5.1 regression tests for pure statistics and native API adapters.
local namespace = {}
assert(loadfile("addon/WarScore/Core/Stats.lua"))("WarScore", namespace)
local stats = namespace.Stats
local assertions = 0
local function eq(actual, expected, label)
    assertions = assertions + 1
    if actual ~= expected then
        error((label or "assert") .. ": expected " .. tostring(expected) ..
            ", got " .. tostring(actual))
    end
end

eq(stats.Parse("1.234"), 1234, "Spanish thousands")
eq(stats.Parse("1,234"), 1234, "English thousands")
eq(stats.Parse("--"), nil, "missing statistics")
eq(stats.Parse(""), nil, "empty")
eq(stats.Parse(42), 42, "numeric input")
eq(stats.Ratio(32, 8), 4, "HK/D")
eq(stats.Ratio(1, 0), nil, "zero denominator")
eq(stats.Ratio(nil, 5), nil, "missing numerator")
eq(stats.Percent(2, 5), 40, "winrate")
eq(stats.Percent(1, 0), nil, "invalid winrate")

local favorite, played, tied = stats.FavoriteBattleground({ [52] = 7, [53] = 2 })
eq(favorite, "Garganta Grito de Guerra", "favorite BG")
eq(played, 7, "favorite count")
eq(tied, false, "not tied")
favorite, played, tied = stats.FavoriteBattleground({ [52] = 7, [53] = 7 })
eq(favorite, "Empate", "tie explicitly indicated")
eq(played, 7, "tie count")
eq(tied, true, "tie flag")

local values = { [588] = "92", [1501] = "14", [319] = "--",
                 [320] = "--", [839] = "1", [840] = "--", [52] = "1" }
_G.GetStatistic = function(id) return values[id] or "--" end
_G.C_CurrencyInfo = {
    GetCurrencyListSize = function() return 2 end,
    GetCurrencyListInfo = function(index)
        if index == 2 then
            return { currencyTypesID = 1792, quantity = 252, maxQuantity = 25000 }
        end
        return { currencyTypesID = 123 }
    end,
}
_G.C_MajorFactions = {
    GetMajorFactionProgressionInfo = function(id)
        eq(id, 2800, "native rank ID")
        return { renownLevel = 2, renownReputationEarned = 25,
                 renownLevelThreshold = 750, maxLevel = 14 }
    end,
}
local data = stats.ReadHistorical()
eq(data.honorableKills, 92, "native HK")
eq(data.pvpDeaths, 14, "native PvP deaths")
eq(data.honorCurrent, 252, "honor currency")
eq(data.honorMaximum, 25000, "honor cap")
eq(data.pvpRank, 2, "rank")
eq(data.pvpRankPoints, 25, "rank points")
eq(data.pvpRankThreshold, 750, "next rank threshold")
eq(data.duelsWon, 0, "documented no-duels semantics")
eq(data.duelWinRate, nil, "no duel winrate without duels")
eq(data.bgWinRate, nil, "unknown BG wins remain unknown")
eq(data.favoriteBattleground, "Garganta Grito de Guerra", "BG favorite read")

_G.GetStatistic = function(id) if id == 588 then return "--" end return "0" end
_G.GetPVPLifetimeStats = function() return 34 end
_G.C_CurrencyInfo = nil
_G.C_MajorFactions = nil
data = stats.ReadHistorical()
eq(data.honorableKills, 34, "HK fallback")
eq(data.honorCurrent, nil, "missing currency")
eq(data.pvpRank, nil, "missing rank")
eq(data.hkDeathRatio, nil, "zero deaths")

print("PASS: " .. assertions .. " Lua 5.1 stats regression assertions")
