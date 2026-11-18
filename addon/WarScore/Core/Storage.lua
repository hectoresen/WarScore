local _, ns = ...
ns.Storage = {}

-- Solo snapshots locales; nunca reconstruir supuestos históricos.
function ns.Storage.GetDB()
    return WarScoreDB
end
