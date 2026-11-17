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


local function categories()
    if type(GetStatisticsCategoryList) ~= "function" then
        output("GetStatisticsCategoryList no disponible")
        return
    end
    local ok, ids = pcall(GetStatisticsCategoryList)
    if not ok or type(ids) ~= "table" then
        output("Categorias: " .. show(ids))
        return
    end
    output("Categorias de estadisticas: " .. #ids .. " (primeras 40)")
    for i = 1, math.min(#ids, 40) do
        local id = ids[i]
        local name, parent
        if type(GetCategoryInfo) == "function" then
            local success, a, b = pcall(GetCategoryInfo, id)
            if success then name, parent = a, b end
        end
        output(i .. ". ID " .. show(id) .. " | " .. show(name) .. " | padre " .. show(parent))
    end
end


local function listStats(category)
    local allowed = { [21]=true, [153]=true, [154]=true, [137]=true, [136]=true, [122]=true }
    if not allowed[category] then
        output("Categoria no admitida. Usa 21, 153, 154, 137, 136 o 122")
        return
    end
    if type(GetCategoryNumAchievements) ~= "function" or type(GetAchievementInfo) ~= "function" then
        output("APIs de enumeracion no disponibles")
        return
    end
    local ok, total = pcall(GetCategoryNumAchievements, category)
    if not ok or type(total) ~= "number" then
        output("No se pudo consultar la categoria " .. category .. ": " .. show(total))
        return
    end
    output("Categoria " .. category .. ": " .. total .. " entradas; mostrando hasta 35")
    for i = 1, math.min(total, 35) do
        local success, id, name = pcall(GetAchievementInfo, category, i)
        if success and type(id) == "number" then
            local value = "--"
            if type(GetStatistic) == "function" then
                local readOk, stat = pcall(GetStatistic, id)
                if readOk then value = show(stat) end
            end
            output(i .. ". " .. id .. " | " .. show(name) .. " | valor " .. value)
        else
            output(i .. ". ERROR " .. show(id))
        end
    end
    if total > 35 then output("Hay mas entradas; se limita el chat a 35") end
end

SLASH_WARSCOREDIAG1 = "/wsdiag"
SlashCmdList.WARSCOREDIAG = function(message)
    local mode = (message or ""):match("^%s*(%S+)") or ""
    if mode == "list" then
        local id = tonumber((message or ""):match("^%s*list%s+(%d+)"))
        if id then listStats(id) else output("Uso: /wsdiag list 21") end
    elseif mode == "categories" then
        categories()
    elseif mode == "detail" then
        details()
    elseif mode == "daily" then
        output("Fecha cliente: " .. (type(date) == "function" and show(date("%Y-%m-%d %H:%M")) or "API no disponible"))
        inspect("GetPVPSessionStats", GetPVPSessionStats)
        inspect("GetPVPYesterdayStats", GetPVPYesterdayStats)
    else
        basics()
        output("Opciones: /wsdiag list 21 | categories | detail | daily")
    end
end
