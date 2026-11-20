local _, ns = ...
ns.UI = ns.UI or {}

-- Native WoW first pass. Ornamental texture assets and reference-image QA remain pending.
local window, fields
local showGeneralView, showSettingsView
local UI_ITERATION = "132"
local GOLD = { 0.95, 0.72, 0.27 }
local CREAM = { 0.92, 0.83, 0.67 }
local RED = { 0.96, 0.43, 0.39 }
local GREEN = { 0.50, 0.88, 0.31 }
local function rgb(color) return unpack(color) end
local function text(key, ...) return ns.L:Get(key, ...) end

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
    -- v76: inset both owner-painted rows 8 units per side to clear parent rail.
    local bandWidth = 688
    -- v102: slightly shorter frame viewport while keeping captions fixed.
    band:SetSize(bandWidth, 100)
    -- Shared exact horizontal center for both stat cards.
    band:SetPoint("TOP", parent, "TOP", 3, y)
    backdrop(band, 0.92)
    -- Owner artwork supplies all metal rails, corners and vertical dividers.
    -- v74 top frame remains unchanged; v75 applies only to lower card row.
    local frameArt = band:CreateTexture(nil, "BORDER")
    frameArt:SetTexture(secondary
        and "Interface\\AddOns\\WarScore\\Media\\General\\stat_band_bottom_owner_v75"
        or "Interface\\AddOns\\WarScore\\Media\\General\\stat_band_top_owner_v74")
    frameArt:SetAllPoints(band)

    local values = {}
    -- The lower owner's frame has asymmetric dividers at ~24% and ~46%.
    -- Allocate real column widths so labels and values belong to their cells.
    local widths = secondary
        and { bandWidth * 171 / 704, bandWidth * 153 / 704, bandWidth * 380 / 704 }
        or { bandWidth / 3, bandWidth / 3, bandWidth / 3 }
    local offset = 0
    for i, definition in ipairs(definitions) do
        local segmentWidth = widths[i]
        local segment = CreateFrame("Frame", nil, band)
        segment:SetSize(segmentWidth, 96)
        segment:SetPoint("TOPLEFT", band, "TOPLEFT", offset, -2)
        offset = offset + segmentWidth

        -- Decorative icon is never part of the text layout. Native WoW
        -- inventory glyphs still have baked square art; future asset task
        -- replaces these with transparent cutouts, not destructive cropping.
        local icon = segment:CreateTexture(nil, "ARTWORK")
        local ownerTopIcon = not secondary and definition.ownerIcon
        local ownerBottomIcon = secondary and definition.ownerIcon
        local ownerIcon = ownerTopIcon or ownerBottomIcon
        icon:SetTexture(ownerIcon or definition.icon)
        -- Preserve the native WoW illustration instead of rejected clip art.
        -- A supported alpha mask removes the square inventory-tile corners
        -- without zoom-cropping blades and heraldry. Graceful client fallback.
        -- v80: common 50x50 viewport for every owner icon in both card rows.
        -- v82: optical balancing in the two narrow lower-row cells only.
        -- Favorite-BG pennant and the entire upper row keep their approved size.
        local iconSize = ownerBottomIcon and (i == 1 and 47.5 or (i == 2 and 44 or 50))
            or (ownerIcon and 50 or 43)
        -- v105: harmonize icon size (-5%) while preserving band dimensions.
        icon:SetSize(iconSize * 0.95, iconSize * 0.95)
        -- v78: move only the crossed swords inward, clear of the left gold bevel.
        -- v81: use consistent inner clearance for the normalized lower art.
        -- Keep the owner-approved upper icon placement untouched.
        local iconInset = ownerTopIcon and (i == 1 and 24 or 10)
            or (ownerBottomIcon and (i == 1 and 16 or (i == 2 and 16 or 18)) or 8)
        icon:SetPoint("LEFT", segment, "LEFT", iconInset + 2, ownerIcon and -5 or 1)
        icon:SetTexCoord(0, 1, 0, 1)
        -- Owner art has real alpha; avoid circular masking and opacity reduction.
        icon:SetAlpha(ownerIcon and 1 or (secondary and 0.78 or 0.91))
        if not ownerIcon and type(segment.CreateMaskTexture) == "function"
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
        local caption = label(segment, text(definition.title), secondary and 12 or 13,
            CREAM, 0, -12, 145, 38)
        caption:SetTextColor(0.94, 0.84, 0.65)
        -- Ratios in the two narrow lower cells have their own fixed text area,
        -- offset right of the decorative icon; not anchored to the icon.
        local isRate = secondary and i <= 2
        -- v84: the favorite BG cell is much wider than the two rate cells.
        -- Give its live name/count a dedicated area to the right of the pennant.
        local isFavorite = secondary and i == 3
        local valueX = isRate and 19 or (isFavorite and 22 or 0)
        local valueWidth = isRate and 105 or (isFavorite and 265 or 145)
        -- v85: separate the favorite's name from the played-count caption.
        -- The latter uses the client's built-in italic face when available.
        -- v105: values are independently positioned, scaled to 95% and raised.
        local valueFontSize = (definition.valueSize or (secondary and 29 or 35)) * 0.95
        local value = label(segment, "—", valueFontSize,
            secondary and GREEN or GOLD, valueX, isFavorite and -46 or -50,
            valueWidth, isFavorite and 28 or 45)
        value:SetShadowColor(0.26, 0.14, 0.045, secondary and 0.45 or 0.72)
        value:SetShadowOffset(1, -1)
        values[i] = value
        values.captions = values.captions or {}
        values.captions[i] = caption
        if isFavorite then
            -- v86: center under the favorite card heading (segment x=0),
            -- independently from the name, which is shifted right of the pennant.
            local playedCaption = label(segment, "", 12.35, CREAM, 0, -66, 190, 20)
            -- v87: own actual italic TTF. WoW has no SetFont italic flag;
            -- QuestFont/ITALIC_TEXT_FONT rendered upright on Forever v86.
            -- File is vendored from Google Fonts (Spectral, SIL OFL 1.1).
            playedCaption:SetFont("Interface\\AddOns\\WarScore\\Media\\Fonts\\Spectral-Italic.ttf", 12.35, "OUTLINE")
            playedCaption:SetTextColor(0.84, 0.77, 0.64)
            playedCaption:SetShadowColor(0.20, 0.10, 0.03, 0.6)
            playedCaption:SetShadowOffset(1, -1)
            values.favoritePlayed = playedCaption
        end
    end
    return values
end

local function formatNumber(value)
    if type(value) ~= "number" then return "—" end
    return tostring(math.floor(value))
end
local function formatHonorNumber(value)
    if type(value) ~= "number" then return "—" end
    local digits = tostring(math.floor(value))
    return digits:reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "")
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


-- Forever PvP-rank indices start with PVP_RANK_5_<faction> at renown 1.
-- A renown level of zero has no rank, even if some Rank Points are earned.
local function rankName(level, faction)
    if type(level) ~= "number" or level < 0 then return "—" end
    if level == 0 then return text("no_rank") end
    if ns.L:GetLanguage() == "en" then return text("rank_level", tostring(level)) end
    local factionIndex = faction == "Horde" and 0 or (faction == "Alliance" and 1 or nil)
    if not factionIndex then return text("rank_caption") .. " " .. tostring(level) end
    local key = "PVP_RANK_" .. tostring(level + 4) .. "_" .. tostring(factionIndex)
    local value = _G[key]
    return type(value) == "string" and value ~= "" and value or (text("rank_caption") .. " " .. tostring(level))
end

local function roundedRankStep(points, maximum)
    if type(points) ~= "number" or type(maximum) ~= "number" or maximum <= 0 then return nil end
    local percent = math.max(0, math.min(100, points / maximum * 100))
    return math.floor(percent / 5 + 0.5) * 5, percent
end

local function refresh()
    if not window or not window:IsShown() then return end
    fields.generalText:SetText(text("tab_general"))
    fields.todayText:SetText(text("tab_today"))
    fields.rankCaption:SetText(text("rank_caption"))
    fields.honorHeading:SetText(text("honor_title"))
    fields.hkCaption:SetText(text("honorable_kills"))
    fields.pvpDeathsCaption:SetText(text("pvp_deaths"))
    fields.hkDescription:SetText(text("hk_death_ratio_description"))
    for i, key in ipairs(fields.statCaptionKeys) do fields.statCaptions[i]:SetText(text(key)) end
    for i, key in ipairs(fields.statCaptionKeysSecondary) do fields.statCaptionsSecondary[i]:SetText(text(key)) end
    local data = ns.Stats.ReadHistorical()
    fields.name:SetText(UnitName("player") or text("character_fallback"))
    fields.level:SetText(text("level_format", tostring(UnitLevel("player") or "?"), UnitClass("player") or text("class_fallback")))
    if fields.portrait and type(SetPortraitTexture) == "function" then
        SetPortraitTexture(fields.portrait, "player")
    end
    fields.hk:SetText(formatNumber(data.honorableKills))
    -- v120: Honor currency 1792 is distinct from rank points and lifetime HK.
    -- Never substitute the mockup's 252 / 25.000 when client data is missing.
    if type(data.honorCurrent) == "number" then
        fields.honor:SetText(formatHonorNumber(data.honorCurrent) .. " / " .. formatHonorNumber(data.honorMaximum))
    else
        fields.honor:SetText("—")
    end
    fields.deaths:SetText(formatNumber(data.pvpDeaths))
    fields.hkd:SetText(formatRatio(data.hkDeathRatio))
    local level = data.pvpRank
    local faction = type(UnitFactionGroup) == "function" and UnitFactionGroup("player") or nil
    if type(level) == "number" then
        fields.rank:SetText(rankName(level, faction))
        fields.rankFrom:SetText(rankName(level, faction))
        local atMax = type(data.pvpRankMaxLevel) == "number" and level >= data.pvpRankMaxLevel
        fields.rankTo:SetText(atMax and text("rank_max") or rankName(level + 1, faction))
        local points, threshold = data.pvpRankPoints, data.pvpRankThreshold
        if type(points) == "number" then
            fields.rankPoints:SetText(formatHonorNumber(points) .. " / " .. formatHonorNumber(threshold) .. " " .. text("rank_points_suffix"))
        else
            fields.rankPoints:SetText("—")
        end
        -- v110: progress artwork temporarily disabled at the owner's request.
        -- Keep raw Rank Points and the max-rank label; do not fabricate a bar.
    else
        fields.rank:SetText(text("rank_unavailable"))
        fields.rankFrom:SetText("—")
        fields.rankTo:SetText("—")
        fields.rankPoints:SetText("—")
        -- No percentage caption or graphical progress fill on the rank meter.
    end
    fields.duels:SetText(formatCountOrZero(data.duelsWon))
    fields.bgPlayed:SetText(formatCountOrZero(data.battlegroundsPlayed))
    fields.bgWon:SetText(formatCountOrZero(data.battlegroundsWon))
    fields.bgRate:SetText(formatPercent(data.bgWinRate))
    fields.duelRate:SetText(formatPercent(data.duelWinRate))
    local favorite = data.favoriteBattleground
    if favorite and data.favoriteBattlegroundPlayed then
        fields.favorite:SetText(favorite)
        local count = data.favoriteBattlegroundPlayed
        fields.favoritePlayed:SetText(text(count == 1 and "played_once" or "played_many", formatNumber(count)))
    else
        fields.favorite:SetText("—")
        fields.favoritePlayed:SetText("")
    end
end

local function build()
    window = CreateFrame("Frame", "WarScoreGeneralFrame", UIParent, "BackdropTemplate")
    window:SetSize(870, 1105)
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
    -- Iteration 64: exactly the owner's supplied source PNG assets.
    -- The leather matte is derived ONLY from their previously supplied
    -- leather PNG, alpha-limited to the interior of the source outer frame.
    -- All three assets share the exact outer canvas, so no hard-edged
    -- rectangular backing can protrude through its transparent outline.
    window:Hide()
    local interiorBacking = window:CreateTexture(nil, "BACKGROUND", nil, -7)
    interiorBacking:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\leather_backing_owner_v64")
    interiorBacking:SetAllPoints(window)
    interiorBacking:SetVertexColor(1, 1, 1, 1)

    -- Match the designer's authoritative 1199x1312 reference:
    -- child center anchored to parent center, 0.89 scale, top gap 101px.
    -- Keep the source art independent: the reference composite is NOT used.
    -- Iteration 67: the owner exterior PNG includes a second ornamental
    -- gold inner outline. The derived variant masks only that baked outline,
    -- retaining the actual exterior steel perimeter, swords and close X.
    -- The author's independent inner frame remains the sole inner border.
    local outerArt = window:CreateTexture(nil, "BACKGROUND", nil, -1)
    outerArt:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\outer_frame_owner_v67_trimmed")
    outerArt:SetAllPoints(window)
    outerArt:SetAlpha(1)

    -- Iteration 65: owner screenshot showed the inner painting optically
    -- 5 UI units left of the exterior contour. Shift the painting and its
    -- tab hitboxes together; preserve all artwork, dimensions and backing.
    local innerArt = window:CreateTexture(nil, "BORDER")
    innerArt:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\inner_frame_owner_v64")
    innerArt:SetSize(774, 985)
    innerArt:SetPoint("TOP", window, "TOP", 5, -82)
    innerArt:SetAlpha(1)

    -- Keep brand text dynamic. The background plate is supplied artwork.
    -- v114: shift the brand copy down within the real title plate and
    -- reduce it slightly so its glyphs clear the upper steel rail.
    local brandTitle = label(window, "WarScore", 31, GOLD, 0, -36, 360, 40)
    brandTitle:SetShadowColor(0.34, 0.16, 0.03, 0.93)
    brandTitle:SetShadowOffset(1, -1)

    -- v93: restore the exact original v90 close button. Its X is already
    -- painted into the exterior frame; do not overlay a second X.
    local close = CreateFrame("Button", nil, window)
    close:SetSize(43, 43)
    close:SetPoint("TOPRIGHT", window, "TOPRIGHT", -48, -28)
    close:SetScript("OnClick", function() window:Hide() end)

    -- The supplied graphic already paints both tab plates; only live text
    -- and hitboxes are needed. Their placement follows the asset's geometry.
    local general = CreateFrame("Button", nil, window)
    general:SetSize(150, 38)
    general:SetPoint("TOPLEFT", window, "TOPLEFT", 193, -102)
    local generalText = label(general, text("tab_general"), 16, GOLD, 0, -2, 135, 29)
    generalText:SetShadowColor(0.17, 0.08, 0.015, 0.94)
    generalText:SetShadowOffset(1, -1)

    local today = CreateFrame("Button", nil, window)
    today:SetSize(150, 38)
    today:SetPoint("TOPLEFT", window, "TOPLEFT", 366, -102)
    -- v96: center the copy optically within the painted inactive tab.
    local todayText = label(today, text("tab_today"), 15, CREAM, -5, -2, 135, 29)
    todayText:SetTextColor(0.72, 0.66, 0.55)
    -- v98: mirror the native-style settings hover tooltip.
    today:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(text("today_coming_soon"), 1, 0.82, 0.40)
        GameTooltip:Show()
    end)
    today:SetScript("OnLeave", function() GameTooltip:Hide() end)
    today:SetScript("OnClick", function()
        if DEFAULT_CHAT_FRAME then
            DEFAULT_CHAT_FRAME:AddMessage("|cffffc34dWarScore:|r " .. text("today_message"))
        end
    end)

    -- v94: the owner-provided GOLD gear graphic replaces the whole older
    -- settings widget (the asset itself includes the metallic/red frame).
    -- The X remains baked into the outer frame, with its original click target.
    -- Their horizontal centers both lie 69.5 units in from the window right.
    local settingsFrame = CreateFrame("Frame", nil, window)
    settingsFrame:SetSize(38, 38)
    -- v95: small optical adjustment: 3 units left and 2 units upward.
    -- v96: refine gear alignment under the unchanged close X.
    -- v130: add clearance beneath the unchanged close X; shift the gear
    -- approximately 0.5% of the 800px-wide window (4 UI units) left and
    -- 6 UI units down. No other anchors or artwork are altered.
    settingsFrame:SetPoint("TOPRIGHT", window, "TOPRIGHT", -62.5, -83)
    local settingsIcon = settingsFrame:CreateTexture(nil, "ARTWORK")
    settingsIcon:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\settings_gear_owner_v94")
    settingsIcon:SetAllPoints(settingsFrame)
    settingsFrame:EnableMouse(true)
    settingsFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText(text("tab_settings"), 1, 0.82, 0.40)
        GameTooltip:Show()
    end)
    settingsFrame:SetScript("OnLeave", function() GameTooltip:Hide() end)
    -- v122: the existing gold gear opens Settings instead of a tooltip-only
    -- placeholder. The view closures are initialized at the end of build().
    settingsFrame:SetScript("OnMouseUp", function(_, mouseButton)
        if mouseButton == "LeftButton" and showSettingsView then
            showSettingsView()
        end
    end)

    fields = {}
    -- Both banners are baked into innerArt; no separate banner sprites.
    -- v132: preserve the portrait's horizontal center and almost the same
    -- vertical center while enlarging its canvas and adding the owner's
    -- original bronze/gold circular ornament above the existing mask.
    local portraitRing = CreateFrame("Frame", nil, window)
    portraitRing:SetSize(118, 118)
    portraitRing:SetPoint("TOP", window, "TOP", 0, -159)
    local portrait = portraitRing:CreateTexture(nil, "ARTWORK")
    portrait:SetSize(100, 100)
    portrait:SetPoint("CENTER")
    fields.portrait = portrait
    -- Retain the proven circular mask and classic-client fallback.
    local maskApplied = false
    if type(portraitRing.CreateMaskTexture) == "function"
        and type(portrait.AddMaskTexture) == "function" then
        local ok = pcall(function()
            local mask = portraitRing:CreateMaskTexture(nil, "ARTWORK")
            mask:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_mask")
            mask:SetSize(100, 100)
            mask:SetPoint("CENTER", portrait, "CENTER", 0, 0)
            portrait:AddMaskTexture(mask)
        end)
        maskApplied = ok
    end
    -- Preserve the old fallback to hide square portrait corners on clients
    -- without mask support. Avoid a second old gold border when masked.
    if not maskApplied then
        local legacyRing = portraitRing:CreateTexture(nil, "OVERLAY")
        legacyRing:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_ring")
        legacyRing:SetSize(118, 118)
        legacyRing:SetPoint("CENTER", portraitRing, "CENTER", 0, 0)
    end
    local ring = portraitRing:CreateTexture(nil, "OVERLAY")
    ring:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\portrait_ring_owner_v132")
    ring:SetSize(118, 118)
    ring:SetPoint("CENTER", portraitRing, "CENTER", 0, 0)
    fields.name = label(window, "—", 23, CREAM, 0, -279, 360, 32)
    fields.level = label(window, "—", 15, CREAM, 0, -310, 360, 24)
    -- Iteration 27: authored metallic ribbon artwork, with independent text
    -- and faction crest. A faction badge never indicates verified PvP rank.
    local rankPlate = CreateFrame("Frame", nil, window)
    rankPlate:SetSize(452, 42)
    rankPlate:SetPoint("TOP", window, "TOP", 0, -347)

    -- Iteration 66: use the owner's actual Horde PvP-rank plaque.
    -- The complete shield, red leather, gold bevel, laurels and center ruby
    -- are baked into one alpha texture; never overlay the former square
    -- inventory emblem, fake border, orange backing or stray gold lines.
    -- The source PNG was cropped ONLY around transparent padding.
    -- Alliance has no matching supplied plaque, so retain the established
    -- neutral ribbon as fallback rather than displaying Horde heraldry.
    local rankFaction = UnitFactionGroup("player")
    local rankArtwork = rankPlate:CreateTexture(nil, "ARTWORK")
    if rankFaction == "Horde" then
        rankArtwork:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\rank_pvp_horde_owner_v66")
        rankArtwork:SetSize(452, 113)
        rankArtwork:SetPoint("CENTER", rankPlate, "CENTER", 0, 0)
    else
        rankArtwork:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\rank_ribbon")
        rankArtwork:SetTexCoord(0.18, 0.74, 0.16, 0.84)
        rankArtwork:SetSize(422, 48)
        rankArtwork:SetPoint("CENTER", rankPlate, "CENTER", 0, 0)
    end

    -- All primary dynamic text follows the window's central X axis.
    -- The plaque artwork is centered on that same axis, while its carved
    -- heraldry intentionally extends left of its central inscription.
    -- Clean centered rank inscription: a small section name and an honest
    -- unavailable value, like the two-tier reference ribbon.
    -- Reserve a visible margin below the rank value and above the HK divider.
    local rankCaption = label(rankPlate, text("rank_caption"), 13, CREAM, 0, -3, 280, 15)
    rankCaption:SetTextColor(0.89, 0.70, 0.39)
    fields.rank = label(rankPlate, text("rank_unavailable"), 18, GOLD, 0, -19, 280, 20)
    fields.rank:SetShadowColor(0.14, 0.06, 0.01, 0.85)
    fields.rank:SetShadowOffset(1, -1)
    -- The supplied Horde plaque already has a lower gold rim and ruby:
    -- an extra full-width rule/diamond would cut through that artwork.
    if rankFaction ~= "Horde" then
        line(window, -391, 632)
        ornamentDiamond(window, -389, 8)
    end

    -- v108: single owner-provided three-section frame.  The existing 21
    -- authored 5%-step rank textures remain dynamic, and are restricted to
    -- the central compartment, never the two rank labels.
    -- Source frame proportions and genuine metal/gems are preserved.
    local rankPanel = window:CreateTexture(nil, "BORDER")
    rankPanel:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\rank_panel_owner_v108")
    -- v114: another 5% reduction of the triptych width only, still
    -- horizontally centered and with its approved height unchanged.
    rankPanel:SetSize(560.4525, 61.75)
    rankPanel:SetPoint("TOP", window, "TOP", 0, -443.625)

    -- v110: no progress-fill texture. The unified frame's dark central
    -- compartment is left empty except for the live Rank Points value.
    -- Original 0–100% fill assets remain in the repository for future use.

    -- Three independent live captions, positioned against the authored
    -- centerlines of the two outer compartments and the central meter.
    -- Centers follow the actual outer-section centers of the owner
    -- artwork after scaling, not the former independent plate offsets.
    -- Narrow text bounds stop long names at the red divider gems.
    -- v119: use the two chamber midlines from the original unified texture
    -- for ALL related labels, rather than independent optical offsets.
    -- Both chamber name captions stay vertically centered in their panels.
    local sideRankCenter = 213
    fields.rankFrom = label(window, "—", 13, CREAM, -sideRankCenter, -463, 107.217, 25)
    fields.rankTo = label(window, "—", 13, CREAM, sideRankCenter, -463, 107.217, 25)
    fields.rankPoints = label(window, "—", 14, CREAM, 0, -464.125, 243.675, 23)
    fields.rankPoints:SetShadowColor(0.02, 0.01, 0.01, 1)
    fields.rankPoints:SetShadowOffset(1, -1)

    -- v116: the three owner-supplied ornaments were absent in the owner's
    -- actual v115 screenshot despite valid TGA resources in the ZIP.
    -- Render each as its own raised child frame, above the window's inner
    -- artwork and sibling frames. This avoids dependence on parent texture
    -- draw-layer ordering. The v114-approved triptych is untouched.
    local function addRankOrnament(textureName, x, top, width, height)
        local ornamentFrame = CreateFrame("Frame", nil, window)
        ornamentFrame:SetSize(width, height)
        ornamentFrame:SetPoint("TOP", window, "TOP", x, top)
        ornamentFrame:SetFrameLevel(window:GetFrameLevel() + 8)
        ornamentFrame:EnableMouse(false)

        local ornament = ornamentFrame:CreateTexture(nil, "OVERLAY")
        ornament:SetTexture(textureName)
        ornament:SetAllPoints(ornamentFrame)
        ornament:SetVertexColor(1, 1, 1, 1)
        ornament:SetAlpha(1)
        ornament:Show()
        ornamentFrame:Show()
        return ornamentFrame
    end

    -- v119: place each ornament over the SAME chamber center as its live
    -- rank name; matching height and size keep both titles level.
    addRankOrnament("Interface\\AddOns\\WarScore\\Media\\General\\rank_label_current_owner_v115", -sideRankCenter, -432, 175, 32)
    addRankOrnament("Interface\\AddOns\\WarScore\\Media\\General\\rank_label_next_owner_v115", sideRankCenter, -432, 175, 32)

    -- v117: lift the decorative divider 10 units closer to the PR chamber.
    -- It remains ornamental; PR remains numeric and the fill remains hidden.
    addRankOrnament("Interface\\AddOns\\WarScore\\Media\\General\\rank_divider_advance_owner_v115", 0, -488, 560.4525, 30)

    -- v120: new owner-supplied, text-free Honor + honorable kills panel.
    -- Only this pre-existing HK region is replaced; the finalized rank/PVP
    -- module above and the ratio/stat modules below remain unchanged.
    local honorPanel = window:CreateTexture(nil, "ARTWORK")
    honorPanel:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\honor_frame_owner_v120")
    honorPanel:SetSize(600, 128)
    honorPanel:SetPoint("TOP", window, "TOP", 0, -508)
    honorPanel:SetAlpha(1)

    -- Header title, current/maximum Honor currency, and lifetime HK are
    -- independent live font strings; no text is embedded in the owner PNG.
    local honorHeading = label(window, text("honor_title"), 23, GOLD, 0, -519, 260, 28)
    honorHeading:SetShadowColor(0.24, 0.12, 0.02, 0.85)
    honorHeading:SetShadowOffset(1, -1)
    -- v121: reduce the dynamic Honor amount by ~2% without moving the panel.
    fields.honor = label(window, "—", 36.25, GOLD, 0, -547, 460, 42)
    fields.honor:SetShadowColor(0.35, 0.20, 0.04, 0.95)
    fields.honor:SetShadowOffset(2, -2)

    local hkCaption = label(window, text("honorable_kills"), 17, CREAM, -83, -597, 365, 27)
    hkCaption:SetShadowColor(0.22, 0.10, 0.02, 0.84)
    hkCaption:SetShadowOffset(1, -1)
    -- v121: reduce and vertically center the live HK count in its right-side
    -- area. Match the CREAM color of the accompanying HK description.
    fields.hk = label(window, "—", 28, CREAM, 197, -594, 130, 36)
    fields.hk:SetShadowColor(0.22, 0.10, 0.02, 0.84)
    fields.hk:SetShadowOffset(1, -1)

    -- Iteration 70: owner-provided complete ornamental frame, improved source resolution for the ratios.
    -- Replaces the upper/lower rules and the vertical separator.
    local ratioOrnament = window:CreateTexture(nil, "BORDER")
    ratioOrnament:SetTexture("Interface\\AddOns\\WarScore\\Media\\General\\ratios_frame_owner_v70")
    -- Iteration 71: stretch only the transparent vertical field to contain
    -- the live captions above the lower sapphire rail; keep width unchanged.
    ratioOrnament:SetSize(632, 172)
    ratioOrnament:SetPoint("TOP", window, "TOP", 0, -633)

    -- Iteration 72: compact the text stack inside the fixed owner frame.
    -- Iteration 73: shift the entire ratio art + text block up 10 UI units.
    -- Keep all relative positions and font sizes established by v72.
    label(window, text("hk_death_ratio"), 18, GOLD, -165, -683, 270, 22)
    -- v90: align right-column heading and counter to the actual right panel axis.
    -- The previous +165 offset was visibly right of the ornamental cell center.
    local rightMetricX = 150
    local pvpDeathsCaption = label(window, text("pvp_deaths"), 16, RED, rightMetricX, -683, 290, 22)
    fields.hkd = label(window, "—", 34, CREAM, -165, -705, 270, 37)
    fields.deaths = label(window, "—", 34, RED, rightMetricX, -705, 270, 37)
    fields.hkd:SetShadowColor(0.34, 0.19, 0.06, 0.72)
    fields.hkd:SetShadowOffset(1, -1)
    fields.deaths:SetShadowColor(0.32, 0.05, 0.035, 0.70)
    fields.deaths:SetShadowOffset(1, -1)
    local hkDescription = label(window, text("hk_death_ratio_description"), 11, CREAM, -165, -741, 300, 18)
    hkDescription:SetTextColor(0.77, 0.69, 0.58)
    -- Deliberately no descriptive copy under the raw PvP death counter;
    -- the raw count's title already states the metric unambiguously.

    -- Lower ratio rail and central sapphire are part of the new owner asset.

    local firstRow = statBand(window, -779, {
        { title = "duel_wins", color = GOLD, ownerIcon = "Interface\\AddOns\\WarScore\\Media\\General\\icon_duels_owner_v77" },
        { title = "battlegrounds_played", color = GOLD, ownerIcon = "Interface\\AddOns\\WarScore\\Media\\General\\icon_bg_played_owner_v77" },
        { title = "battlegrounds_won", color = GOLD, ownerIcon = "Interface\\AddOns\\WarScore\\Media\\General\\icon_bg_wins_owner_v77" },
    })
    fields.duels, fields.bgPlayed, fields.bgWon = unpack(firstRow)
    -- v88: lift the entire lower band 8 UI units to clear the parent bottom rim.
    -- Keep the owner TGA, band dimensions and the text/icon local anchors intact.
    local secondRow = statBand(window, -890, {
        { title = "battleground_win_rate", color = GREEN, ownerIcon = "Interface\\AddOns\\WarScore\\Media\\General\\icon_bg_rate_owner_v79" },
        { title = "duel_win_rate", color = GREEN, ownerIcon = "Interface\\AddOns\\WarScore\\Media\\General\\icon_duel_rate_owner_v79" },
        { title = "favorite_battleground", color = GREEN, ownerIcon = "Interface\\AddOns\\WarScore\\Media\\General\\icon_favorite_bg_owner_v79", valueSize = 17 },
    }, true)
    fields.bgRate, fields.duelRate, fields.favorite = unpack(secondRow)
    fields.favoritePlayed = secondRow.favoritePlayed
    fields.rankCaption = rankCaption
    fields.honorHeading = honorHeading
    fields.hkCaption = hkCaption
    fields.pvpDeathsCaption = pvpDeathsCaption
    fields.hkDescription = hkDescription
    fields.generalText = generalText
    fields.todayText = todayText
    fields.statCaptions = firstRow.captions
    fields.statCaptionKeys = { "duel_wins", "battlegrounds_played", "battlegrounds_won" }
    fields.statCaptionsSecondary = secondRow.captions
    fields.statCaptionKeysSecondary = { "battleground_win_rate", "duel_win_rate", "favorite_battleground" }

    -- v122: freeze the complete v121 General view as its own visibility
    -- group. These are the original region/child objects: no layout, anchor,
    -- artwork, statistic or font is rebuilt or reparented.
    -- Common outer/background/header, the X and the gear remain visible.
    local sharedRegions = {
        [interiorBacking] = true,
        [outerArt] = true,
        [innerArt] = true, -- v123: exactly the same approved General inner frame in BOTH views
        [brandTitle] = true,
    }
    local sharedChildren = {
        [close] = true,
        [settingsFrame] = true,
    }
    local generalObjects = {}
    local regionCount = select("#", window:GetRegions())
    for index = 1, regionCount do
        local region = select(index, window:GetRegions())
        if region and not sharedRegions[region] then
            generalObjects[#generalObjects + 1] = region
        end
    end
    local childCount = select("#", window:GetChildren())
    for index = 1, childCount do
        local child = select(index, window:GetChildren())
        if child and not sharedChildren[child] then
            generalObjects[#generalObjects + 1] = child
        end
    end

    -- v123: reuse the EXACT General innerArt already rendered by window.
    -- No second frame texture, no duplicate border, no alternate canvas.
    -- The underlying innerArt stays visible across both views at 774x985,
    -- TOP x=5/y=-82, and keeps its original baked General/Hoy tab plates.
    -- Only the tab captions and the content group change visibility.
    local settingsPage = CreateFrame("Frame", nil, window)
    settingsPage:SetAllPoints(window)
    settingsPage:SetFrameLevel(window:GetFrameLevel() + 2)

    -- Mirror the ORIGINAL General and Hoy tab button geometry exactly.
    local settingsTab = CreateFrame("Frame", nil, settingsPage)
    settingsTab:SetSize(150, 38)
    settingsTab:SetPoint("TOPLEFT", settingsPage, "TOPLEFT", 193, -102)
    local settingsTitle = label(settingsTab, text("tab_settings"), 16, GOLD, 0, -2, 135, 29)
    settingsTitle:SetShadowColor(0.17, 0.08, 0.015, 0.94)
    settingsTitle:SetShadowOffset(1, -1)

    local returnTab = CreateFrame("Button", nil, settingsPage)
    returnTab:SetSize(150, 38)
    returnTab:SetPoint("TOPLEFT", settingsPage, "TOPLEFT", 366, -102)
    local returnTitle = label(returnTab, text("tab_back"), 15, CREAM, -5, -2, 135, 29)
    returnTitle:SetTextColor(0.72, 0.66, 0.55)
    returnTab:SetScript("OnEnter", function()
        returnTitle:SetTextColor(1, 0.86, 0.52)
    end)
    returnTab:SetScript("OnLeave", function()
        returnTitle:SetTextColor(0.72, 0.66, 0.55)
    end)

    -- v124: a reusable vertical Settings layout. Each row has a localized
    -- caption and a native WoW Classic UIDropDownMenuTemplate control.
    -- Future settings can be added as new rows without moving the frame.
    local settingsContent = CreateFrame("Frame", nil, settingsPage)
    settingsContent:SetSize(490, 500)
    settingsContent:SetPoint("TOP", settingsPage, "TOP", 0, -270)
    local sectionTitle = label(settingsContent, text("settings_section"), 19, GOLD, 0, 0, 410, 32)

    local sectionRule = settingsContent:CreateTexture(nil, "ARTWORK")
    sectionRule:SetTexture("Interface\\Buttons\\WHITE8X8")
    sectionRule:SetVertexColor(0.72, 0.48, 0.17, 0.65)
    sectionRule:SetSize(390, 1)
    sectionRule:SetPoint("TOP", settingsContent, "TOP", 0, -39)

    local function addSettingsRow(titleKey, y)
        local container = CreateFrame("Frame", nil, settingsContent)
        container:SetSize(420, 112)
        container:SetPoint("TOP", settingsContent, "TOP", 0, y)
        local title = label(container, text(titleKey), 16, CREAM, 0, 0, 370, 26)
        return container, title
    end

    local languageRow, languageTitle = addSettingsRow("settings_language", -67)
    local languageDropdown = CreateFrame("Frame", "WarScoreSettingsLanguageDropdown", languageRow, "UIDropDownMenuTemplate")
    languageDropdown:SetPoint("TOP", languageRow, "TOP", -17, -32)
    UIDropDownMenu_SetWidth(languageDropdown, 210)

    -- Same translation service as '/ws lang es' and '/ws lang en'. Its
    -- listeners update all General copies and Settings captions in place.
    UIDropDownMenu_Initialize(languageDropdown, function(_, level)
        if level and level ~= 1 then return end
        local current = ns.L:GetLanguage()
        local choices = {
            { value = "es", title = "Español" },
            { value = "en", title = "English" },
        }
        for _, choice in ipairs(choices) do
            local languageCode = choice.value
            local info = UIDropDownMenu_CreateInfo()
            info.text = choice.title
            info.value = languageCode
            info.checked = current == languageCode
            info.func = function()
                ns.L:SetLanguage(languageCode)
            end
            UIDropDownMenu_AddButton(info, level or 1)
        end
    end)

    local styleRow, styleTitle = addSettingsRow("settings_visual_style", -199)
    local styleDropdown = CreateFrame("Frame", "WarScoreSettingsStyleDropdown", styleRow, "UIDropDownMenuTemplate")
    styleDropdown:SetPoint("TOP", styleRow, "TOP", -17, -32)
    UIDropDownMenu_SetWidth(styleDropdown, 210)
    UIDropDownMenu_Initialize(styleDropdown, function(_, level)
        if level and level ~= 1 then return end
        local info = UIDropDownMenu_CreateInfo()
        info.text = "Classic Forever"
        info.value = "classic-forever"
        info.checked = true
        info.disabled = true
        UIDropDownMenu_AddButton(info, level or 1)
    end)
    UIDropDownMenu_SetSelectedValue(styleDropdown, "classic-forever")
    UIDropDownMenu_SetText(styleDropdown, "Classic Forever")
    -- v125: WoW Forever does not expose UIDropDownMenu_Disable.
    -- Disable the actual native arrow button, which is always present on
    -- UIDropDownMenuTemplate (also verified by the in-game error report).
    -- Keep the selected style visible but prevent opening/changing it.
    if styleDropdown.Button then
        styleDropdown.Button:Disable()
        styleDropdown.Button:SetAlpha(0.45)
    end
    styleDropdown:EnableMouse(false)
    local styleHint = label(styleRow, text("settings_style_unavailable"), 12, CREAM, 0, -91, 370, 20)
    styleHint:SetTextColor(0.58, 0.53, 0.47)

    local function updateSettingsLanguage()
        sectionTitle:SetText(text("settings_section"))
        languageTitle:SetText(text("settings_language"))
        styleTitle:SetText(text("settings_visual_style"))
        styleHint:SetText(text("settings_style_unavailable"))
        local current = ns.L:GetLanguage()
        UIDropDownMenu_SetSelectedValue(languageDropdown, current)
        UIDropDownMenu_SetText(languageDropdown, current == "en" and "English" or "Español")
    end
    updateSettingsLanguage()

    showGeneralView = function()
        settingsPage:Hide()
        for _, object in ipairs(generalObjects) do object:Show() end
        refresh()
    end
    showSettingsView = function()
        for _, object in ipairs(generalObjects) do object:Hide() end
        settingsPage:Show()
        -- Keep the shared close X and clickable gear above Settings artwork.
        close:SetFrameLevel(window:GetFrameLevel() + 10)
        settingsFrame:SetFrameLevel(window:GetFrameLevel() + 10)
    end
    returnTab:SetScript("OnClick", showGeneralView)
    settingsPage:Hide()

    ns.L:RegisterRefresh(function()
        settingsTitle:SetText(text("tab_settings"))
        returnTitle:SetText(text("tab_back"))
        updateSettingsLanguage()
    end)

    -- Preserve the original reference window height and refresh lifecycle.
    window:SetHeight(1105)
    window:SetScript("OnShow", refresh)
    ns.L:RegisterRefresh(refresh)
end

function ns.UI.ShowGeneral()
    if not window then build() end
    if showGeneralView then showGeneralView() end
    window:Show()
    refresh()
end

function ns.UI.ShowSettings()
    if not window then build() end
    window:Show()
    if showSettingsView then showSettingsView() end
end

-- v126: shared window toggle for the minimap icon. Closing preserves all
-- stored PvP statistics and settings; reopening shows the usual General page.
function ns.UI.ToggleGeneral()
    if window and window:IsShown() then
        window:Hide()
    else
        ns.UI.ShowGeneral()
    end
end

SLASH_WARSCORE1 = "/warscore"
SLASH_WARSCORE2 = "/ws"
SlashCmdList.WARSCORE = function(message)
    local command = type(message) == "string" and message:match("^%s*(%S+)") or nil
    local argument = type(message) == "string" and message:match("^%s*%S+%s+(%S+)") or nil
    if command and command:lower() == "lang" then
        local requested = argument and argument:lower() or nil
        if requested and ns.L:SetLanguage(requested) then
            if DEFAULT_CHAT_FRAME then
                DEFAULT_CHAT_FRAME:AddMessage("|cffffc34dWarScore|r " .. text("language_changed", requested == "en" and "English" or "Español"))
            end
        elseif DEFAULT_CHAT_FRAME then
            DEFAULT_CHAT_FRAME:AddMessage("|cffffc34dWarScore|r " .. (requested and text("language_invalid") or text("language_usage")))
        end
        return
    end
    if command and command:lower() == "settings" then
        ns.UI.ShowSettings()
        return
    end
    if command and command:lower() == "version" then
        if DEFAULT_CHAT_FRAME then
            DEFAULT_CHAT_FRAME:AddMessage("|cffffc34dWarScore|r UI iteración " .. UI_ITERATION)
        end
        return
    end
    ns.UI.ShowGeneral()
end
