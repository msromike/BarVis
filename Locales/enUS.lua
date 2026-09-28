-- BarVis. MIT, see LICENSE.
--
-- English strings. Every user-facing string lives here; modules read L["..."].

local L = LibStub("AceLocale-3.0"):NewLocale("BarVis", "enUS", true)
if not L then return end

L["BarVis"] = true
L["BarVis v%s by %s. Type /barvis for commands."] = true
L["Toggle BarVis window"] = true

-- Modes
L["Show"] = true
L["Hide"] = true
L["Mouseover"] = true

-- Options
L["Bar number"] = true
L["Action bar 1 to 10."] = true
L["Enter a bar number from 1 to 10."] = true
L["Type a bar number and press Enter."] = true
L["Action Bar %d: %s"] = true
L["Set a bar to %s. Use: /barvis %s <1-10>"] = true
L["(applies after combat)"] = true
L["Open the GUI"] = true
L["Open the BarVis GUI window."] = true
L["Minimap button"] = true

-- Broker
L["Click to open or close the BarVis window."] = true

-- Bridge errors
L["EllesmereUI Action Bars is not loaded."] = true
L["Action Bar %d has no EllesmereUI settings."] = true
