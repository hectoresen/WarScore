local _, ns = ...
ns.UI = ns.UI or {}

-- The Simple renderer owns General content only. Outer chrome and Settings
-- remain owned by General.lua. All values come from its shared refresh cycle.
local function makeText(parent, size, x, y, width, height, color, justify)
    local font = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    font:SetFont("Fonts\\FRIZQT__.TTF", size, "OUTLINE")
    font:SetTextColor(unpack(color))
    font:SetSize(width, height)
    font:SetPoint("TOP", parent, "TOP", x, y)
    font:SetJustifyH(justify or "CENTER")
    font:SetText("")
    return font
end

local function decorate(parent, name, width, height, y)
    local tex = parent:CreateTexture(nil, "ARTWORK")
    tex:SetTexture("Interface\\AddOns\\WarScore\\Media\\" .. "General\\" .. name)
    tex:SetSize(width, height)
    tex:SetPoint("TOP", parent, "TOP", 0, y)
    return tex
end

local GOLD = { 1, 0.76, 0.28 }
local CREAM = { 0.94, 0.84, 0.66 }
local RED = { 0.98, 0.42, 0.39 }
local GREEN = { 0.50, 0.88, 0.31 }
local MUTED = { 0.72, 0.63, 0.53 }

function ns.UI.CreateSimpleGeneral(window)
    local frame = CreateFrame("Frame", nil, window)
    frame:SetAllPoints(window)
    frame:SetFrameLevel(window:GetFrameLevel() + 1)
    frame:EnableMouse(false)
    frame:Hide()

    -- The tab plates are embedded in the shared inner-frame texture, but
    -- their live captions/buttons belong to the active General renderer.
    local generalTab = CreateFrame("Button", nil, frame)
    generalTab:SetSize(150, 38)
    generalTab:SetPoint("TOPLEFT", window, "TOPLEFT", 193, -102)
    local generalTitle = makeText(generalTab, 16, 0, -2, 135, 29, GOLD)
    local todayTab = CreateFrame("Button", nil, frame)
    todayTab:SetSize(150, 38)
    todayTab:SetPoint("TOPLEFT", window, "TOPLEFT", 366, -102)
    local todayTitle = makeText(todayTab, 15, -5, -2, 135, 29, CREAM)
    todayTab:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(ns.L:Get("today_coming_soon"), 1, 0.82, 0.40)
        GameTooltip:Show()
    end)
    todayTab:SetScript("OnLeave", function() GameTooltip:Hide() end)
    todayTab:SetScript("OnClick", function()
        if DEFAULT_CHAT_FRAME then
            DEFAULT_CHAT_FRAME:AddMessage("|cffffc34dWarScore:|r " .. ns.L:Get("today_message"))
        end
    end)

    local portraitFrame = CreateFrame("Frame", nil, frame)
    portraitFrame:SetSize(123.9, 123.9)
    portraitFrame:SetPoint("TOP", frame, "TOP", 0, -156.05)
    local portrait = portraitFrame:CreateTexture(nil, "ARTWORK")
    portrait:SetSize(105, 105)
    portrait:SetPoint("CENTER", portraitFrame, "CENTER")
    local masked = false
    if type(portraitFrame.CreateMaskTexture) == "function"
        and type(portrait.AddMaskTexture) == "function" then
        masked = pcall(function()
            local mask = portraitFrame:CreateMaskTexture(nil, "ARTWORK")
            mask:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_mask")
            mask:SetAllPoints(portrait)
            portrait:AddMaskTexture(mask)
        end)
    end
    if not masked then
        local legacyRing = portraitFrame:CreateTexture(nil, "OVERLAY")
        legacyRing:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_ring")
        legacyRing:SetAllPoints(portraitFrame)
    end
    local ring = portraitFrame:CreateTexture(nil, "OVERLAY")
    ring:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_ring_owner_v132")
    ring:SetAllPoints(portraitFrame)

    local values = {}
    values.name = makeText(frame, 27, 0, -283, 380, 37, CREAM)
    values.level = makeText(frame, 16, 0, -318, 430, 27, CREAM)

    -- The rank ornament is supplied as art without baked-in dynamic values.
    local rank = decorate(frame, "simple_rank_plaque_owner", 530, 105, -348)
    -- Source texture has transparent padding. Crop only the padding with UVs.
    rank:SetTexCoord(0, 1, 0.166, 0.834)
    values.rankHeading = makeText(frame, 15, 0, -383, 320, 23, CREAM)
    values.rank = makeText(frame, 22, 0, -409, 350, 28, GOLD)
    -- Rank progression remains accessible without adding screenshot-inconsistent
    -- extra rows to the simplified General view.
    local rankDetails = ""
    local rankInfo = CreateFrame("Frame", nil, frame)
    rankInfo:SetSize(400, 58)
    rankInfo:SetPoint("TOP", frame, "TOP", 0, -378)
    rankInfo:EnableMouse(true)
    rankInfo:SetScript("OnEnter", function(self)
        if rankDetails == "" then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(ns.L:Get("rank_caption"), 1, 0.82, 0.40)
        GameTooltip:AddLine(rankDetails, 0.95, 0.84, 0.66, true)
        GameTooltip:Show()
    end)
    rankInfo:SetScript("OnLeave", function() GameTooltip:Hide() end)

    local function majorRule(y)
        local bar = decorate(frame, "simple_divider_diamond_owner", 670, 54, y)
        bar:SetTexCoord(0, 1, 0.195, 0.807)
    end
    local function thinRule(y)
        local bar = decorate(frame, "simple_divider_thin_owner", 675, 19, y)
        bar:SetTexCoord(0, 1, 0.18, 0.82)
    end

    majorRule(-435)
    local mainHKCaption = makeText(frame, 24, -136, -511, 450, 40, CREAM, "LEFT")
    values.hk = makeText(frame, 47, 259, -496, 160, 58, GOLD, "RIGHT")
    thinRule(-531)

    local function statRow(key, y, valueSize, valueColor, valueWidth)
        local caption = makeText(frame, 19, -136, y, 450, 31, CREAM, "LEFT")
        local amount = makeText(frame, valueSize or 22, 245, y - 2, valueWidth or 230, 32,
            valueColor or GOLD, "RIGHT")
        return caption, amount
    end
    values.honorCaption, values.honor = statRow("honor_title", -568, 21)
    thinRule(-580)
    values.hkdCaption, values.hkd = statRow("hk_death_ratio", -605, 21)
    thinRule(-615)
    values.deathsCaption, values.deaths = statRow("pvp_deaths", -642, 21, RED)
    majorRule(-674)

    values.duelsCaption, values.duels = statRow("duel_wins", -723, 20)
    thinRule(-737)
    values.bgPlayedCaption, values.bgPlayed = statRow("battlegrounds_played", -760, 20)
    thinRule(-775)
    values.bgWonCaption, values.bgWon = statRow("battlegrounds_won", -799, 20)
    majorRule(-833)

    values.bgRateCaption, values.bgRate = statRow("battleground_win_rate", -879, 21, GREEN)
    thinRule(-896)
    values.duelRateCaption, values.duelRate = statRow("duel_win_rate", -918, 21, GREEN)
    thinRule(-939)
    values.favoriteCaption = makeText(frame, 19, -136, -962, 380, 30, CREAM, "LEFT")
    values.favorite = makeText(frame, 18, 186, -958, 410, 29, GOLD, "RIGHT")
    values.favoritePlayed = makeText(frame, 13, 202, -986, 365, 23, MUTED, "RIGHT")
    thinRule(-1026)

    local function localize()
        generalTitle:SetText(ns.L:Get("tab_general"))
        todayTitle:SetText(ns.L:Get("tab_today"))
        values.rankHeading:SetText(ns.L:Get("rank_caption"))
        mainHKCaption:SetText(ns.L:Get("honorable_kills"))
        local keys = {
            honorCaption = "honor_title",
            hkdCaption = "hk_death_ratio",
            deathsCaption = "pvp_deaths",
            duelsCaption = "duel_wins",
            bgPlayedCaption = "battlegrounds_played",
            bgWonCaption = "battlegrounds_won",
            bgRateCaption = "battleground_win_rate",
            duelRateCaption = "duel_win_rate",
            favoriteCaption = "favorite_battleground",
        }
        for field, key in pairs(keys) do values[field]:SetText(ns.L:Get(key)) end
    end

    local view = {}
    function view:Show() frame:Show() end
    function view:Hide() frame:Hide() end
    function view:Refresh(model)
        localize()
        for _, key in ipairs({
            "name", "level", "rank", "hk", "honor", "hkd", "deaths",
            "duels", "bgPlayed", "bgWon", "bgRate", "duelRate", "favorite",
            "favoritePlayed",
        }) do
            values[key]:SetText(model[key] or "—")
        end
        rankDetails = (model.rankFrom or "—") .. "  |  " ..
            (model.rankPoints or "—") .. "  |  " .. (model.rankTo or "—")
        if type(SetPortraitTexture) == "function" then
            SetPortraitTexture(portrait, "player")
        end
    end
    return view
end
