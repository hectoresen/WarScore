local _, ns = ...

local L = {}
local catalogs = {
    es = {
        addon_name = "WarScore",
        character_fallback = "Personaje",
        class_fallback = "Clase",
        level_format = "Nivel %s · %s",
        tab_general = "General",
        tab_today = "Hoy",
        today_coming_soon = "Hoy (Próximamente)",
        today_message = "La pestaña Hoy estará disponible en una próxima versión.",
        settings_coming_soon = "Ajustes (próximamente)",
        rank_caption = "Rango PvP",
        rank_level = "Rango %s",
        no_rank = "Sin rango",
        rank_unavailable = "No disponible",
        rank_max = "Máximo",
        rank_points_suffix = "PR",
        honor_title = "HONOR",
        honorable_kills = "MUERTES CON HONOR (HK)",
        pvp_deaths = "MUERTES PvP SUFRIDAS",
        hk_death_ratio = "HK/D",
        hk_death_ratio_description = "HK / muertes PvP sufridas",
        duel_wins = "DUELOS GANADOS",
        battlegrounds_played = "CAMPOS DE BATALLA JUGADOS",
        battlegrounds_won = "BG GANADOS",
        battleground_win_rate = "WIN RATE BG",
        duel_win_rate = "WIN RATE DUELOS",
        favorite_battleground = "CAMPO DE BATALLA FAVORITO",
        played_once = "%s vez jugado",
        played_many = "%s veces jugado",
        language_current = "Idioma activo: %s",
        language_usage = "Uso: /ws lang es | /ws lang en",
        language_changed = "Idioma cambiado a: %s",
        language_invalid = "Idioma no válido. Usa es o en.",
    },
    en = {
        addon_name = "WarScore",
        character_fallback = "Character",
        class_fallback = "Class",
        level_format = "Level %s · %s",
        tab_general = "General",
        tab_today = "Today",
        today_coming_soon = "Today (Coming soon)",
        today_message = "The Today tab will be available in a future version.",
        settings_coming_soon = "Settings (coming soon)",
        rank_caption = "PvP Rank",
        rank_level = "Rank %s",
        no_rank = "Unranked",
        rank_unavailable = "Unavailable",
        rank_max = "Maximum",
        rank_points_suffix = "RP",
        honor_title = "HONOR",
        honorable_kills = "HONORABLE KILLS (HK)",
        pvp_deaths = "PVP DEATHS",
        hk_death_ratio = "HK/D",
        hk_death_ratio_description = "HK / PvP deaths",
        duel_wins = "DUELS WON",
        battlegrounds_played = "BATTLEGROUNDS PLAYED",
        battlegrounds_won = "BG WINS",
        battleground_win_rate = "BG WIN RATE",
        duel_win_rate = "DUEL WIN RATE",
        favorite_battleground = "FAVORITE BATTLEGROUND",
        played_once = "%s match played",
        played_many = "%s matches played",
        language_current = "Active language: %s",
        language_usage = "Usage: /ws lang es | /ws lang en",
        language_changed = "Language changed to: %s",
        language_invalid = "Invalid language. Use es or en.",
    },
}

local language = "es"
local listeners = {}

local function ensureDB()
    if type(WarScoreDB) ~= "table" then return end
    WarScoreDB.settings = WarScoreDB.settings or {}
    local saved = WarScoreDB.settings.language
    if catalogs[saved] then language = saved end
end

function L:GetLanguage()
    ensureDB()
    return language
end

function L:Get(key, ...)
    ensureDB()
    local active = catalogs[language] or catalogs.es
    local value = active[key] or catalogs.es[key] or key
    if select("#", ...) > 0 then
        local ok, formatted = pcall(string.format, value, ...)
        if ok then return formatted end
    end
    return value
end

function L:SetLanguage(nextLanguage)
    if not catalogs[nextLanguage] then return false end
    language = nextLanguage
    if type(WarScoreDB) == "table" then
        WarScoreDB.settings = WarScoreDB.settings or {}
        WarScoreDB.settings.language = nextLanguage
    end
    for _, listener in ipairs(listeners) do listener(nextLanguage) end
    return true
end

function L:RegisterRefresh(listener)
    if type(listener) == "function" then listeners[#listeners + 1] = listener end
end

ns.L = L
