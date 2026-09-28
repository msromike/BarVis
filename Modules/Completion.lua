-- BarVis. MIT, see LICENSE.
--
-- Completion: AceTab completion in the chat box.
--   "/barvis mo<Tab>" -> "/barvis mouseover"   (the command words Options exposes)
--
-- Takes:   Options:CommandWords() -> the root chat command words.
-- Registers: one AceTab completion set, "BarVis", on "/barvis ".
-- Never touches: the options table directly, EllesmereUI, frames, or saved settings.

local BarVis = LibStub("AceAddon-3.0"):GetAddon("BarVis")
local Completion = BarVis:NewModule("Completion")
local AceTab = LibStub("AceTab-3.0")

-- AceTab usage callback: on an ambiguous Tab, list the candidates on one line. (Passing
-- `true` instead trips a nil concat inside AceTab when two or more words match; the same
-- workaround SoulShardForever uses.)
local function TabUsage(_, matches)
    local words = {}
    for word in pairs(matches) do words[#words + 1] = word end
    table.sort(words)
    return table.concat(words, "  ")
end

function Completion:OnInitialize()
    AceTab:RegisterTabCompletion("BarVis", "/barvis ", function(words)
        for _, word in ipairs(BarVis:GetModule("Options"):CommandWords()) do
            words[#words + 1] = word
        end
    end, TabUsage)
end
