local _, ns = ...
ns.Stats = {}

function ns.Stats.Ratio(numerator, deaths)
    if type(numerator) ~= "number" or type(deaths) ~= "number" or deaths <= 0 then
        return nil
    end
    return numerator / deaths
end

-- TODO: investigar y conectar IDs históricos reales de Forever.
function ns.Stats.ReadHistorical()
    return {
        honorableKills = nil,
        killingBlows = nil,
        pvpDeaths = nil,
    }
end
