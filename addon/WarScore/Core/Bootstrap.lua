local addonName, ns = ...
ns = ns or {}
ns.addonName = addonName
ns.initialized = false

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, event, loadedAddon)
    if event ~= "ADDON_LOADED" or loadedAddon ~= addonName then return end
    if type(WarScoreDB) ~= "table" then
        WarScoreDB = { characters = {}, onboardingCompleted = false }
    elseif WarScoreDB.onboardingCompleted == nil then
        WarScoreDB.onboardingCompleted = true
    end
    ns.initialized = true
end)

function ns.NeedsOnboarding()
    return ns.initialized and WarScoreDB.onboardingCompleted == false
end

function ns.CompleteOnboarding()
    if ns.NeedsOnboarding() then
        WarScoreDB.onboardingCompleted = true
    end
end
