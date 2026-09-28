-- BarVis. MIT, see LICENSE.
--
-- Window: opens, closes, toggles and refreshes the BarVis window. Nothing else.
--
-- The window is our own BarVisWindow container (Widgets\BarVisWindow.lua: X button,
-- centered Close, fixed width), created once and fed by AceConfigDialog from the
-- table Options registers under BarVis.APP. AceConfigDialog does not track a container it
-- did not create, so this module re-feeds it when a bar's mode changes. The re-feed waits
-- one frame (AceTimer): a window button click is still inside AceConfigDialog's own click
-- handling when the message arrives, and rebuilding there would release the button under it.
--
-- Takes:   Window:Open(), Window:Close(), Window:Toggle().
--          Callers: the Bindings.xml key and the minimap button (Toggle), /barvis gui (Open).
-- Listens: BARVIS_MODE_CHANGED -> re-feed while shown.
-- Never touches: the options table, EllesmereUI, chat, or saved settings.

local BarVis = LibStub("AceAddon-3.0"):GetAddon("BarVis")
local Window = BarVis:NewModule("Window", "AceEvent-3.0", "AceTimer-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- The window's height is set here, before any feed (see Widgets\BarVisWindow.lua for why).
-- 250 = the four rows plus the title and Close insets, with room so the ScrollFrame never
-- shows a scrollbar (which would narrow the row and wrap the third button).
function Window:OnInitialize()
    AceConfigDialog:SetDefaultSize(BarVis.APP, 394, 250)
end

function Window:IsShown()
    return self.window and self.window.frame:IsShown()
end

function Window:Open()
    if not self.window then
        self.window = LibStub("AceGUI-3.0"):Create("BarVisWindow")
    end
    AceConfigDialog:Open(BarVis.APP, self.window)
    self.window:Show()
end

function Window:Close()
    if self.window then self.window:Hide() end
end

function Window:Toggle()
    if self:IsShown() then self:Close() else self:Open() end
end

function Window:Refresh()
    if self:IsShown() then AceConfigDialog:Open(BarVis.APP, self.window) end
end

function Window:OnEnable()
    self:RegisterMessage("BARVIS_MODE_CHANGED", function() self:ScheduleTimer("Refresh", 0) end)
end
