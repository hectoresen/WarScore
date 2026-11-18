local _, ns = ...
ns.UI = ns.UI or {}

-- Native WoW first pass. Ornamental texture assets and reference-image QA remain pending.
local window, fields
local UI_ITERATION = "51"
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

-- Iteration 27: one authored transparent torn-cloth texture per faction.
-- The faction emblems are still provisional native icons, separate from the art.
local function ornament(parent, side)
    local sign = side == "LEFT" and -1 or 1
    local faction = UnitFactionGroup("player")
    local isAlliance = faction == "Alliance"
    local banner = CreateFrame("Frame", nil, parent)
    banner:SetSize(126, 228)
    banner:SetPoint("TOP", parent, "TOP", sign * 270, -125)

    local cloth = banner:CreateTexture(nil, "BACKGROUND")
    cloth:SetTexture(isAlliance
        and "Interface\\AddOns\\WarScore\\Media\\General\\banner_alliance_v2"
        or "Interface\\AddOns\\WarScore\\Media\\General\\banner_horde_embroidered")
    cloth:SetAllPoints(banner)
    cloth:SetAlpha(0.97)
    -- A dark hanging rod and two small side clasps keep the banner looking
    -- suspended from the window instead of pasted onto its background.
    local rodShadow = banner:CreateTexture(nil, "BORDER")
    rodShadow:SetTexture("Interface\\Buttons\\WHITE8X8")
    rodShadow:SetVertexColor(0.18, 0.10, 0.045, 0.92)
    rodShadow:SetSize(116, 4)
    rodShadow:SetPoint("TOP", banner, "TOP", 0, 0)
    for _, hangerX in ipairs({ -47, 47 }) do
        local hanger = banner:CreateTexture(nil, "ARTWORK")
        hanger:SetTexture("Interface\\Buttons\\WHITE8X8")
        hanger:SetVertexColor(0.73, 0.50, 0.18, 0.91)
        hanger:SetSize(5, 13)
        hanger:SetPoint("TOP", banner, "TOP", hangerX, -5)
    end

    -- Metal hook and attachment, all within the banner's own bounding box.
    local mount = banner:CreateTexture(nil, "BORDER")
    mount:SetTexture("Interface\\Buttons\\WHITE8X8")
    mount:SetVertexColor(0.39, 0.27, 0.11, 0.94)
    mount:SetSize(108, 2)
    mount:SetPoint("TOP", banner, "TOP", 0, -4)
    for _, x in ipairs({ -44, 44 }) do
        local rivet = banner:CreateTexture(nil, "OVERLAY")
        rivet:SetTexture("Interface\\Buttons\\WHITE8X8")
        rivet:SetVertexColor(0.98, 0.77, 0.34, 0.94)
        rivet:SetSize(5, 5)
        rivet:SetPoint("TOP", banner, "TOP", x, -10)
    end

    -- Horde heraldry is baked into the textile TGA: no separate inventory icon.
    -- Alliance retains a provisional masked emblem pending integrated artwork.
    if isAlliance then
        -- Blend the faction emblem into the cloth instead of showing a hard,
        -- square inventory-icon tile. Reuse the mask already proven on portraits.
        local icon = banner:CreateTexture(nil, "ARTWORK")
        icon:SetTexture("Interface\\Icons\\INV_BannerPVP_02")
        -- Less sticker-like: soften the icon and leave more textured cloth around it.
        icon:SetSize(68, 68)
        icon:SetPoint("TOP", banner, "TOP", 0, -42)
        icon:SetAlpha(0.68)
        local masked = false
        if type(banner.CreateMaskTexture) == "function"
            and type(icon.AddMaskTexture) == "function" then
            masked = pcall(function()
                local mask = banner:CreateMaskTexture(nil, "ARTWORK")
                mask:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_mask")
                mask:SetAllPoints(icon)
                icon:AddMaskTexture(mask)
            end)
        end
        if not masked then
            -- Keep the fallback conservative on clients without masking support.
            icon:ClearAllPoints()
            icon:SetSize(52, 52)
            icon:SetPoint("TOP", banner, "TOP", 0, -43)
        end
    end
    -- Subtle horizontal seam under the heraldry, like an embroidered patch
    -- integrated with the fabric. Do not add a square badge behind the logo.
    local seam = banner:CreateTexture(nil, "BORDER")
    seam:SetTexture("Interface\\Buttons\\WHITE8X8")
    seam:SetVertexColor(0.60, 0.34, 0.12, 0.38)
    seam:SetSize(63, 1)
    seam:SetPoint("TOP", banner, "TOP", 0, -113)
    -- Light vertical thread lines suggest embroidered cloth, not solid panels.
    for _, x in ipairs({ -47, 47 }) do
        local stitch = banner:CreateTexture(nil, "BORDER")
        stitch:SetTexture("Interface\\Buttons\\WHITE8X8")
        stitch:SetVertexColor(0.75, 0.47, 0.22, 0.28)
        stitch:SetSize(1, 149)
        stitch:SetPoint("TOP", banner, "TOP", x, -21)
    end
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
    -- Iteration 43: one dark panel INSIDE an actual native WoW dialog border.
    -- The frame bounds, not a slightly oversized black rectangle, define
    -- the visible window. The old central overlay created a hard-edged box.
    -- Original opaque warm-grey/aged-stone texture: low contrast grain and
    -- soft vignette replace the previous flat almost-black slab. Keep the
    -- art inset inside the native dialog border and retain legibility.
    local shellBackground = window:CreateTexture(nil, "BACKGROUND")
    shellBackground:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\panel_stone_dark")
    shellBackground:SetVertexColor(1, 1, 1, 1)
    shellBackground:SetPoint("TOPLEFT", window, "TOPLEFT", 12, -12)
    shellBackground:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -12, 12)
    window:Hide()

    -- WoW-native dialog chrome; this is the OUTERMOST visible perimeter.
    local border = CreateFrame("Frame", nil, window, "BackdropTemplate")
    border:SetPoint("TOPLEFT", window, "TOPLEFT", 2, -2)
    border:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -2, 2)
    border:SetBackdrop({ edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 28 })
    border:SetBackdropBorderColor(0.91, 0.80, 0.63, 1)
    border:EnableMouse(false)

    -- Separate INSIDE frame embracing navigation and metrics, like the
    -- reference spellbook/panel composition. Keep it under all widgets.
    local innerPanel = CreateFrame("Frame", nil, window, "BackdropTemplate")
    innerPanel:SetPoint("TOPLEFT", window, "TOPLEFT", 22, -60)
    innerPanel:SetPoint("BOTTOMRIGHT", window, "BOTTOMRIGHT", -22, 17)
    innerPanel:SetBackdrop({ edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 14 })
    innerPanel:SetBackdropBorderColor(0.62, 0.45, 0.24, 0.80)
    innerPanel:EnableMouse(false)

    -- No parallel square rails competing with the native exterior border
    -- and the separate framed inner content area.
    cornerAccent(window, "LEFT", "TOP")
    cornerAccent(window, "RIGHT", "TOP")
    cornerAccent(window, "LEFT", "BOTTOM")
    cornerAccent(window, "RIGHT", "BOTTOM")

    local header = CreateFrame("Frame", nil, window, "BackdropTemplate")
    header:SetPoint("TOPLEFT", window, "TOPLEFT", 10, -10)
    header:SetPoint("TOPRIGHT", window, "TOPRIGHT", -10, -10)
    header:SetHeight(45)
    backdrop(header, 1)
    -- Feathered metallic nameplate; all text stays a live FontString.
    local headerPlate = header:CreateTexture(nil, "BORDER")
    headerPlate:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\section_plaque")
    headerPlate:SetSize(470, 49)
    headerPlate:SetVertexColor(0.80, 0.69, 0.48, 0.66)
    headerPlate:SetPoint("CENTER", header, "CENTER", 0, 0)
    local brandTitle = label(header, "WarScore", 33, GOLD, 0, -2, 350, 42)
    brandTitle:SetShadowColor(0.42, 0.22, 0.03, 0.9)
    brandTitle:SetShadowOffset(1, -1)
    accent(header, "LEFT", "LEFT", 24, 0, 90, 2, { 0.65, 0.43, 0.15 })
    accent(header, "RIGHT", "RIGHT", -24, 0, 90, 2, { 0.65, 0.43, 0.15 })
    accent(header, "BOTTOM", "BOTTOM", 0, 0, 700, 2, { 0.50, 0.32, 0.13 })
    accent(header, "BOTTOM", "BOTTOM", 0, 1, 180, 1, GOLD)
    accent(header, "TOP", "TOP", 0, 0, 320, 1, { 0.45, 0.31, 0.13 })
    -- No decorative upper-left medallion: rejected by owner in iteration 25.
    -- Preserve this clear header for the native close button and title.

    local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", window, "TOPRIGHT", -12, -11)
    close:SetScript("OnClick", function() window:Hide() end)

    local general = CreateFrame("Button", nil, window)
    general:SetSize(140, 32)
    general:SetPoint("TOPLEFT", window, "TOPLEFT", 38, -67)
    skinTab(general, "General", true)
    -- Selected tab has no click handler; its active style does not depend on a disabled state.
    local today = CreateFrame("Button", nil, window)
    today:SetSize(140, 32)
    today:SetPoint("LEFT", general, "RIGHT", 7, 0)
    skinTab(today, "Hoy", false)
    today:SetScript("OnClick", function()
        if DEFAULT_CHAT_FRAME then DEFAULT_CHAT_FRAME:AddMessage("|cffffc34dWarScore:|r La pestaña Hoy estará disponible en una próxima versión.") end
    end)
    -- Shared metallic tab rail ties both tabs to the same navigation area.
    local tabRail = window:CreateTexture(nil, "BORDER")
    tabRail:SetTexture("Interface\\Buttons\\WHITE8X8")
    tabRail:SetVertexColor(0.66, 0.43, 0.16, 0.86)
    tabRail:SetSize(296, 2)
    tabRail:SetPoint("TOPLEFT", window, "TOPLEFT", 38, -101)

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
    -- Iteration 27: authored metallic ribbon artwork, with independent text
    -- and faction crest. A faction badge never indicates verified PvP rank.
    local rankPlate = CreateFrame("Frame", nil, window)
    rankPlate:SetSize(452, 42)
    rankPlate:SetPoint("TOP", window, "TOP", 0, -296)

    -- Iteration 51: the extra outer ribbon UVs tested in 50 expose
    -- a visibly striped right edge in Forever. Crop that artifact away.
    -- Build material depth inside the existing plaque instead of adding
    -- separate leaves, endcaps, or another orange rectangular asset.
    local underlay = rankPlate:CreateTexture(nil, "BACKGROUND")
    underlay:SetTexture("Interface\\Buttons\\WHITE8X8")
    underlay:SetVertexColor(0.017, 0.013, 0.011, 0.88)
    underlay:SetSize(402, 37)
    underlay:SetPoint("CENTER", rankPlate, "CENTER", 0, -1)
    local backing = rankPlate:CreateTexture(nil, "BACKGROUND")
    backing:SetTexture("Interface\\Buttons\\WHITE8X8")
    backing:SetVertexColor(0.075, 0.047, 0.029, 0.86)
    backing:SetSize(388, 30)
    backing:SetPoint("CENTER", rankPlate, "CENTER", 0, -1)

    local ribbon = rankPlate:CreateTexture(nil, "BORDER")
    ribbon:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\rank_ribbon")
    ribbon:SetTexCoord(0.12, 0.88, 0.13, 0.87)
    ribbon:SetSize(432, 48)
    ribbon:SetPoint("CENTER", rankPlate, "CENTER", 0, 0)
    ribbon:SetAlpha(0.94)

    -- A continuous inset bezel, behind the centered inscription.
    -- All horizontal details finish beneath the original ribbon art.
    local innerTop = rankPlate:CreateTexture(nil, "ARTWORK")
    innerTop:SetTexture("Interface\\Buttons\\WHITE8X8")
    innerTop:SetVertexColor(0.91, 0.64, 0.29, 0.60)
    innerTop:SetSize(334, 1)
    innerTop:SetPoint("TOP", rankPlate, "TOP", 13, -4)
    local innerShade = rankPlate:CreateTexture(nil, "ARTWORK")
    innerShade:SetTexture("Interface\\Buttons\\WHITE8X8")
    innerShade:SetVertexColor(0.25, 0.17, 0.11, 0.78)
    innerShade:SetSize(334, 2)
    innerShade:SetPoint("BOTTOM", rankPlate, "BOTTOM", 13, 5)

    -- Integrate the faction crest as a round, overlapping metallic boss.
    -- This is faction decoration only, never an invented PvP rank insignia.
    local crestHolder = CreateFrame("Frame", nil, rankPlate)
    crestHolder:SetSize(48, 48)
    crestHolder:SetPoint("LEFT", rankPlate, "LEFT", 16, 0)
    local boss = crestHolder:CreateTexture(nil, "BORDER")
    boss:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_ring_transparent")
    boss:SetSize(58, 58)
    boss:SetPoint("CENTER", crestHolder, "CENTER", 0, 0)
    local crest = crestHolder:CreateTexture(nil, "ARTWORK")
    local rankFaction = UnitFactionGroup("player")
    crest:SetTexture(rankFaction == "Alliance"
        and "Interface\\Icons\\INV_BannerPVP_02"
        or "Interface\\Icons\\INV_BannerPVP_01")
    crest:SetSize(34, 34)
    crest:SetPoint("CENTER", crestHolder, "CENTER", 0, 0)
    if type(crestHolder.CreateMaskTexture) == "function"
        and type(crest.AddMaskTexture) == "function" then
        pcall(function()
            local mask = crestHolder:CreateMaskTexture(nil, "ARTWORK")
            mask:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_mask")
            mask:SetAllPoints(crest)
            crest:AddMaskTexture(mask)
        end)
    end

    -- Clean centered rank inscription: a small section name and an honest
    -- unavailable value, like the two-tier reference ribbon.
    -- Reserve a visible margin below the rank value and above the HK divider.
    local rankCaption = label(rankPlate, "Rango PvP", 13, CREAM, 12, -3, 320, 15)
    rankCaption:SetTextColor(0.89, 0.70, 0.39)
    fields.rank = label(rankPlate, "No disponible", 18, GOLD, 12, -19, 320, 20)
    fields.rank:SetShadowColor(0.14, 0.06, 0.01, 0.85)
    fields.rank:SetShadowOffset(1, -1)
    line(window, -341, 650)
    ornamentDiamond(window, -339, 8)
    sectionPlaque(window, -353, 570, 116, 0.92)

    -- Iteration 21: strengthen the main lifetime-HK hero section without
    -- introducing fake values or baking the changing number into artwork.
    local hkTitle = label(window, "MUERTES CON HONOR", 24, GOLD, 0, -355, 460, 35)
    hkTitle:SetShadowColor(0.22, 0.10, 0.02, 0.9)
    hkTitle:SetShadowOffset(1, -1)

    fields.hk = label(window, "—", 64, GOLD, 0, -388, 500, 78)
    fields.hk:SetShadowColor(0.60, 0.30, 0.035, 0.9)
    fields.hk:SetShadowOffset(2, -2)

    -- Iteration 23: original transparent TGA laurel artwork, one mirrored copy
    -- per side. Keeps dynamic HK FontString unobstructed.
    for _, side in ipairs({ -1, 1 }) do
        local laurel = window:CreateTexture(nil, "ARTWORK")
        laurel:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\hk_laurel")
        -- Lift and slightly compact the wreaths so they frame HK, not the ratio divider.
        laurel:SetSize(96, 96)
        laurel:SetPoint("TOP", window, "TOP", side * 183, -371)
        if side == 1 then
            laurel:SetTexCoord(1, 0, 0, 1)
        end
        laurel:SetAlpha(0.94)
    end
    -- Iteration 28: show both lifetime counters first, then their derived ratios.
    -- Keep this whole section inside the original space above the lower bands.
    line(window, -477, 650)
    ornamentDiamond(window, -475, 8)

    -- Iteration 29: deaths are a secondary lifetime counter, not another hero.
    -- Keep them directly below HK while deliberately lowering visual weight.
    sectionPlaque(window, -490, 500, 91, 0.48)
    label(window, "MUERTES PvP SUFRIDAS", 17, { 0.85, 0.51, 0.46 }, 0, -497, 430, 27)
    fields.deaths = label(window, "—", 39, RED, 0, -525, 390, 54)
    fields.deaths:SetShadowColor(0.32, 0.05, 0.035, 0.64)
    fields.deaths:SetShadowOffset(1, -1)

    -- No floating side strokes: the soft plaque and red number carry this KPI.

    line(window, -590, 650)
    ornamentDiamond(window, -588, 8)

    local centerDivider = window:CreateTexture(nil, "BORDER")
    centerDivider:SetTexture("Interface\\Buttons\\WHITE8X8")
    centerDivider:SetVertexColor(0.6, 0.39, 0.14, 0.8)
    centerDivider:SetSize(2, 93)
    centerDivider:SetPoint("TOP", window, "TOP", 0, -603)

    label(window, "HK/D", 20, GOLD, -165, -601, 270, 29)
    label(window, "KB/D", 20, GOLD, 165, -601, 270, 29)
    fields.hkd = label(window, "—", 39, CREAM, -165, -632, 270, 50)
    fields.kbd = label(window, "—", 39, CREAM, 165, -632, 270, 50)
    fields.hkd:SetShadowColor(0.34, 0.19, 0.06, 0.72)
    fields.hkd:SetShadowOffset(1, -1)
    fields.kbd:SetShadowColor(0.34, 0.19, 0.06, 0.72)
    fields.kbd:SetShadowOffset(1, -1)
    local hkDescription = label(window, "HK / muertes PvP sufridas", 12, CREAM, -165, -680, 300, 24)
    hkDescription:SetTextColor(0.77, 0.69, 0.58)
    local kbDescription = label(window, "Golpes de gracia / muertes PvP", 12, CREAM, 165, -680, 300, 24)
    kbDescription:SetTextColor(0.77, 0.69, 0.58)

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
        { title = "CAMPO DE BATALLA FAVORITO", color = GREEN, icon = "Interface\\Icons\\INV_BannerPVP_02", valueSize = 17 },
    }, true)
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
