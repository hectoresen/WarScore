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
    texture:SetPoint(ySide .. xSide, parent, ySide .. xSide, 0, 0)
    -- Mirror the single authored corner art to all four positions.
    texture:SetTexCoord(xSide == "LEFT" and 0 or 1, xSide == "LEFT" and 1 or 0,
        ySide == "TOP" and 0 or 1, ySide == "TOP" and 1 or 0)
end

local function sectionPlaque(parent, y, width, height, alpha)
    local shade = parent:CreateTexture(nil, "BACKGROUND")
    shade:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\section_plaque")
    shade:SetVertexColor(1, 1, 1, alpha or 0.9)
    shade:SetSize(width, height)
    shade:SetPoint("TOP", parent, "TOP", 0, y)
    return shade
end

local function card(parent, x, y, w, h, title, color, iconPath)
    local panel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    panel:SetSize(w, h)
    panel:SetPoint("TOP", parent, "TOP", x, y)
    backdrop(panel, 0.92)
    local edge = panel:CreateTexture(nil, "BORDER")
    edge:SetTexture("Interface\\Buttons\\WHITE8X8")
    edge:SetVertexColor(0.63, 0.40, 0.16, 0.85)
    edge:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    edge:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, 0)
    edge:SetHeight(2)
    panel:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 15 })
    panel:SetBackdropBorderColor(0.64, 0.43, 0.19, 0.95)
    local leftStud = panel:CreateTexture(nil, "OVERLAY")
    leftStud:SetTexture("Interface\\Buttons\\WHITE8X8")
    leftStud:SetVertexColor(0.92, 0.67, 0.27, 0.9)
    leftStud:SetSize(5, 5)
    leftStud:SetPoint("TOPLEFT", panel, "TOPLEFT", 5, -5)
    local rightStud = panel:CreateTexture(nil, "OVERLAY")
    rightStud:SetTexture("Interface\\Buttons\\WHITE8X8")
    rightStud:SetVertexColor(0.92, 0.67, 0.27, 0.9)
    rightStud:SetSize(5, 5)
    rightStud:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -5, -5)
    if iconPath then
        local emblem = panel:CreateTexture(nil, "ARTWORK")
        emblem:SetTexture(iconPath)
        emblem:SetSize(28, 28)
        emblem:SetPoint("TOP", panel, "TOP", 0, -7)
        label(panel, title, 11, CREAM, 0, -35, w - 12, 28)
        return label(panel, "—", 25, color or GOLD, 0, -67, w - 10, 35)
    end
    label(panel, title, 12, CREAM, 0, -12, w - 12, 34)
    return label(panel, "—", 26, color or GOLD, 0, -51, w - 10, 38)
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
    local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", window, "TOPRIGHT", -12, -11)
    close:SetScript("OnClick", function() window:Hide() end)

    local general = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    general:SetSize(140, 32)
    general:SetPoint("TOPLEFT", window, "TOPLEFT", 30, -67)
    general:SetText("General")
    general:Disable()
    accent(window, "TOPLEFT", "TOPLEFT", 30, -101, 140, 3, GOLD)
    local today = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    today:SetSize(140, 32)
    today:SetPoint("LEFT", general, "RIGHT", 7, 0)
    today:SetText("Hoy")
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
    local rankPlate = CreateFrame("Frame", nil, window, "BackdropTemplate")
    rankPlate:SetSize(440, 36)
    rankPlate:SetPoint("TOP", window, "TOP", 0, -297)
    backdrop(rankPlate, 0.95)
    rankPlate:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16 })
    rankPlate:SetBackdropBorderColor(0.58, 0.35, 0.12, 0.9)
    accent(rankPlate, "LEFT", "LEFT", 10, 0, 4, 24, GOLD)
    accent(rankPlate, "RIGHT", "RIGHT", -10, 0, 4, 24, GOLD)
    fields.rank = label(rankPlate, "Rango PvP · No disponible", 17, GOLD, 0, -3, 430, 30)
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

    fields.duels = card(window, -237, -727, 225, 112, "DUELOS GANADOS", GOLD, "Interface\\Icons\\Ability_DualWield")
    fields.bgPlayed = card(window, 0, -727, 225, 112, "CAMPOS DE BATALLA JUGADOS", GOLD, "Interface\\Icons\\INV_BannerPVP_02")
    fields.bgWon = card(window, 237, -727, 225, 112, "BG GANADOS", GOLD, "Interface\\Icons\\Achievement_BG_WinWSG")
    -- Compact second row: remains a distinct ornamental row.
    -- The frame is tall enough to contain both rows; game UI scale can reduce size.
    fields.bgRate = card(window, -237, -846, 225, 112, "WIN RATE BG", GREEN, "Interface\\Icons\\INV_BannerPVP_01")
    fields.duelRate = card(window, 0, -846, 225, 112, "WIN RATE DUELOS", GREEN, "Interface\\Icons\\Ability_DualWield")
    fields.favorite = card(window, 237, -846, 225, 112, "CAMPO DE BATALLA FAVORITO", CREAM, "Interface\\Icons\\INV_BannerPVP_02")
    fields.favorite:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")

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
