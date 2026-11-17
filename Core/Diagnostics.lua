local addonName, ns = ...
local function output(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cffd8b365WarScore|r " .. tostring(message))
end

local function show(value)
    if value == nil then return "nil" end
    return tostring(value)
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
        output(label .. ": ERROR " .. show(a))
        return
    end
    output(label .. ": " .. show(a) .. " | " .. show(b) .. " | " .. show(c) .. " | " .. show(d))
end

local function basics()
    output("API PvP (retornos en orden)")
    inspect("GetPVPLifetimeStats", GetPVPLifetimeStats)
    inspect("GetPVPSessionStats", GetPVPSessionStats)
    inspect("GetPVPYesterdayStats", GetPVPYesterdayStats)
    for _, id in ipairs({ 319, 1487, 1501 }) do
        inspect("GetStatistic(" .. id .. ")", GetStatistic, id)
    end
end

local function details()
    output("Detalle IDs candidatos; valores no implican semántica PvP")
    for _, id in ipairs({ 319, 1487, 1501 }) do
        inspect("Statistic " .. id, GetStatistic, id)
        inspect("Achievement " .. id, GetAchievementInfo, id)
    end
    inspect("GetStatisticsCategoryList", GetStatisticsCategoryList)
    inspect("GetCategoryList", GetCategoryList)
end

SLASH_WARSCOREDIAG1 = "/wsdiag"
SlashCmdList.WARSCOREDIAG = function(message)
    local mode = (message or ""):match("^%s*(%S+)") or ""
    if mode == "detail" then
        details()
    elseif mode == "daily" then
        output("Fecha cliente: " .. (type(date) == "function" and show(date("%Y-%m-%d %H:%M")) or "API no disponible"))
        inspect("GetPVPSessionStats", GetPVPSessionStats)
        inspect("GetPVPYesterdayStats", GetPVPYesterdayStats)
    else
        basics()
        output("Opciones: /wsdiag detail | /wsdiag daily")
    end
end
