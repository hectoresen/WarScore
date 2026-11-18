local addonName, ns = ...
ns = ns or {}
ns.addonName = addonName
ns.initialized = false

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, loadedAddon)
    if event ~= "ADDON_LOADED" or loadedAddon ~= addonName then return end
    WarScoreDB = WarScoreDB or { characters = {} }
    ns.initialized = true
end)
