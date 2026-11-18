local addonName, ns = ...
local function output(message)
    DEFAULT_CHAT_FRAME:AddMessage("|cffd8b365WarScore|r " .. tostring(message))
end

local honorFrame = CreateFrame("Frame")
honorFrame:RegisterEvent("INSPECT_HONOR_UPDATE")
honorFrame:RegisterEvent("HONOR_XP_UPDATE")
honorFrame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE")
honorFrame:RegisterEvent("PVP_MATCH_COMPLETE")

local function show(value)
    if value == nil then return "nil" end
    return tostring(value)
end

local honorRequestPending = false

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
    output("Honor (APIs directas)")
    inspect("UnitHonor(player)", UnitHonor, "player")
    inspect("UnitHonorMax(player)", UnitHonorMax, "player")
    inspect("UnitHonorLevel(player)", UnitHonorLevel, "player")
    inspect("GetInspectHonorData", GetInspectHonorData)
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

local function printHonorData()
    output("Honor (APIs directas)")
    inspect("UnitHonor(player)", UnitHonor, "player")
    inspect("UnitHonorMax(player)", UnitHonorMax, "player")
    inspect("UnitHonorLevel(player)", UnitHonorLevel, "player")
    inspect("GetInspectHonorData", GetInspectHonorData)
end

local function printBattlefieldScore()
    output("Puntuacion de BG actual/final")
    local guid = type(UnitGUID) == "function" and UnitGUID("player") or nil
    if C_PvP and type(C_PvP.GetScoreInfoByPlayerGuid) == "function" and guid then
        local ok, info = pcall(C_PvP.GetScoreInfoByPlayerGuid, guid)
        if ok and type(info) == "table" then
            output("C_PvP.GetScoreInfoByPlayerGuid: " .. show(info.name)
                .. " | KB " .. show(info.killingBlows)
                .. " | HK " .. show(info.honorableKills)
                .. " | muertes " .. show(info.deaths)
                .. " | honor BG " .. show(info.honorGained))
            output("Danio " .. show(info.damageDone) .. " | sanacion " .. show(info.healingDone)
                .. " | rating " .. show(info.ratingChange))
            return
        end
        output("C_PvP.GetScoreInfoByPlayerGuid: sin datos" .. (not ok and (" | ERROR " .. show(info)) or ""))
    else
        output("C_PvP.GetScoreInfoByPlayerGuid: API no disponible")
    end

    if type(GetNumBattlefieldScores) == "function" and type(GetBattlefieldScore) == "function" then
        local ok, count = pcall(GetNumBattlefieldScores)
        if ok and type(count) == "number" then
            output("Scores legacy: " .. count)
            for i = 1, count do
                local readOk, name, kb, hk, deaths, honor = pcall(GetBattlefieldScore, i)
                if readOk and name == UnitName("player") then
                    output("GetBattlefieldScore(player): KB " .. show(kb)
                        .. " | HK " .. show(hk)
                        .. " | muertes " .. show(deaths)
                        .. " | honor BG " .. show(honor))
                    return
                end
            end
        end
    end
    output("No hay puntuacion de BG cargada; ejecutalo dentro de la BG o justo al terminar")
end

local function printCurrencies()
    output("Monedas PvP del personaje")
    local currencyAPI = C_CurrencyInfo
    local sizeFn = currencyAPI and currencyAPI.GetCurrencyListSize
    local infoFn = currencyAPI and currencyAPI.GetCurrencyListInfo
    if type(sizeFn) ~= "function" or type(infoFn) ~= "function" then
        output("C_CurrencyInfo.GetCurrencyListSize/GetCurrencyListInfo no disponibles")
        return
    end
    local ok, count = pcall(sizeFn)
    if not ok or type(count) ~= "number" then
        output("No se pudo leer la lista de monedas: " .. show(count))
        return
    end
    output("Entradas de monedas: " .. count)
    local found = false
    for index = 1, count do
        local readOk, info = pcall(infoFn, index)
        if readOk and type(info) == "table" then
            local name = info.name or info.currencyName
            local textName = name and string.lower(tostring(name)) or ""
            if string.find(textName, "honor", 1, true)
                or string.find(textName, "rango", 1, true)
                or string.find(textName, "rank", 1, true) then
                found = true
                output(index .. ". " .. show(name)
                    .. " | cantidad " .. show(info.quantity or info.count)
                    .. " | max " .. show(info.maxQuantity)
                    .. " | ID " .. show(info.currencyTypesID or info.currencyID))
            end
        end
    end
    if not found then output("No se encontro una moneda con nombre Honor/Rango") end
end

honorFrame:SetScript("OnEvent", function(_, event)
    if event == "INSPECT_HONOR_UPDATE" then
        if honorRequestPending then
            honorRequestPending = false
            output("INSPECT_HONOR_UPDATE recibido para la solicitud de WarScore")
            inspect("GetInspectHonorData", GetInspectHonorData)
        end
    elseif event == "HONOR_XP_UPDATE" then
        output("HONOR_XP_UPDATE recibido")
        inspect("UnitHonor(player)", UnitHonor, "player")
        inspect("UnitHonorMax(player)", UnitHonorMax, "player")
    elseif event == "UPDATE_BATTLEFIELD_SCORE" or event == "PVP_MATCH_COMPLETE" then
        output(event .. " recibido")
        printBattlefieldScore()
    end
end)


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
    local allowed = { [21]=true, [153]=true, [154]=true, [137]=true, [136]=true, [122]=true, [128]=true }
    if not allowed[category] then
        output("Categoria no admitida. Usa 21, 153, 154, 137, 136, 122 o 128")
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
    elseif mode == "honor" then
        printHonorData()
        if type(NotifyInspect) == "function" and type(RequestInspectHonorData) == "function" then
            honorRequestPending = true
            local notifyOk, notifyError = pcall(NotifyInspect, "player")
            local requestOk, requestError = pcall(RequestInspectHonorData)
            if not notifyOk or not requestOk then honorRequestPending = false end
            output("Solicitud de honor: NotifyInspect=" .. (notifyOk and "OK" or "ERROR " .. show(notifyError)) .. " | RequestInspectHonorData=" .. (requestOk and "OK" or "ERROR " .. show(requestError)))
            output("Si llega INSPECT_HONOR_UPDATE, se imprimiran los retornos actualizados")
        else
            output("APIs de solicitud de honor no disponibles")
        end
    elseif mode == "battlefield" or mode == "bg" then
        printBattlefieldScore()
    elseif mode == "currencies" or mode == "currency" then
        printCurrencies()
    elseif mode == "daily" then
        output("Fecha cliente: " .. (type(date) == "function" and show(date("%Y-%m-%d %H:%M")) or "API no disponible"))
        inspect("GetPVPSessionStats", GetPVPSessionStats)
        inspect("GetPVPYesterdayStats", GetPVPYesterdayStats)
    else
        basics()
        output("Opciones: /wsdiag honor | battlefield | currencies | list 21 | categories | detail | daily")
    end
end
