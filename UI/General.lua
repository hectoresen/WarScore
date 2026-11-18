local _, ns = ...
ns.UI = ns.UI or {}

-- Native WoW first pass. Ornamental texture assets and reference-image QA remain pending.
local window, fields
local UI_ITERATION = "61"
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

-- Iteration 20: standalone native buttons prevent the UIPanelButtonTemplate's
-- grey/red state textures from leaking through our ornamental tab skin.
local function skinTab(button, text, selected)
    local bg = button:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture("Interface\\Buttons\\WHITE8X8")
    if selected then
        bg:SetVertexColor(0.30, 0.16, 0.045, 0.98)
    else
        bg:SetVertexColor(0.075, 0.055, 0.045, 0.98)
    end
    bg:SetAllPoints(button)
    if selected then
        -- Subtle reflected metal along the active tab, rather than a flat
        -- uninterrupted bronze rectangle.
        local reflection = button:CreateTexture(nil, "BORDER")
        reflection:SetTexture("Interface\\Buttons\\WHITE8X8")
        reflection:SetVertexColor(0.90, 0.62, 0.22, 0.35)
        reflection:SetPoint("TOPLEFT", button, "TOPLEFT", 8, -5)
        reflection:SetPoint("TOPRIGHT", button, "TOPRIGHT", -8, -5)
        reflection:SetHeight(1)
    end

    local function edge(pointA, pointB, width, height, color)
        local tex = button:CreateTexture(nil, "BORDER")
        tex:SetTexture("Interface\\Buttons\\WHITE8X8")
        tex:SetVertexColor(unpack(color))
        if width then tex:SetWidth(width) end
        if height then tex:SetHeight(height) end
        tex:SetPoint(pointA, button, pointA, 0, 0)
        tex:SetPoint(pointB, button, pointB, 0, 0)
    end
    local borderColor = selected and {0.96, 0.68, 0.23, 1} or {0.48, 0.32, 0.13, 0.85}
    edge("TOPLEFT", "TOPRIGHT", nil, selected and 3 or 2, borderColor)
    edge("BOTTOMLEFT", "BOTTOMRIGHT", nil, selected and 3 or 1, borderColor)
    edge("TOPLEFT", "BOTTOMLEFT", selected and 2 or 1, nil, borderColor)
    edge("TOPRIGHT", "BOTTOMRIGHT", selected and 2 or 1, nil, borderColor)

    local title = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetFont("Fonts\\FRIZQT__.TTF", 15, "OUTLINE")
    title:SetTextColor(selected and 1 or 0.75, selected and 0.82 or 0.69, selected and 0.45 or 0.57)
    title:SetAllPoints(button)
    title:SetJustifyH("CENTER")
    title:SetJustifyV("MIDDLE")
    title:SetText(text)
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
local function statBand(parent, y, definitions, secondary)
    local band = CreateFrame("Frame", nil, parent, "BackdropTemplate")
    band:SetSize(704, 112)
    band:SetPoint("TOP", parent, "TOP", 0, y)
    backdrop(band, 0.92)
    band:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 18 })
    band:SetBackdropBorderColor(secondary and 0.62 or 0.82,
        secondary and 0.41 or 0.55, 0.20, 0.96)
    -- Shared side rails strengthen the single-piece metallic frame.
    for _, side in ipairs({ "LEFT", "RIGHT" }) do
        local insetRule = band:CreateTexture(nil, "BORDER")
        insetRule:SetTexture("Interface\\Buttons\\WHITE8X8")
        insetRule:SetVertexColor(0.52, 0.32, 0.11, 0.86)
        insetRule:SetSize(2, 76)
        insetRule:SetPoint(side, band, side, side == "LEFT" and 7 or -7, 0)
    end

    local function trim(point, inset, offset, height, color)
        local rule = band:CreateTexture(nil, "BORDER")
        rule:SetTexture("Interface\\Buttons\\WHITE8X8")
        rule:SetVertexColor(unpack(color))
        rule:SetHeight(height)
        rule:SetPoint(point .. "LEFT", band, point .. "LEFT", inset, offset)
        rule:SetPoint(point .. "RIGHT", band, point .. "RIGHT", -inset, offset)
    end
    -- Inset leather-like center and paired metallic rails share one band border.
    local bandInset = band:CreateTexture(nil, "BACKGROUND")
    bandInset:SetTexture("Interface\\Buttons\\WHITE8X8")
    bandInset:SetVertexColor(0.025, 0.017, 0.012, secondary and 0.43 or 0.25)
    bandInset:SetPoint("TOPLEFT", band, "TOPLEFT", 8, -8)
    bandInset:SetPoint("BOTTOMRIGHT", band, "BOTTOMRIGHT", -8, 8)
    trim("TOP", 9, -4, 2, { 0.88, 0.59, 0.20, secondary and 0.76 or 0.96 })
    trim("TOP", 13, -8, 1, { 0.38, 0.22, 0.08, 0.73 })
    trim("BOTTOM", 9, 4, 2, { 0.71, 0.43, 0.13, secondary and 0.70 or 0.92 })
    trim("BOTTOM", 13, 8, 1, { 0.32, 0.20, 0.07, 0.73 })

    -- An inner top glint creates a more integrated full-width gold frame.
    local glint = band:CreateTexture(nil, "BORDER")
    glint:SetTexture("Interface\\Buttons\\WHITE8X8")
    glint:SetVertexColor(0.93, 0.68, 0.28, secondary and 0.12 or 0.24)
    glint:SetSize(600, 1)
    glint:SetPoint("TOP", band, "TOP", 0, -12)

    -- Use one coherent corner treatment for each full-width bar, instead
    -- of giving each of the three statistics a separate mini-card.
    for _, side in ipairs({ "LEFT", "RIGHT" }) do
        for _, vertical in ipairs({ "TOP", "BOTTOM" }) do
            local corner = band:CreateTexture(nil, "OVERLAY")
            corner:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\ornate_corner")
            corner:SetSize(30, 30)
            corner:SetPoint(vertical .. side, band, vertical .. side,
                side == "LEFT" and 3 or -3, vertical == "TOP" and -3 or 3)
            corner:SetTexCoord(side == "LEFT" and 0 or 1,
                side == "LEFT" and 1 or 0,
                vertical == "TOP" and 0 or 1,
                vertical == "TOP" and 1 or 0)
            corner:SetAlpha(0.87)
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
            divider:SetVertexColor(0.81, 0.53, 0.18, secondary and 0.66 or 0.84)
            divider:SetSize(2, 84)
            divider:SetPoint("CENTER", band, "LEFT", dividerX, 0)
            local bevel = band:CreateTexture(nil, "BORDER")
            bevel:SetTexture("Interface\\Buttons\\WHITE8X8")
            bevel:SetVertexColor(0.23, 0.13, 0.06, 0.95)
            bevel:SetSize(1, 84)
            bevel:SetPoint("CENTER", band, "LEFT", dividerX + 3, 0)
            -- The vertical rules now terminate cleanly inside the outer
            -- border; no disconnected studs or caps at either end.
        end

        -- Decorative icon is never part of the text layout. Native WoW
        -- inventory glyphs still have baked square art; future asset task
        -- replaces these with transparent cutouts, not destructive cropping.
        local icon = segment:CreateTexture(nil, "ARTWORK")
        icon:SetTexture(definition.icon)
        -- Preserve the native WoW illustration instead of rejected clip art.
        -- A supported alpha mask removes the square inventory-tile corners
        -- without zoom-cropping blades and heraldry. Graceful client fallback.
        icon:SetSize(43, 43)
        icon:SetPoint("LEFT", segment, "LEFT", 8, -1)
        icon:SetTexCoord(0, 1, 0, 1)
        icon:SetAlpha(secondary and 0.78 or 0.91)
        if type(segment.CreateMaskTexture) == "function"
            and type(icon.AddMaskTexture) == "function" then
            pcall(function()
                local mask = segment:CreateMaskTexture(nil, "ARTWORK")
                mask:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_mask")
                mask:SetAllPoints(icon)
                icon:AddMaskTexture(mask)
            end)
        end

        -- x=0 means centered on the FULL segment, not offset by its icon.
        -- Width reserves a small gap from the left decorative pictogram.
        local caption = label(segment, definition.title, secondary and 12 or 13,
            CREAM, 0, -12, 145, 38)
        caption:SetTextColor(0.94, 0.84, 0.65)
        local value = label(segment, "—", definition.valueSize or (secondary and 29 or 35),
            secondary and GREEN or GOLD, 0, -53, 145, 45)
        value:SetShadowColor(0.26, 0.14, 0.045, secondary and 0.45 or 0.72)
        value:SetShadowOffset(1, -1)
        values[i] = value
    end
    return values
end

local function formatNumber(value)
    if type(value) ~= "number" then return "—" end
    return tostring(math.floor(value))
end
local function formatCountOrZero(value)
    -- UI presentation only: nil is still nil in the domain model.
    if type(value) ~= "number" then return "0" end
    return formatNumber(value)
end
local function formatRatio(value)
    if type(value) ~= "number" then return "—" end
    return string.format("%.2f", value):gsub("%.", ",")
end
local function formatPercent(value)
    -- Display an empty rate as 0%; absence does NOT imply a real measured 0%.
    if type(value) ~= "number" then return "0%" end
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
    fields.rank:SetText("No disponible")
    fields.duels:SetText(formatCountOrZero(data.duelsWon))
    fields.bgPlayed:SetText(formatCountOrZero(data.battlegroundsPlayed))
    fields.bgWon:SetText(formatCountOrZero(data.battlegroundsWon))
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
    window:SetSize(870, 1060)
    window:SetScale(0.86)
    window:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    window:SetFrameStrata("DIALOG")
    window:SetMovable(true)
    window:EnableMouse(true)
    window:RegisterForDrag("LeftButton")
    window:SetScript("OnDragStart", function(self) self:StartMoving() end)
    window:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
    window:SetClampedToScreen(true)
    -- Iteration 58: treat both owner assets as a single geometric hierarchy.
    -- The outer frame is the visible window perimeter and header, not a
    -- native tooltip/dialog frame stretched over another painting.
    -- Iteration 61: the v60 backing only filled the central 744px,
    -- leaving transparent gutters between the inner 760px painting and
    -- the external metallic rails. Extend the EXISTING owner-tested dark
    -- material to the inside edges of the OUTER frame, not the entire
    -- 870px canvas. This is a geometry repair, not a new painted asset.
    window:Hide()
    local interiorBacking = window:CreateTexture(nil, "BACKGROUND", nil, -7)
    interiorBacking:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\panel_dark_leather_v55")
    interiorBacking:SetSize(790, 930)
    interiorBacking:SetPoint("TOP", window, "TOP", 0, -97)
    interiorBacking:SetVertexColor(0.88, 0.82, 0.76, 1)

    -- The supplied inner gold frame has its own cloth, tabs and material.
    -- Position it under the exterior frame, leaving a real inset on all
    -- sides; do not add old corner textures or duplicated border files.
    local innerArt = window:CreateTexture(nil, "BACKGROUND")
    innerArt:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\inner_frame_owner_v57")
    innerArt:SetSize(760, 890)
    innerArt:SetPoint("TOP", window, "TOP", 0, -110)
    innerArt:SetAlpha(1)

    -- Exterior art has a pre-painted close X, swords medallion and header.
    -- Its obsolete inner ring was removed from the texture to avoid a
    -- duplicate frame around the actual inner asset.
    local outerArt = window:CreateTexture(nil, "BORDER")
    outerArt:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\outer_frame_owner_v58")
    outerArt:SetAllPoints(window)
    outerArt:SetAlpha(1)

    -- Keep brand text dynamic. The background plate is supplied artwork.
    local brandTitle = label(window, "WarScore", 33, GOLD, 0, -27, 360, 43)
    brandTitle:SetShadowColor(0.34, 0.16, 0.03, 0.93)
    brandTitle:SetShadowOffset(1, -1)

    -- Transparent hit target over the close X already baked into outerArt.
    -- A native UIPanelCloseButton here would duplicate the X ornament.
    local close = CreateFrame("Button", nil, window)
    close:SetSize(43, 43)
    close:SetPoint("TOPRIGHT", window, "TOPRIGHT", -48, -28)
    close:SetScript("OnClick", function() window:Hide() end)

    -- The supplied graphic already paints both tab plates; only live text
    -- and hitboxes are needed. Their placement follows the asset's geometry.
    local general = CreateFrame("Button", nil, window)
    general:SetSize(150, 38)
    general:SetPoint("TOPLEFT", window, "TOPLEFT", 188, -124)
    local generalText = label(general, "General", 16, GOLD, 0, -2, 135, 29)
    generalText:SetShadowColor(0.17, 0.08, 0.015, 0.94)
    generalText:SetShadowOffset(1, -1)

    local today = CreateFrame("Button", nil, window)
    today:SetSize(150, 38)
    today:SetPoint("TOPLEFT", window, "TOPLEFT", 361, -124)
    local todayText = label(today, "Hoy", 15, CREAM, 0, -2, 135, 29)
    todayText:SetTextColor(0.72, 0.66, 0.55)
    today:SetScript("OnClick", function()
        if DEFAULT_CHAT_FRAME then
            DEFAULT_CHAT_FRAME:AddMessage("|cffffc34dWarScore:|r La pestaña Hoy estará disponible en una próxima versión.")
        end
    end)

    -- Iteration 55: an original transparent metallic gear, not a WoW
    -- inventory icon (the previous candidates depicted unrelated items).
    -- Reserve the settings position within the inner border; not functional.
    local settingsFrame = CreateFrame("Frame", nil, window, "BackdropTemplate")
    settingsFrame:SetSize(36, 36)
    settingsFrame:SetPoint("TOPRIGHT", window, "TOPRIGHT", -77, -123)
    settingsFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 12,
    })
    settingsFrame:SetBackdropColor(0.02, 0.013, 0.009, 0.97)
    settingsFrame:SetBackdropBorderColor(0.71, 0.48, 0.18, 0.92)
    local settingsIcon = settingsFrame:CreateTexture(nil, "ARTWORK")
    settingsIcon:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\settings_cog")
    settingsIcon:SetSize(30, 30)
    settingsIcon:SetPoint("CENTER", settingsFrame, "CENTER", 0, 0)
    settingsFrame:EnableMouse(true)
    settingsFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("Ajustes (próximamente)", 1, 0.82, 0.40)
        GameTooltip:Show()
    end)
    settingsFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)

    fields = {}
    -- Both banners are baked into innerArt; no separate banner sprites.
    local portraitRing = CreateFrame("Frame", nil, window)
    portraitRing:SetSize(106, 106)
    portraitRing:SetPoint("TOP", window, "TOP", 0, -168)
    local portrait = portraitRing:CreateTexture(nil, "ARTWORK")
    portrait:SetSize(90, 90)
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
            mask:SetSize(90, 90)
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
    ring:SetSize(106, 106)
    ring:SetPoint("CENTER", portraitRing, "CENTER", 0, 0)
    fields.name = label(window, "—", 23, CREAM, 0, -279, 360, 32)
    fields.level = label(window, "—", 15, CREAM, 0, -310, 360, 24)
    -- Iteration 27: authored metallic ribbon artwork, with independent text
    -- and faction crest. A faction badge never indicates verified PvP rank.
    local rankPlate = CreateFrame("Frame", nil, window)
    rankPlate:SetSize(452, 42)
    rankPlate:SetPoint("TOP", window, "TOP", 0, -341)

    -- Iteration 52: screenshot reference comparison. The previous circular
    -- faction badge looked like a stuck-on coin, not the reference's shield.
    -- Do not substitute another fake emblem before a proper shield asset.
    -- The old ribbon's right-hand strokes are baked into its art; a smaller
    -- central crop avoids them while keeping the proven Warcraft palette.
    local shadow = rankPlate:CreateTexture(nil, "BACKGROUND")
    shadow:SetTexture("Interface\\Buttons\\WHITE8X8")
    shadow:SetVertexColor(0.016, 0.011, 0.010, 0.90)
    shadow:SetSize(418, 41)
    shadow:SetPoint("CENTER", rankPlate, "CENTER", 0, -1)
    local leather = rankPlate:CreateTexture(nil, "BACKGROUND")
    leather:SetTexture("Interface\\Buttons\\WHITE8X8")
    leather:SetVertexColor(0.10, 0.045, 0.026, 0.88)
    leather:SetSize(408, 33)
    leather:SetPoint("CENTER", rankPlate, "CENTER", 0, -1)
    local ribbon = rankPlate:CreateTexture(nil, "BORDER")
    ribbon:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\rank_ribbon")
    ribbon:SetTexCoord(0.18, 0.74, 0.16, 0.84)
    ribbon:SetSize(422, 48)
    ribbon:SetPoint("CENTER", rankPlate, "CENTER", 0, 0)
    ribbon:SetAlpha(0.91)

    -- A cohesive inset rim, not separate rectangular orange cap pieces.
    local upperRim = rankPlate:CreateTexture(nil, "ARTWORK")
    upperRim:SetTexture("Interface\\Buttons\\WHITE8X8")
    upperRim:SetVertexColor(0.86, 0.58, 0.23, 0.63)
    upperRim:SetSize(332, 1)
    upperRim:SetPoint("TOP", rankPlate, "TOP", 0, -5)
    local lowerRim = rankPlate:CreateTexture(nil, "ARTWORK")
    lowerRim:SetTexture("Interface\\Buttons\\WHITE8X8")
    lowerRim:SetVertexColor(0.48, 0.28, 0.13, 0.70)
    lowerRim:SetSize(332, 1)
    lowerRim:SetPoint("BOTTOM", rankPlate, "BOTTOM", 0, 5)

    -- Raised faction heraldry occupies the left of the plaque, similar
    -- to the mockup shield's footprint. Avoid the rejected circular coin.
    -- Native Warcraft emblem is provisional until the full carved-shield
    -- asset can be authored and proven in the Forever client.
    local heraldry = CreateFrame("Frame", nil, rankPlate, "BackdropTemplate")
    heraldry:SetSize(51, 51)
    heraldry:SetPoint("LEFT", rankPlate, "LEFT", 47, 1)
    heraldry:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 15,
    })
    heraldry:SetBackdropColor(0.11, 0.035, 0.025, 0.97)
    heraldry:SetBackdropBorderColor(0.95, 0.68, 0.26, 1)
    local heraldryIcon = heraldry:CreateTexture(nil, "ARTWORK")
    heraldryIcon:SetTexture(UnitFactionGroup("player") == "Alliance"
        and "Interface\\Icons\\INV_BannerPVP_02"
        or "Interface\\Icons\\INV_BannerPVP_01")
    heraldryIcon:SetSize(37, 37)
    heraldryIcon:SetPoint("CENTER", heraldry, "CENTER", 0, 0)
    heraldryIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    -- Clean centered rank inscription: a small section name and an honest
    -- unavailable value, like the two-tier reference ribbon.
    -- Reserve a visible margin below the rank value and above the HK divider.
    local rankCaption = label(rankPlate, "Rango PvP", 13, CREAM, 30, -3, 280, 15)
    rankCaption:SetTextColor(0.89, 0.70, 0.39)
    fields.rank = label(rankPlate, "No disponible", 18, GOLD, 30, -19, 280, 20)
    fields.rank:SetShadowColor(0.14, 0.06, 0.01, 0.85)
    fields.rank:SetShadowOffset(1, -1)
    line(window, -391, 632)
    ornamentDiamond(window, -389, 8)
    sectionPlaque(window, -405, 570, 110, 0.92)

    -- Iteration 21: strengthen the main lifetime-HK hero section without
    -- introducing fake values or baking the changing number into artwork.
    local hkTitle = label(window, "MUERTES CON HONOR", 24, GOLD, 0, -406, 460, 35)
    hkTitle:SetShadowColor(0.22, 0.10, 0.02, 0.9)
    hkTitle:SetShadowOffset(1, -1)

    fields.hk = label(window, "—", 64, GOLD, 0, -437, 500, 70)
    fields.hk:SetShadowColor(0.60, 0.30, 0.035, 0.9)
    fields.hk:SetShadowOffset(2, -2)

    -- Iteration 23: original transparent TGA laurel artwork, one mirrored copy
    -- per side. Keeps dynamic HK FontString unobstructed.
    for _, side in ipairs({ -1, 1 }) do
        local laurel = window:CreateTexture(nil, "ARTWORK")
        laurel:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\hk_laurel")
        -- Lift and slightly compact the wreaths so they frame HK, not the ratio divider.
        laurel:SetSize(96, 96)
        laurel:SetPoint("TOP", window, "TOP", side * 175, -419)
        if side == 1 then
            laurel:SetTexCoord(1, 0, 0, 1)
        end
        laurel:SetAlpha(0.94)
    end
    -- Iteration 28: show both lifetime counters first, then their derived ratios.
    -- Keep this whole section inside the original space above the lower bands.
    line(window, -514, 632)
    ornamentDiamond(window, -512, 8)

    -- Iteration 29: deaths are a secondary lifetime counter, not another hero.
    -- Keep them directly below HK while deliberately lowering visual weight.
    sectionPlaque(window, -525, 500, 91, 0.48)
    label(window, "MUERTES PvP SUFRIDAS", 17, { 0.85, 0.51, 0.46 }, 0, -534, 430, 27)
    fields.deaths = label(window, "—", 39, RED, 0, -563, 390, 54)
    fields.deaths:SetShadowColor(0.32, 0.05, 0.035, 0.64)
    fields.deaths:SetShadowOffset(1, -1)

    -- No floating side strokes: the soft plaque and red number carry this KPI.

    line(window, -624, 632)
    ornamentDiamond(window, -622, 8)

    local centerDivider = window:CreateTexture(nil, "BORDER")
    centerDivider:SetTexture("Interface\\Buttons\\WHITE8X8")
    centerDivider:SetVertexColor(0.6, 0.39, 0.14, 0.8)
    centerDivider:SetSize(2, 93)
    centerDivider:SetPoint("TOP", window, "TOP", 0, -636)

    label(window, "HK/D", 20, GOLD, -165, -636, 270, 29)
    label(window, "KB/D", 20, GOLD, 165, -636, 270, 29)
    fields.hkd = label(window, "—", 39, CREAM, -165, -668, 270, 48)
    fields.kbd = label(window, "—", 39, CREAM, 165, -668, 270, 48)
    fields.hkd:SetShadowColor(0.34, 0.19, 0.06, 0.72)
    fields.hkd:SetShadowOffset(1, -1)
    fields.kbd:SetShadowColor(0.34, 0.19, 0.06, 0.72)
    fields.kbd:SetShadowOffset(1, -1)
    local hkDescription = label(window, "HK / muertes PvP sufridas", 12, CREAM, -165, -711, 300, 23)
    hkDescription:SetTextColor(0.77, 0.69, 0.58)
    local kbDescription = label(window, "Golpes de gracia / muertes PvP", 12, CREAM, 165, -711, 300, 23)
    kbDescription:SetTextColor(0.77, 0.69, 0.58)

    line(window, -749, 632)
    ornamentDiamond(window, -747, 8)

    local firstRow = statBand(window, -758, {
        { title = "DUELOS GANADOS", color = GOLD, icon = "Interface\\Icons\\Ability_DualWield" },
        { title = "CAMPOS DE BATALLA JUGADOS", color = GOLD, icon = "Interface\\Icons\\INV_BannerPVP_02" },
        { title = "BG GANADOS", color = GOLD, icon = "Interface\\Icons\\Achievement_BG_WinWSG" },
    })
    fields.duels, fields.bgPlayed, fields.bgWon = unpack(firstRow)
    local secondRow = statBand(window, -878, {
        { title = "WIN RATE BG", color = GREEN, icon = "Interface\\Icons\\INV_BannerPVP_01" },
        { title = "WIN RATE DUELOS", color = GREEN, icon = "Interface\\Icons\\Ability_DualWield" },
        { title = "CAMPO DE BATALLA FAVORITO", color = GREEN, icon = "Interface\\Icons\\INV_BannerPVP_02", valueSize = 17 },
    }, true)
    fields.bgRate, fields.duelRate, fields.favorite = unpack(secondRow)

    -- The reference's tall two-row composition needs additional height.
    window:SetHeight(1060)
    window:SetScript("OnShow", refresh)
end

function ns.UI.ShowGeneral()
    if not window then build() end
    window:Show()
    refresh()
end

SLASH_WARSCORE1 = "/warscore"
SLASH_WARSCORE2 = "/ws"
SlashCmdList.WARSCORE = function(message)
    local command = type(message) == "string" and message:match("^%s*(%S+)") or nil
    if command and command:lower() == "version" then
        if DEFAULT_CHAT_FRAME then
            DEFAULT_CHAT_FRAME:AddMessage("|cffffc34dWarScore|r UI iteración " .. UI_ITERATION)
        end
        return
    end
    ns.UI.ShowGeneral()
end
