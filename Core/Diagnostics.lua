local addonName, ns = ...
local function output(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cffd8b365WarScore|r " .. tostring(message))
end

local function inspect(label, fn, ...)
    if type(fn) ~= "function" then
        output(label .. ": API no disponible")
        return
    end
    local args = { ... }
    local ok, a, b, c, d = pcall(function()
        return fn(unpack(args))
    end)
    if not ok then
        output(label .. ": ERROR " .. tostring(a))
        return
    end
    local function show(value)
        if value == nil then return "nil" end
        return tostring(value)
    end
    output(label .. ": " .. show(a) .. " | " .. show(b) .. " | " .. show(c) .. " | " .. show(d))
end

SLASH_WARSCOREDIAG1 = "/wsdiag"
SlashCmdList.WARSCOREDIAG = function()
    output("Diagnóstico de API (valores en orden de retorno; nil = ausente)")
    inspect("GetPVPLifetimeStats", GetPVPLifetimeStats)
    inspect("GetPVPSessionStats", GetPVPSessionStats)
    inspect("GetPVPYesterdayStats", GetPVPYesterdayStats)
    for _, id in ipairs({ 319, 1487, 1501 }) do
        inspect("GetStatistic(" .. id .. ")", GetStatistic, id)
    end
    output("Copia las líneas de WarScore del chat y compártelas. Los IDs son candidatos, no validados.")
end
