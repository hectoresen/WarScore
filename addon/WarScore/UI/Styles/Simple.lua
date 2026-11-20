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

    -- Only the Simple General interior is compacted; tabs and window chrome
    -- retain their approved sizes and anchors.
    local content = CreateFrame("Frame", nil, frame)
    content:SetSize(870, 1105)
    content:SetPoint("TOP", frame, "TOP", 0, 0)
    -- A further ~3.6% reduction keeps the entire Simple composition within the inner frame.
    content:SetScale(0.93)
    content:EnableMouse(false)

    local portraitFrame = CreateFrame("Frame", nil, content)
    portraitFrame:SetSize(123.9, 123.9)
    portraitFrame:SetPoint("TOP", content, "TOP", 0, -156.05)
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
    values.name = makeText(content, 27, 0, -283, 380, 37, CREAM)
    values.level = makeText(content, 16, 0, -318, 430, 27, CREAM)

    -- The rank ornament is supplied as art without baked-in dynamic values.
    local rank = decorate(content, "simple_rank_plaque_owner", 390, 85, -350)
    -- UVs crop transparent padding using measured TGA alpha bounds.
    rank:SetTexCoord(0.046, 0.956, 0.291, 0.690)
    values.rankHeading = makeText(content, 15, 0, -374, 320, 23, CREAM)
    values.rank = makeText(content, 19, 0, -397, 310, 23, GOLD)
    -- Rank progression remains accessible without adding screenshot-inconsistent
    -- extra rows to the simplified General view.
    local rankDetails = ""
    local rankInfo = CreateFrame("Frame", nil, content)
    rankInfo:SetSize(400, 58)
    rankInfo:SetPoint("TOP", content, "TOP", 0, -378)
    rankInfo:EnableMouse(true)
    rankInfo:SetScript("OnEnter", function(self)
        if rankDetails == "" then return end
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(ns.L:Get("rank_caption"), 1, 0.82, 0.40)
        GameTooltip:AddLine(rankDetails, 0.95, 0.84, 0.66, true)
        GameTooltip:Show()
    end)
    rankInfo:SetScript("OnLeave", function() GameTooltip:Hide() end)

    -- Preserve the art aspect ratios: diamond 1001:73; thin rule 1014:9.
    -- Cropping the transparent canvas avoids squashing the center ornament.
    local function majorRule(y)
        local bar = decorate(content, "simple_divider_diamond_owner", 660, 48, y)
        bar:SetTexCoord(0.010, 0.987, 0.435, 0.578)
    end
    local function thinRule(y)
        local bar = decorate(content, "simple_divider_thin_owner", 660, 6, y)
        bar:SetTexCoord(0.009, 0.999, 0.496, 0.514)
    end

    majorRule(-462)
    local mainHKCaption = makeText(content, 24, -120, -510, 390, 40, CREAM, "LEFT")
    values.hk = makeText(content, 52, 205, -493, 160, 58, GOLD, "RIGHT")
    thinRule(-556)

    local function statRow(key, y, valueSize, valueColor, valueWidth)
        local caption = makeText(content, 19, -125, y, 360, 27, CREAM, "LEFT")
        local amount = makeText(content, valueSize or 21, 190, y - 2, valueWidth or 230, 27,
            valueColor or GOLD, "RIGHT")
        return caption, amount
    end
    values.honorCaption, values.honor = statRow("honor_title", -575, 23)
    thinRule(-605)
    values.hkdCaption, values.hkd = statRow("hk_death_ratio", -616, 23)
    thinRule(-645)
    values.deathsCaption, values.deaths = statRow("pvp_deaths", -658, 23, RED)
    majorRule(-698)

    values.duelsCaption, values.duels = statRow("duel_wins", -746, 20)
    thinRule(-780)
    values.bgPlayedCaption, values.bgPlayed = statRow("battlegrounds_played", -791, 20)
    thinRule(-825)
    values.bgWonCaption, values.bgWon = statRow("battlegrounds_won", -837, 20)
    majorRule(-865)

    values.bgRateCaption, values.bgRate = statRow("battleground_win_rate", -929, 21, GREEN)
    thinRule(-962)
    values.duelRateCaption, values.duelRate = statRow("duel_win_rate", -975, 21, GREEN)
    thinRule(-1006)
    values.favoriteCaption = makeText(content, 19, -125, -1021, 360, 26, CREAM, "LEFT")
    values.favorite = makeText(content, 16, 150, -1019, 310, 23, GOLD, "RIGHT")
    values.favoritePlayed = makeText(content, 12, 165, -1043, 280, 19, MUTED, "RIGHT")
    thinRule(-1082)

    local function localize()
        generalTitle:SetText(ns.L:Get("tab_general"))
        todayTitle:SetText(ns.L:Get("tab_today"))
        values.rankHeading:SetText(ns.L:Get("rank_caption"))
        mainHKCaption:SetText(ns.L:Get("simple_honorable_kills"))
        local keys = {
            honorCaption = "simple_honor",
            hkdCaption = "hk_death_ratio",
            deathsCaption = "simple_deaths",
            duelsCaption = "simple_duel_wins",
            bgPlayedCaption = "simple_bg_played",
            bgWonCaption = "simple_bg_won",
            bgRateCaption = "simple_bg_win_rate",
            duelRateCaption = "simple_duel_win_rate",
            favoriteCaption = "simple_favorite_bg",
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
