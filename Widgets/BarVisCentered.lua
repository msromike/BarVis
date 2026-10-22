-- BarVis. MIT, see LICENSE.
--
-- Three AceGUI widgets that reposition their stock counterpart, for use from the
-- options table through `dialogControl`. AceConfigDialog drives them exactly like the
-- originals. Same pattern as SoulShardForever's Widgets\SSFCentered.lua.
--   BarVisCenteredLabel   : a Label with centered text (the status line).
--   BarVisCenteredDropdown: a Dropdown of fixed width, centered in its row, label centered
--                           above it (the bar picker).
--   BarVisCenteredCheckBox: a CheckBox sized to its text and centered in its row (the
--                           minimap button toggle). Same as SSF's SSFCenteredCheckBox.
-- All are built by composition: the real widget sits inside ours and every call is
-- forwarded.

local AceGUI = LibStub("AceGUI-3.0")

-------------------------------------------------------------------------------
-- BarVisCenteredLabel
-------------------------------------------------------------------------------
do
    local Type, Version = "BarVisCenteredLabel", 1

    local function SyncHeight(self)
        self:SetHeight(self.inner.frame.height or self.inner.frame:GetHeight() or 1)
    end

    local methods = {
        ["OnAcquire"] = function(self)
            self.inner:SetText()
            self.inner:SetImage(nil)
            self.inner:SetColor()
            self.inner:SetFontObject()
            self.inner:SetJustifyH("CENTER")
            self:SetWidth(200)
        end,
        ["OnWidthSet"] = function(self, width)
            self.inner:SetWidth(width)
            SyncHeight(self)
        end,
        ["SetText"] = function(self, text) self.inner:SetText(text) SyncHeight(self) end,
        ["SetFontObject"] = function(self, font) self.inner:SetFontObject(font) SyncHeight(self) end,
        ["SetColor"] = function(self, ...) self.inner:SetColor(...) end,
        ["SetImage"] = function(self, ...) self.inner:SetImage(...) SyncHeight(self) end,
        ["SetImageSize"] = function(self, ...) self.inner:SetImageSize(...) SyncHeight(self) end,
    }

    local function Constructor()
        local frame = CreateFrame("Frame", nil, UIParent)
        local widget = { frame = frame, type = Type }
        local inner = AceGUI:Create("Label")
        inner.frame:SetParent(frame)
        inner.frame:ClearAllPoints()
        inner.frame:SetPoint("TOPLEFT")
        inner.frame:SetPoint("TOPRIGHT")
        inner.frame:Show()
        widget.inner = inner
        for method, func in pairs(methods) do widget[method] = func end
        return AceGUI:RegisterAsWidget(widget)
    end

    AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-------------------------------------------------------------------------------
-- BarVisCenteredDropdown
-------------------------------------------------------------------------------
do
    local Type, Version = "BarVisCenteredDropdown", 1
    local DROP_WIDTH = 110 -- "10" or "All" and the arrow, with air

    -- our height and row alignment follow the inner dropdown (SetLabel changes both)
    local function Sync(self)
        self:SetHeight(self.inner.frame.height or self.inner.frame:GetHeight() or 40)
        self.alignoffset = self.inner.alignoffset
    end

    local methods = {
        ["OnAcquire"] = function(self)
            self:SetWidth(200)
            self.inner:SetDisabled(false)
            self.inner:SetValue(nil)
            self:SetLabel()
        end,
        ["SetLabel"] = function(self, text) self.inner:SetLabel(text) Sync(self) end,
        ["SetList"] = function(self, list, order, itemType) self.inner:SetList(list, order, itemType) end,
        ["SetValue"] = function(self, value) self.inner:SetValue(value) end,
        ["GetValue"] = function(self) return self.inner:GetValue() end,
        ["SetText"] = function(self, text) self.inner:SetText(text) end,
        ["SetDisabled"] = function(self, v) self.inner:SetDisabled(v) end,
    }

    local function Constructor()
        local frame = CreateFrame("Frame", nil, UIParent)
        local widget = { frame = frame, type = Type }
        local inner = AceGUI:Create("Dropdown")
        inner.frame:SetParent(frame)
        inner.frame:ClearAllPoints()
        inner.frame:SetPoint("TOP", frame, "TOP", 0, 0)
        inner:SetWidth(DROP_WIDTH)
        inner.label:SetJustifyH("CENTER")
        inner.frame:Show()
        widget.inner = inner
        inner:SetCallback("OnValueChanged", function(_, _, value) widget:Fire("OnValueChanged", value) end)
        inner:SetCallback("OnOpened", function() widget:Fire("OnOpened") end)
        inner:SetCallback("OnClosed", function() widget:Fire("OnClosed") end)
        inner:SetCallback("OnEnter", function() widget:Fire("OnEnter") end)
        inner:SetCallback("OnLeave", function() widget:Fire("OnLeave") end)
        for method, func in pairs(methods) do widget[method] = func end
        return AceGUI:RegisterAsWidget(widget)
    end

    AceGUI:RegisterWidgetType(Type, Constructor, Version)
end

-------------------------------------------------------------------------------
-- BarVisCenteredCheckBox
-------------------------------------------------------------------------------
do
    local Type, Version = "BarVisCenteredCheckBox", 1

    -- size the inner checkbox to its text and park it in the middle of our row
    local function Fit(self)
        local width = (self.inner.text:GetStringWidth() or 0) + 30
        self.inner:SetWidth(width)
        self.inner.frame:ClearAllPoints()
        self.inner.frame:SetPoint("CENTER", self.frame, "CENTER", 0, 0)
    end

    local methods = {
        ["OnAcquire"] = function(self)
            self:SetWidth(200)
            self:SetHeight(24)
            self.inner:SetType()
            self.inner:SetValue(false)
            self.inner:SetTriState(nil)
            self.inner:SetDisabled(false)
            self.inner:SetDescription(nil)
            self.inner:SetImage(nil)
            self:SetLabel("")
        end,
        ["OnWidthSet"] = function(self) Fit(self) end,
        ["SetLabel"] = function(self, text) self.inner:SetLabel(text) Fit(self) end,
        ["SetValue"] = function(self, value) self.inner:SetValue(value) end,
        ["GetValue"] = function(self) return self.inner:GetValue() end,
        ["SetTriState"] = function(self, v) self.inner:SetTriState(v) end,
        ["SetDisabled"] = function(self, v) self.inner:SetDisabled(v) end,
        ["SetDescription"] = function(self, v) self.inner:SetDescription(v) end,
        ["SetType"] = function(self, v) self.inner:SetType(v) end,
        ["SetImage"] = function(self, ...) self.inner:SetImage(...) Fit(self) end,
    }

    local function Constructor()
        local frame = CreateFrame("Frame", nil, UIParent)
        local widget = { frame = frame, type = Type }
        local inner = AceGUI:Create("CheckBox")
        inner.frame:SetParent(frame)
        inner.frame:Show()
        widget.inner = inner
        inner:SetCallback("OnValueChanged", function(_, _, value) widget:Fire("OnValueChanged", value) end)
        inner:SetCallback("OnEnter", function() widget:Fire("OnEnter") end)
        inner:SetCallback("OnLeave", function() widget:Fire("OnLeave") end)
        for method, func in pairs(methods) do widget[method] = func end
        return AceGUI:RegisterAsWidget(widget)
    end

    AceGUI:RegisterWidgetType(Type, Constructor, Version)
end
