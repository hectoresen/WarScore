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
    tex:SetTexture("Interface\\\\Buttons\\\\WHITE8X8")
    tex:SetVertexColor(0.065, 0.048, 0.038, alpha or 0.96)
    return tex
end

local function line(parent, y, width)
    local texture = parent:CreateTexture(nil, "BORDER")
    texture:SetTexture("Interface\\\\Buttons\\\\WHITE8X8")
    texture:SetVertexColor(0.72, 0.48, 0.17, 0.85)
    texture:SetSize(width or 620, 2)
    texture:SetPoint("TOP", parent, "TOP", 0, y)
end

local function card(parent, x, y, w, h, title, color)
    local panel = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    panel:SetSize(w, h)
    panel:SetPoint("TOP", parent, "TOP", x, y)
    backdrop(panel, 0.92)
    local edge = panel:CreateTexture(nil, "BORDER")
    edge:SetTexture("Interface\\\\Buttons\\\\WHITE8X8")
    edge:SetVertexColor(0.63, 0.40, 0.16, 0.85)
    edge:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, 0)
    edge:SetPoint("TOPRIGHT", panel, "TOPRIGHT", 0, 0)
    edge:SetHeight(2)
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

    label(window, "WarScore", 31, GOLD, 0, -14, 350, 42)
    local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", window, "TOPRIGHT", -12, -11)
    close:SetScript("OnClick", function() window:Hide() end)

    local general = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    general:SetSize(140, 32)
    general:SetPoint("TOPLEFT", window, "TOPLEFT", 30, -67)
    general:SetText("General")
    general:Disable()
    local today = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    today:SetSize(140, 32)
    today:SetPoint("LEFT", general, "RIGHT", 7, 0)
    today:SetText("Hoy")
    today:SetScript("OnClick", function()
        if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage("|cffffc34dWarScore:|r La pestaña Hoy estará disponible en una próxima versión.") end
    end)

    fields = {}
    local portraitRing = CreateFrame("Frame", nil, window)
    portraitRing:SetSize(126, 126)
    portraitRing:SetPoint("TOP", window, "TOP", 0, -105)
    local portrait = portraitRing:CreateTexture(nil, "ARTWORK")
    portrait:SetSize(108, 108)
    portrait:SetPoint("CENTER")
    fields.portrait = portrait
    local ring = portraitRing:CreateTexture(nil, "OVERLAY")
    ring:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    ring:SetSize(150, 150)
    ring:SetPoint("CENTER", portraitRing, "CENTER", 0, 0)
    fields.name = label(window, "—", 24, CREAM, 0, -233, 360, 34)
    fields.level = label(window, "—", 15, CREAM, 0, -269, 360, 25)
    fields.rank = label(window, "Rango PvP · No disponible", 17, GOLD, 0, -302, 440, 30)
    line(window, -341, 650)

    label(window, "MUERTES CON HONOR", 23, GOLD, 0, -355, 460, 35)
    fields.hk = label(window, "—", 57, GOLD, 0, -388, 500, 78)
    line(window, -475, 650)

    label(window, "HK/D  ⓘ", 19, CREAM, -165, -490, 270, 30)
    label(window, "KB/D  ⓘ", 19, CREAM, 165, -490, 270, 30)
    fields.hkd = label(window, "—", 37, GOLD, -165, -524, 270, 53)
    fields.kbd = label(window, "—", 37, GOLD, 165, -524, 270, 53)
    label(window, "HK / muertes PvP sufridas", 12, CREAM, -165, -576, 300, 25)
    label(window, "Golpes de gracia / muertes PvP", 12, CREAM, 165, -576, 300, 25)
    line(window, -607, 650)

    label(window, "MUERTES PvP SUFRIDAS", 20, RED, 0, -619, 460, 30)
    fields.deaths = label(window, "—", 45, RED, 0, -650, 420, 60)
    line(window, -714, 650)

    fields.duels = card(window, -237, -727, 225, 112, "DUELOS GANADOS")
    fields.bgPlayed = card(window, 0, -727, 225, 112, "CAMPOS DE BATALLA JUGADOS")
    fields.bgWon = card(window, 237, -727, 225, 112, "BG GANADOS")
    -- Compact second row: remains a distinct ornamental row.
    -- The frame is tall enough to contain both rows; game UI scale can reduce size.
    fields.bgRate = card(window, -237, -846, 225, 112, "WIN RATE BG", GREEN)
    fields.duelRate = card(window, 0, -846, 225, 112, "WIN RATE DUELOS", GREEN)
    fields.favorite = card(window, 237, -846, 225, 112, "CAMPO DE BATALLA FAVORITO", CREAM)
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
