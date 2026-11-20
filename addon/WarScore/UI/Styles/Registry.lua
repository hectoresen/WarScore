local _, ns = ...
ns.UI = ns.UI or {}

-- Never persist translated labels. IDs are stable across renames.
local Registry = {}
local DEFAULT_ID = "classic-forever"
local styles = {
    { id = DEFAULT_ID, labelKey = "visual_style_classic" },
    { id = "classic-forever-simple", labelKey = "visual_style_simple" },
}
local byId = {}
for _, style in ipairs(styles) do byId[style.id] = style end

function Registry.List() return styles end

function Registry.Resolve(id)
    return byId[id] or byId[DEFAULT_ID]
end

function Registry.Current()
    local settings = type(WarScoreDB) == "table" and WarScoreDB.settings
    return Registry.Resolve(type(settings) == "table" and settings.visualStyle)
end

function Registry.Set(id)
    if not byId[id] then return false end
    WarScoreDB = WarScoreDB or {}
    WarScoreDB.settings = WarScoreDB.settings or {}
    WarScoreDB.settings.visualStyle = id
    return true
end

ns.UI.StyleRegistry = Registry
