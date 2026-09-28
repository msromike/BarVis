-- BarVis. MIT, see LICENSE.
--
-- Modes: the three visibility modes BarVis offers, in button order.
--
-- Takes:   nothing.
-- Returns: Modes:List() -> ordered list of { word, label, eui }
--            word  = the chat word (/barvis <word> 10)
--            label = the button and status-line text
--            eui   = EllesmereUIActionBars' barVisibility value
--          Modes:FromWord(word) -> entry or nil (case-insensitive)
--          Modes:FromEUI(value) -> entry or nil
-- Never touches: EllesmereUI, frames, chat, or saved settings.

local BarVis = LibStub("AceAddon-3.0"):GetAddon("BarVis")
local Modes = BarVis:NewModule("Modes")
local L = LibStub("AceLocale-3.0"):GetLocale("BarVis")

local LIST = {
    { word = "show",      label = L["Show"],      eui = "always"    },
    { word = "hide",      label = L["Hide"],      eui = "never"     },
    { word = "mouseover", label = L["Mouseover"], eui = "mouseover" },
}

function Modes:List() return LIST end

function Modes:FromWord(word)
    if type(word) ~= "string" then return nil end
    word = word:lower()
    for _, m in ipairs(LIST) do
        if m.word == word then return m end
    end
end

function Modes:FromEUI(value)
    for _, m in ipairs(LIST) do
        if m.eui == value then return m end
    end
end
