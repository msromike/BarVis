-- BarVis. MIT, see LICENSE.
--
-- Completion: AceTab completion in the chat box, both words of a command.
--   "/barvis mo<Tab>"   -> "/barvis mouseover " and lists 1 to 10 and all
--   each further Tab    -> cycles "mouseover 1", "mouseover 2", ... "mouseover all"
--   "/barvis g<Tab>"    -> "/barvis gui"
-- One completion set offering whole phrases ("show 1", "gui"), never a second set on
-- "/barvis <word> ": AceTab keeps one insert point per chat box and every set whose prefix
-- is in the line moves it, so a second set nested inside the first made the cycle replace
-- from the wrong place ("/barvis show 1" became "/barvis 1"; found in game 2026-10-22).
--
-- Takes:   Options:CommandWords() -> the root chat command words; Modes:List() -> the
--          mode words that take a bar; Bridge.MIN / MAX -> the bar numbers.
-- Registers: one AceTab completion set, "BarVis", on "/barvis ".
-- Never touches: the options table directly, EllesmereUI, frames, or saved settings.

local BarVis = LibStub("AceAddon-3.0"):GetAddon("BarVis")
local Completion = BarVis:NewModule("Completion")
local AceTab = LibStub("AceTab-3.0")

-- numbers in numeric order, then words in alphabetical order
local function ByNumberThenWord(a, b)
    local na, nb = tonumber(a), tonumber(b)
    if na and nb then return na < nb end
    if na or nb then return na ~= nil end
    return a < b
end

local function Sorted(set)
    local list = {}
    for word in pairs(set) do list[#list + 1] = word end
    table.sort(list, ByNumberThenWord)
    return list
end

-- the bar argument after a mode word: every bar number, then "all"
local function BarWords()
    local Bridge = BarVis:GetModule("Bridge")
    local words = {}
    for n = Bridge.MIN, Bridge.MAX do words[#words + 1] = tostring(n) end
    words[#words + 1] = "all"
    return words
end

-- AceTab wordlist: every command word, a mode word as one phrase per bar
local function Phrases(words)
    local takesBar = {}
    for _, m in ipairs(BarVis:GetModule("Modes"):List()) do takesBar[m.word] = true end
    for _, word in ipairs(BarVis:GetModule("Options"):CommandWords()) do
        if takesBar[word] then
            for _, bar in ipairs(BarWords()) do words[#words + 1] = word .. " " .. bar end
        else
            words[#words + 1] = word
        end
    end
end

-- AceTab usage callback, on an ambiguous Tab: the part being chosen, on one line. All
-- matches under one command word -> its bar words; otherwise the command words. (Passing
-- `true` instead trips a nil concat inside AceTab when two or more words match; the same
-- workaround SoulShardForever uses.)
local function TabUsage(_, matches)
    local firsts, seconds = {}, {}
    for phrase in pairs(matches) do
        local first, second = phrase:match("^(%S+) (%S+)$")
        firsts[first or phrase] = true
        if second then seconds[second] = true end
    end
    local list = Sorted(firsts)
    if #list == 1 and next(seconds) then list = Sorted(seconds) end
    return table.concat(list, "  ")
end

function Completion:OnInitialize()
    AceTab:RegisterTabCompletion("BarVis", "/barvis ", Phrases, TabUsage)
end
