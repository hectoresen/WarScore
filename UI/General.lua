local _, ns = ...
ns.UI = ns.UI or {}

-- Native WoW first pass. Ornamental texture assets and reference-image QA remain pending.
local window, fields
local GOLD = { 0.95, 0.72, 0.27 }
local CREAM = { 0.92, 0.83, 0.67 }
local RED = { 0.96, 0.43, 0.39 }
local GREEN = { 0.50, 0.88, 0.31 }
local function rgb(color) return unpack(color) end

local function label(parent, text, size, color, x, y, width, height)
    local font = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    font:SetFont("Fonts\\FRIZQT__.TTF", size, "OUTLINE")
    font:SetTextColor(rgb(color or CREAM))
    font:SetPoint("TOP", parent, "TOP", x, y)
    font:SetSize(width or 250, height or 35)
    font:SetJustifyH("CENTER")
    font:SetText(text or "")
    return font
end

local function backdrop(frame, alpha)
    local tex = frame:CreateTexture(nil, "BACKGROUND")
    tex:SetAllPoints(frame)
    tex:SetTexture("Interface\\Buttons\\WHITE8X8")
    tex:SetVertexColor(0.065, 0.048, 0.038, alpha or 0.96)
    return tex
end

local function line(parent, y, width)
    local texture = parent:CreateTexture(nil, "BORDER")
    texture:SetTexture("Interface\\Buttons\\WHITE8X8")
    texture:SetVertexColor(0.72, 0.48, 0.17, 0.85)
    texture:SetSize(width or 620, 2)
    texture:SetPoint("TOP", parent, "TOP", 0, y)
end

-- Iteration 8: original 32-bit TGA with alpha; validate actual loading in Forever.
-- Keep native faction emblem on top; Alliance banner art is still pending.
local function ornament(parent, side)
    local sign = side == "LEFT" and -1 or 1
    local banner = CreateFrame("Frame", nil, parent)
    banner:SetSize(106, 198)
    banner:SetPoint("TOP", parent, "TOP", sign * 270, -130)
    local cloth = banner:CreateTexture(nil, "BACKGROUND")
    cloth:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\banner_horde")
    cloth:SetAllPoints(banner)
    cloth:SetAlpha(0.92)
    local icon = banner:CreateTexture(nil, "ARTWORK")
    local faction = UnitFactionGroup("player")
    icon:SetTexture(faction == "Alliance" and "Interface\\Icons\\INV_BannerPVP_02" or "Interface\\Icons\\INV_BannerPVP_01")
    icon:SetSize(48, 48)
    icon:SetPoint("TOP", banner, "TOP", 0, -36)
    icon:SetAlpha(0.85)
    return banner
end

-- Native decorative accents: no additional assets or client-only APIs required.
local function accent(parent, point, relativePoint, x, y, width, height, color)
    local tex = parent:CreateTexture(nil, "BORDER")
    tex:SetTexture("Interface\\Buttons\\WHITE8X8")
    tex:SetVertexColor(unpack(color or GOLD))
    tex:SetSize(width, height)
    tex:SetPoint(point, parent, relativePoint, x, y)
    return tex
end

-- Decorative primitives, grouped so the whole visual pass can be QA'd together.
local function ornamentDiamond(parent, y, size)
    local d = parent:CreateTexture(nil, "OVERLAY")
    d:SetTexture("Interface\\Buttons\\WHITE8X8")
    d:SetVertexColor(0.88, 0.59, 0.19, 1)
    d:SetSize(size or 10, size or 10)
    d:SetRotation(math.pi / 4)
    d:SetPoint("TOP", parent, "TOP", 0, y)
    return d
end

local function cornerAccent(parent, xSide, ySide)
    local texture = parent:CreateTexture(nil, "OVERLAY")
    texture:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\ornate_corner")
    texture:SetSize(68, 68)
    local insetX = xSide == "LEFT" and 8 or -8
    local insetY = ySide == "TOP" and -8 or 8
    texture:SetPoint(ySide .. xSide, parent, ySide .. xSide, insetX, insetY)
    -- Mirror the single authored corner art to all four positions.
    texture:SetTexCoord(xSide == "LEFT" and 0 or 1, xSide == "LEFT" and 1 or 0,
        ySide == "TOP" and 0 or 1, ySide == "TOP" and 1 or 0)
end

local function skinTab(button, selected)
    -- Full tab skin rather than the default grey/red UIPanelButton look.
    button:SetNormalTexture("")
    button:SetPushedTexture("")
    button:SetHighlightTexture("")
    button:SetDisabledTexture("")
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\Buttons\\WHITE8X8")
    bg:SetVertexColor(selected and 0.28 or 0.12, selected and 0.13 or 0.08, 0.035, 0.97)
    bg:SetAllPoints(button)
    local top = button:CreateTexture(nil, "BORDER")
    top:SetTexture("Interface\\Buttons\\WHITE8X8")
    top:SetVertexColor(0.84, 0.58, 0.19, 0.95)
    top:SetHeight(selected and 3 or 2)
    top:SetPoint("TOPLEFT", button, "TOPLEFT", 0, 0)
    top:SetPoint("TOPRIGHT", button, "TOPRIGHT", 0, 0)
    local bottom = button:CreateTexture(nil, "BORDER")
    bottom:SetTexture("Interface\\Buttons\\WHITE8X8")
    bottom:SetVertexColor(0.70, 0.42, 0.12, selected and 1 or 0.55)
    bottom:SetHeight(selected and 3 or 1)
    bottom:SetPoint("BOTTOMLEFT", button, "BOTTOMLEFT", 0, 0)
    bottom:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 0, 0)
    local text = button:GetFontString()
    if text then
        text:SetTextColor(selected and 1 or 0.80, selected and 0.78 or 0.72, selected and 0.35 or 0.55)
    end
end

local function sectionPlaque(parent, y, width, height, alpha)
    local shade = parent:CreateTexture(nil, "BACKGROUND")
    shade:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\section_plaque")
    shade:SetVertexColor(1, 1, 1, alpha or 0.9)
    shade:SetSize(width, height)
    shade:SetPoint("TOP", parent, "TOP", 0, y)
    return shade
end

-- Iteration 16: refine the tested two-band layout without changing data bindings.
-- All ornament layers use native textures confirmed by earlier client screenshots.
local function statBand(parent, y, definitions)
    local band = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    band:SetSize(704, 112)
    band:SetPoint("TOP", parent, "TOP", 0, y)
    backdrop(band, 0.92)
    band:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 18 })
    band:SetBackdropBorderColor(0.76, 0.51, 0.20, 0.96)

    local function trim(point, inset, offset, height, color)
        local rule = band:CreateTexture(nil, "BORDER")
        rule:SetTexture("Interface\\Buttons\\WHITE8X8")
        rule:SetVertexColor(unpack(color))
        rule:SetHeight(height)
        rule:SetPoint(point .. "LEFT", band, point .. "LEFT", inset, offset)
        rule:SetPoint(point .. "RIGHT", band, point .. "RIGHT", -inset, offset)
    end
    -- Paired metallic rails give the frame a slight inset/bevel without a new asset.
    trim("TOP", 9, -4, 2, { 0.92, 0.64, 0.22, 0.95 })
    trim("TOP", 13, -8, 1, { 0.38, 0.22, 0.08, 0.85 })
    trim("BOTTOM", 9, 4, 2, { 0.71, 0.43, 0.13, 0.95 })
    trim("BOTTOM", 13, 8, 1, { 0.32, 0.20, 0.07, 0.85 })

    for _, side in ipairs({ "LEFT", "RIGHT" }) do
        for _, vertical in ipairs({ "TOP", "BOTTOM" }) do
            local stud = band:CreateTexture(nil, "OVERLAY")
            stud:SetTexture("Interface\\Buttons\\WHITE8X8")
            stud:SetVertexColor(0.98, 0.73, 0.30, 1)
            stud:SetSize(5, 5)
            stud:SetPoint(vertical .. side, band, vertical .. side,
                side == "LEFT" and 10 or -10, vertical == "TOP" and -10 or 10)
        end
    end

    local values = {}
    local segmentWidth = 704 / 3
    for i, definition in ipairs(definitions) do
        local segment = CreateFrame("Frame", nil, band)
        segment:SetSize(segmentWidth, 108)
        segment:SetPoint("TOPLEFT", band, "TOPLEFT", (i - 1) * segmentWidth, -2)
        if i > 1 then
            local dividerX = (i - 1) * segmentWidth
            local divider = band:CreateTexture(nil, "BORDER")
            divider:SetTexture("Interface\\Buttons\\WHITE8X8")
            divider:SetVertexColor(0.81, 0.53, 0.18, 0.92)
            divider:SetSize(2, 84)
            divider:SetPoint("CENTER", band, "LEFT", dividerX, 0)
            local bevel = band:CreateTexture(nil, "BORDER")
            bevel:SetTexture("Interface\\Buttons\\WHITE8X8")
            bevel:SetVertexColor(0.23, 0.13, 0.06, 0.95)
            bevel:SetSize(1, 84)
            bevel:SetPoint("CENTER", band, "LEFT", dividerX + 3, 0)
        end

        local icon = segment:CreateTexture(nil, "ARTWORK")
        icon:SetTexture(definition.icon)
        icon:SetSize(42, 42)
        icon:SetPoint("LEFT", segment, "LEFT", 13, 0)

        -- Text occupies a separate column, leaving the icon fully visible.
        label(segment, definition.title, 12, CREAM, 33, -12, segmentWidth - 80, 37)
        local value = label(segment, "—", definition.valueSize or 28,
            definition.color or GOLD, 33, -52, segmentWidth - 80, 47)
        values[i] = value
    end
    return values
end

local function formatNumber(value)
    if type(value) ~= "number" then return "—" end
    return tostring(math.floor(value))
end
local function formatRatio(value)
    if type(value) ~= "number" then return "—" end
    return string.format("%.2f", value):gsub("%.", ",")
end
local function formatPercent(value)
    if type(value) ~= "number" then return "—" end
    return string.format("%.1f%%", value):gsub("%.", ",")
end

local function refresh()
    if not window or not window:IsShown() then return end
    local data = ns.Stats.ReadHistorical()
    fields.name:SetText(UnitName("player") or "Personaje")
    fields.level:SetText("Nivel " .. tostring(UnitLevel("player") or "?") .. " · " .. (UnitClass("player") or "Clase"))
    if fields.portrait and type(SetPortraitTexture) == "function" then
        SetPortraitTexture(fields.portrait, "player")
    end
    fields.hk:SetText(formatNumber(data.honorableKills))
    fields.deaths:SetText(formatNumber(data.pvpDeaths))
    fields.hkd:SetText(formatRatio(data.hkDeathRatio))
    fields.kbd:SetText("—")
    fields.rank:SetText("Rango PvP · No disponible")
    fields.duels:SetText(formatNumber(data.duelsWon))
    fields.bgPlayed:SetText(formatNumber(data.battlegroundsPlayed))
    fields.bgWon:SetText(formatNumber(data.battlegroundsWon))
    fields.bgRate:SetText(formatPercent(data.bgWinRate))
    fields.duelRate:SetText(formatPercent(data.duelWinRate))
    local favorite = data.favoriteBattleground
    if favorite and data.favoriteBattlegroundPlayed then
        fields.favorite:SetText(favorite .. "\n" .. formatNumber(data.favoriteBattlegroundPlayed) .. " veces jugado")
    else
        fields.favorite:SetText("—")
    end
end

local function build()
    window = CreateFrame("Frame", "WarScoreGeneralFrame", UIParent, "BackdropTemplate")
    window:SetSize(750, 990)
    window:SetScale(0.86)
    window:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    window:SetFrameStrata("DIALOG")
    window:SetMovable(true)
    window:EnableMouse(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart", function(self) self:StartMoving() end)
    window:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    window:SetClampedToScreen(true)
    backdrop(window)
    window:Hide()

    -- Metallic outer perimeter is provisional until dedicated texture slices are supplied.
    local border = CreateFrame("Frame", nil, window, "BackdropTemplate")
    border:SetPoint("TOPLEFT", window, "TOPLEFT", 5, -5)
    border:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -5, 5)
    border:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 25 })
    border:SetBackdropBorderColor(rgb(GOLD))
    border:EnableMouse(false)
    cornerAccent(window, "LEFT", "TOP")
    cornerAccent(window, "RIGHT", "TOP")
    cornerAccent(window, "LEFT", "BOTTOM")
    cornerAccent(window, "RIGHT", "BOTTOM")

    local header = CreateFrame("Frame", nil, window, "BackdropTemplate")
    header:SetPoint("TOPLEFT", window, "TOPLEFT", 10, -10)
    header:SetPoint("TOPRIGHT", window, "TOPRIGHT", -10, -10)
    header:SetHeight(45)
    backdrop(header, 1)
    label(header, "WarScore", 31, GOLD, 0, -2, 350, 42)
    accent(header, "LEFT", "LEFT", 24, 0, 90, 2, { 0.65, 0.43, 0.15 })
    accent(header, "RIGHT", "RIGHT", -24, 0, 90, 2, { 0.65, 0.43, 0.15 })
    accent(header, "BOTTOM", "BOTTOM", 0, 0, 700, 2, { 0.50, 0.32, 0.13 })
    accent(header, "BOTTOM", "BOTTOM", 0, 1, 180, 1, GOLD)
    accent(header, "TOP", "TOP", 0, 0, 320, 1, { 0.45, 0.31, 0.13 })
    -- Iteration 18: compact header medallion, based on the approved crossed-swords
    -- composition. Reuses the confirmed transparent portrait-ring texture.
    -- Its icon is decorative only; it does not imply a PvP rank or achievement.
    local medallion = CreateFrame("Frame", nil, window)
    medallion:SetSize(76, 76)
    medallion:SetPoint("TOPLEFT", window, "TOPLEFT", 18, -2)
    medallion:EnableMouse(false)

    -- Use circular masks for BOTH the dark disc and the swords icon; the native
    -- square icon should never become a visible square plate inside the ring.
    local medallionDisc = medallion:CreateTexture(nil, "BACKGROUND")
    medallionDisc:SetTexture("Interface\\Buttons\\WHITE8X8")
    medallionDisc:SetVertexColor(0.17, 0.035, 0.025, 0.96)
    medallionDisc:SetSize(58, 58)
    medallionDisc:SetPoint("CENTER", medallion, "CENTER", 0, 0)

    local swords = medallion:CreateTexture(nil, "ARTWORK")
    swords:SetTexture("Interface\\Icons\\Ability_DualWield")
    swords:SetSize(51, 51)
    swords:SetPoint("CENTER", medallion, "CENTER", 0, 0)

    local function maskMedallionTexture(texture)
        if type(medallion.CreateMaskTexture) ~= "function"
            or type(texture.AddMaskTexture) ~= "function" then
            return false
        end
        local ok = pcall(function()
            local mask = medallion:CreateMaskTexture(nil, "ARTWORK")
            mask:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_mask")
            mask:SetAllPoints(texture)
            texture:AddMaskTexture(mask)
        end)
        return ok
    end

    local discMasked = maskMedallionTexture(medallionDisc)
    local iconMasked = maskMedallionTexture(swords)
    if not discMasked then
        -- Avoid the previous visibly square dark background on older clients.
        medallionDisc:Hide()
    end
    if not iconMasked then
        -- Unmasked icon is a temporary, smaller fallback, not a circular claim.
        swords:SetSize(36, 36)
    end

    local medallionRing = medallion:CreateTexture(nil, "OVERLAY")
    medallionRing:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_ring_transparent")
    medallionRing:SetAllPoints(medallion)

    local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", window, "TOPRIGHT", -12, -11)
    close:SetScript("OnClick", function() window:Hide() end)

    local general = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    general:SetSize(140, 32)
    general:SetPoint("TOPLEFT", window, "TOPLEFT", 115, -67)
    general:SetText("General")
    general:Disable()
    skinTab(general, true)
    local today = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    today:SetSize(140, 32)
    today:SetPoint("LEFT", general, "RIGHT", 7, 0)
    today:SetText("Hoy")
    skinTab(today, false)
    today:SetScript("OnClick", function()
        if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage("|cffffc34dWarScore:|r La pestaña Hoy estará disponible en una próxima versión.") end
    end)

    fields = {}
    ornament(window, "LEFT")
    ornament(window, "RIGHT")
    local portraitRing = CreateFrame("Frame", nil, window)
    portraitRing:SetSize(126, 126)
    portraitRing:SetPoint("TOP", window, "TOP", 0, -105)
    local portrait = portraitRing:CreateTexture(nil, "ARTWORK")
    portrait:SetSize(108, 108)
    portrait:SetPoint("CENTER")
    fields.portrait = portrait
    -- Prefer a real alpha mask: it removes the square portrait corners without
    -- painting an opaque square over the varying background.
    -- The Forever client may not expose this API; keep the tested old overlay.
    local maskApplied = false
    if type(portraitRing.CreateMaskTexture) == "function"
        and type(portrait.AddMaskTexture) == "function" then
        local ok = pcall(function()
            local mask = portraitRing:CreateMaskTexture(nil, "ARTWORK")
            mask:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_mask")
            mask:SetSize(108, 108)
            mask:SetPoint("CENTER", portrait, "CENTER", 0, 0)
            portrait:AddMaskTexture(mask)
        end)
        maskApplied = ok
    end
    local ring = portraitRing:CreateTexture(nil, "OVERLAY")
    if maskApplied then
        ring:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_ring_transparent")
    else
        ring:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_ring")
    end
    ring:SetSize(126, 126)
    ring:SetPoint("CENTER", portraitRing, "CENTER", 0, 0)
    fields.name = label(window, "—", 24, CREAM, 0, -233, 360, 34)
    fields.level = label(window, "—", 15, CREAM, 0, -269, 360, 25)
    -- Iteration 17: ornamental rank ribbon with a faction emblem, but NO
    -- fabricated PvP rank. The badge signifies faction only, not rank status.
    local rankPlate = CreateFrame("Frame", nil, window, "BackdropTemplate")
    rankPlate:SetSize(452, 38)
    rankPlate:SetPoint("TOP", window, "TOP", 0, -296)
    backdrop(rankPlate, 0.95)
    rankPlate:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 })
    rankPlate:SetBackdropBorderColor(0.72, 0.46, 0.15, 0.96)

    -- Background texture, not a child Frame: it must never cover rank text.
    local rankInset = rankPlate:CreateTexture(nil, "BACKGROUND")
    rankInset:SetTexture("Interface\\Buttons\\WHITE8X8")
    rankInset:SetVertexColor(0.12, 0.065, 0.025, 0.8)
    rankInset:SetPoint("TOPLEFT", rankPlate, "TOPLEFT", 8, -5)
    rankInset:SetPoint("BOTTOMRIGHT", rankPlate, "BOTTOMRIGHT", -8, 5)
    -- Double-tier metallic trim frames the ribbon, with short gold endcaps.
    accent(rankPlate, "TOP", "TOP", 0, -2, 350, 2, { 0.86, 0.58, 0.19 })
    accent(rankPlate, "BOTTOM", "BOTTOM", 0, 2, 350, 2, { 0.69, 0.42, 0.12 })
    accent(rankPlate, "LEFT", "LEFT", 12, 0, 4, 25, GOLD)
    accent(rankPlate, "RIGHT", "RIGHT", -12, 0, 4, 25, GOLD)

    local emblemHolder = CreateFrame("Frame", nil, rankPlate, "BackdropTemplate")
    emblemHolder:SetSize(48, 48)
    emblemHolder:SetPoint("LEFT", rankPlate, "LEFT", 19, 0)
    backdrop(emblemHolder, 1)
    emblemHolder:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 13 })
    emblemHolder:SetBackdropBorderColor(0.9, 0.62, 0.22, 1)
    local emblem = emblemHolder:CreateTexture(nil, "ARTWORK")
    local faction = UnitFactionGroup("player")
    emblem:SetTexture(faction == "Alliance"
        and "Interface\\Icons\\INV_BannerPVP_02"
        or "Interface\\Icons\\INV_BannerPVP_01")
    emblem:SetSize(32, 32)
    emblem:SetPoint("CENTER", emblemHolder, "CENTER", 0, 0)

    -- Short side filigree evokes laurel wings without claiming a real rank.
    for _, side in ipairs({ -1, 1 }) do
        local x = side * 193
        accent(rankPlate, "CENTER", "CENTER", x, 7, 17, 2, { 0.79, 0.50, 0.16 })
        accent(rankPlate, "CENTER", "CENTER", x - side * 5, 1, 24, 2, { 0.63, 0.39, 0.12 })
        accent(rankPlate, "CENTER", "CENTER", x - side * 8, -5, 14, 2, { 0.79, 0.50, 0.16 })
    end

    fields.rank = label(rankPlate, "Rango PvP · No disponible", 17, GOLD, 25, -4, 335, 32)
    line(window, -341, 650)
    ornamentDiamond(window, -339, 8)
    sectionPlaque(window, -353, 570, 116, 0.92)

    label(window, "MUERTES CON HONOR", 23, GOLD, 0, -355, 460, 35)
    fields.hk = label(window, "—", 57, GOLD, 0, -388, 500, 78)
    line(window, -475, 650)
    ornamentDiamond(window, -473, 8)
    local centerDivider = window:CreateTexture(nil, "BORDER")
    centerDivider:SetTexture("Interface\\Buttons\\WHITE8X8")
    centerDivider:SetVertexColor(0.6, 0.39, 0.14, 0.8)
    centerDivider:SetSize(2, 116)
    centerDivider:SetPoint("TOP", window, "TOP", 0, -490)

    label(window, "HK/D  (i)", 19, CREAM, -165, -490, 270, 30)
    label(window, "KB/D  (i)", 19, CREAM, 165, -490, 270, 30)
    fields.hkd = label(window, "—", 37, GOLD, -165, -524, 270, 53)
    fields.kbd = label(window, "—", 37, GOLD, 165, -524, 270, 53)
    label(window, "HK / muertes PvP sufridas", 12, CREAM, -165, -576, 300, 25)
    label(window, "Golpes de gracia / muertes PvP", 12, CREAM, 165, -576, 300, 25)
    line(window, -607, 650)
    ornamentDiamond(window, -605, 8)

    sectionPlaque(window, -618, 570, 90, 0.72)
    label(window, "MUERTES PvP SUFRIDAS", 20, RED, 0, -619, 460, 30)
    fields.deaths = label(window, "—", 45, RED, 0, -650, 420, 60)
    line(window, -714, 650)
    ornamentDiamond(window, -712, 8)

    local firstRow = statBand(window, -727, {
        { title = "DUELOS GANADOS", color = GOLD, icon = "Interface\\Icons\\Ability_DualWield" },
        { title = "CAMPOS DE BATALLA JUGADOS", color = GOLD, icon = "Interface\\Icons\\INV_BannerPVP_02" },
        { title = "BG GANADOS", color = GOLD, icon = "Interface\\Icons\\Achievement_BG_WinWSG" },
    })
    fields.duels, fields.bgPlayed, fields.bgWon = unpack(firstRow)
    local secondRow = statBand(window, -846, {
        { title = "WIN RATE BG", color = GREEN, icon = "Interface\\Icons\\INV_BannerPVP_01" },
        { title = "WIN RATE DUELOS", color = GREEN, icon = "Interface\\Icons\\Ability_DualWield" },
        { title = "CAMPO DE BATALLA FAVORITO", color = CREAM, icon = "Interface\\Icons\\INV_BannerPVP_02", valueSize = 16 },
    })
    fields.bgRate, fields.duelRate, fields.favorite = unpack(secondRow)

    -- The reference's tall two-row composition needs additional height.
    window:SetHeight(990)
    window:SetScript("OnShow", refresh)
end

function ns.UI.ShowGeneral()
    if not window then build() end
    window:Show()
    refresh()
end

SLASH_WARSCORE1 = "/warscore"
SLASH_WARSCORE2 = "/ws"
SlashCmdList.WARSCORE = function()
    ns.UI.ShowGeneral()
end
