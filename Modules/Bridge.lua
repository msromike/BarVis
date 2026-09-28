-- BarVis. MIT, see LICENSE.
--
-- Bridge: the only file that reads or writes EllesmereUI.
--
-- It makes the same calls EllesmereUI's own Visibility dropdown makes
-- (EllesmereUIOptions\EUI_ActionBars_Options.lua, VisOpts onChanged): write the mode with
-- VisibilityCompat.ApplyMode, then RefreshRuntimeVisibility, RefreshMouseover and
-- ApplyCombatVisibility. In combat EllesmereUI defers the secure part and applies it
-- itself when combat ends.
--
-- Takes:   Bridge:GetMode(n)          n = bar number 1-10
--          Bridge:SetMode(n, euiMode) euiMode = an EllesmereUI barVisibility value
-- Returns: GetMode -> mode string, or nil and an error line. It reads through
--          VisibilityCompat.Normalize, as EllesmereUI's own dropdown does, which folds
--          legacy booleans into barVisibility (same values, no change of mode).
--          SetMode -> true and inCombat (the change lands after combat), or nil and an
--          error line.
-- Sends:   BARVIS_MODE_CHANGED (n, euiMode) after every successful SetMode.
-- Never touches: frames, chat, or any EllesmereUI setting other than the bar's visibility.

local BarVis = LibStub("AceAddon-3.0"):GetAddon("BarVis")
local Bridge = BarVis:NewModule("Bridge", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("BarVis")

Bridge.MIN, Bridge.MAX = 1, 10

local function EAB()
    local lite = EllesmereUI and EllesmereUI.Lite
    local eab = lite and lite.GetAddon("EllesmereUIActionBars", true)
    if eab and eab.db and eab.VisibilityCompat then return eab end
end

-- The bar's settings table, or nil and an error line.
local function BarSettings(n)
    local eab = EAB()
    if not eab then return nil, L["EllesmereUI Action Bars is not loaded."] end
    local s = eab.db.profile.bars["Bar" .. n]
    if not s then return nil, L["Action Bar %d has no EllesmereUI settings."]:format(n) end
    return s, nil, eab
end

function Bridge:GetMode(n)
    local s, err, eab = BarSettings(n)
    if not s then return nil, err end
    return eab.VisibilityCompat.Normalize(s)
end

function Bridge:SetMode(n, euiMode)
    local s, err, eab = BarSettings(n)
    if not s then return nil, err end
    eab.VisibilityCompat.ApplyMode(s, euiMode)
    eab:RefreshRuntimeVisibility()
    eab:RefreshMouseover()
    eab:ApplyCombatVisibility()
    self:SendMessage("BARVIS_MODE_CHANGED", n, euiMode)
    return true, InCombatLockdown()
end
