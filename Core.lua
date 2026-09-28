-- BarVis. MIT, see LICENSE.
--
-- BarVis: set an EllesmereUI action bar to Show, Hide or Mouseover from a window, a
-- keybind or chat.
--
-- HOUSE RULE: Ace everywhere. If an Ace3 library does a job, use it; never hand-roll a
-- replacement or reach around it. One way to print (AceConsole), one settings table
-- (AceConfig), one message path (AceEvent), one completion path (AceTab), one db (AceDB).
--
-- Core: the addon object, the AceConfig app name, the saved settings, the key-binding
-- label and the login line. Nothing else. The work is in the modules under Modules\:
--   Modes      the three modes and their EllesmereUI values
--   Bridge     the only file that reads or writes EllesmereUI
--   Style      the chat colors
--   Options    the AceConfig table: window controls and the /barvis chat commands
--   Completion AceTab completion of the /barvis words
--   Window     opens, closes, toggles and refreshes the window (the keybind lands here)
--   Broker     the LibDataBroker launcher and the LibDBIcon minimap button
-- Saves only the minimap button state, in one account-wide profile. The bar settings
-- live in EllesmereUIActionBars' own profile.

local ADDON = "BarVis"
-- Registered as "BarVis": AceConsole prefixes every chat line with the registered name.
local BarVis = LibStub("AceAddon-3.0"):NewAddon("BarVis", "AceConsole-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale(ADDON)

-- The AceConfig app: Options registers the table under it, Window opens it
BarVis.APP = "BarVis"

-- Label for the Bindings.xml row in Blizzard's Key Bindings screen (a global by Blizzard's rule)
BINDING_NAME_BARVIS_TOGGLE = L["Toggle BarVis window"]

BarVis.ICON = "Interface\\Icons\\INV_Misc_Eye_01" -- file 133884; also the TOC IconTexture

local defaults = {
    profile = {
        minimap = { hide = false }, -- LibDBIcon state
    },
}

function BarVis:OnInitialize()
    -- `true`: one shared "Default" profile for every character on the account
    self.db = LibStub("AceDB-3.0"):New("BarVisDB", defaults, true)
end

function BarVis:OnEnable()
    local version = C_AddOns.GetAddOnMetadata(ADDON, "Version") or "?"
    local author = self:GetModule("Style"):Accent("msromike")
    self:Printf(L["BarVis v%s by %s. Type /barvis for commands."], version, author)
end
