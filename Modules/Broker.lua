-- BarVis. MIT, see LICENSE.
--
-- Broker: the LibDataBroker launcher and the LibDBIcon minimap button. Click opens or
-- closes the window; the tooltip says so. Icon: INV_Misc_Eye_01 (file 133884).
--
-- Takes:   Window:Toggle(), BarVis.db.profile.minimap (LibDBIcon's own state table).
-- Listens: BARVIS_OPTIONS_CHANGED ("minimap") -> show or hide the button.
-- Never touches: EllesmereUI, the options table, or chat.

local BarVis = LibStub("AceAddon-3.0"):GetAddon("BarVis")
local Broker = BarVis:NewModule("Broker", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("BarVis")
local LDB = LibStub("LibDataBroker-1.1")
local DBIcon = LibStub("LibDBIcon-1.0")

local NAME = "BarVis" -- the broker object and minimap button: what bar addons list

function Broker:OnEnable()
    if not self.object then
        self.object = LDB:NewDataObject(NAME, {
            type = "launcher",
            label = L["BarVis"],
            icon = BarVis.ICON,
            OnClick = function() BarVis:GetModule("Window"):Toggle() end,
            OnTooltipShow = function(tooltip)
                tooltip:AddLine(L["BarVis"])
                tooltip:AddLine(L["Click to open or close the BarVis window."], 0.8, 0.8, 0.8)
            end,
        })
        DBIcon:Register(NAME, self.object, BarVis.db.profile.minimap)
    end
    self:RegisterMessage("BARVIS_OPTIONS_CHANGED", "OnOptionsChanged")
end

function Broker:OnOptionsChanged(_, key)
    if key ~= "minimap" then return end
    if BarVis.db.profile.minimap.hide then DBIcon:Hide(NAME) else DBIcon:Show(NAME) end
end
