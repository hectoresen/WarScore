local _, ns = ...
ns.UI = ns.UI or {}

-- WarScore v127: native Classic minimap gold circular border.
-- The owner's shield remains the only icon inside Blizzard's existing frame.
local minimapButton
local DEFAULT_ANGLE = 225

local function minimapSettings()
    WarScoreDB = WarScoreDB or { characters = {} }
    WarScoreDB.settings = WarScoreDB.settings or {}
    local settings = WarScoreDB.settings
    if type(settings.minimapAngle) ~= "number" then
        settings.minimapAngle = DEFAULT_ANGLE
    end
    return settings
end

local function positionButton(angle)
    if not minimapButton or not Minimap then return end
    local radians = math.rad(angle)
    local radius = math.min(Minimap:GetWidth(), Minimap:GetHeight()) / 2 + 8
    minimapButton:ClearAllPoints()
    minimapButton:SetPoint("CENTER", Minimap, "CENTER",
        math.cos(radians) * radius, math.sin(radians) * radius)
end

local function angleUnderCursor()
    -- GetCursorPosition is in physical screen pixels. The minimap center
    -- uses UI coordinates, so both must use the minimap effective scale.
    local cursorX, cursorY = GetCursorPosition()
    local scale = Minimap:GetEffectiveScale()
    local centerX, centerY = Minimap:GetCenter()
    if not scale or scale == 0 or not centerX or not centerY then return nil end
    local dx, dy = cursorX / scale - centerX, cursorY / scale - centerY
    if math.atan2 then
        return math.deg(math.atan2(dy, dx)) % 360
    end
    -- Classic Lua runtimes may not expose math.atan2.
    if dx == 0 then return dy >= 0 and 90 or 270 end
    local angle = math.deg(math.atan(dy / dx))
    if dx < 0 then angle = angle + 180 end
    return angle % 360
end

local function createMinimapButton()
    if minimapButton or not Minimap then return end

    minimapButton = CreateFrame("Button", "WarScoreMinimapButton", Minimap)
    minimapButton:SetSize(31, 31)
    minimapButton:SetFrameLevel(Minimap:GetFrameLevel() + 8)
    minimapButton:EnableMouse(true)
    minimapButton:RegisterForClicks("LeftButtonUp")
    minimapButton:RegisterForDrag("LeftButton")

    -- Keep the original shield but shrink it inside the 31px native button.
    -- These pixel offsets follow Blizzard's classic MiniMapTrackingButton
    -- layout: art in the 20px middle, native 54px circular border on top.
    local icon = minimapButton:CreateTexture(nil, "ARTWORK")
    icon:SetTexture("Interface\\AddOns\\WarScore\\Media\\Minimap\\warscore_icon_owner_v126")
    icon:SetSize(20, 20)
    icon:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", 7, -6)
    icon:SetAlpha(1)

    local border = minimapButton:CreateTexture(nil, "OVERLAY")
    border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    border:SetSize(54, 54)
    border:SetPoint("TOPLEFT", minimapButton, "TOPLEFT", 0, 0)
    border:SetAlpha(1)

    local dragging = false
    local justDragged = false
    minimapButton:SetScript("OnDragStart", function(self)
        dragging = true
        justDragged = true
        self:SetScript("OnUpdate", function()
            local angle = angleUnderCursor()
            if angle then
                positionButton(angle)
            end
        end)
    end)
    minimapButton:SetScript("OnDragStop", function(self)
        if not dragging then return end
        dragging = false
        self:SetScript("OnUpdate", nil)
        local angle = angleUnderCursor()
        if angle then
            minimapSettings().minimapAngle = angle
            positionButton(angle)
        end
    end)
    minimapButton:SetScript("OnMouseDown", function(_, mouseButton)
        if mouseButton == "LeftButton" then justDragged = false end
    end)
    minimapButton:SetScript("OnClick", function(_, mouseButton)
        if mouseButton ~= "LeftButton" or dragging or justDragged then return end
        if ns.UI.ToggleGeneral then ns.UI.ToggleGeneral() end
    end)
    minimapButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip:AddLine("WarScore", 1, 0.78, 0.31)
        GameTooltip:AddLine(ns.L and ns.L:Get("minimap_toggle") or "Abrir/Cerrar WarScore", 1, 1, 1)
        GameTooltip:Show()
    end)
    minimapButton:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    positionButton(minimapSettings().minimapAngle)
    minimapButton:Show()
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function(self, event)
    if event ~= "PLAYER_LOGIN" then return end
    createMinimapButton()
    self:UnregisterEvent("PLAYER_LOGIN")
end)
