-- BarVis. MIT, see LICENSE.
--
-- Options: the one AceConfig table. AceConfigCmd turns it into the /barvis
-- commands, AceConfigDialog turns the same table into the window and the Interface
-- Options panel. Keys are the slash words; GUI-only entries carry cmdHidden, chat-only
-- entries carry dialogHidden. Same layout rules as SoulShardForever's Options.
--
-- Window: a centered status line ("Action Bar 10: Hide"), a small centered bar number
-- box (1-10, kept in this file only, not saved; committed with Enter), and one button per
-- mode sharing the row in thirds, greyed until a bar number is in, then a centered
-- "Minimap button" checkbox (saved: BarVis.db.profile.minimap.hide).
-- Chat: /barvis alone prints AceConfigCmd's command list. /barvis <show|hide|mouseover>
-- <1-10> sets a bar and echoes the result. /barvis gui opens the window.
--
-- Takes:   Modes:List() / FromEUI(), Bridge:GetMode() / SetMode() / MIN / MAX,
--          Style:Value(), Window:Open(), BarVis.db.profile.
-- Returns: Options:CommandWords() -> the root chat words, for Completion.
-- Sends:   BARVIS_OPTIONS_CHANGED ("minimap") after the checkbox changes.
-- Listens: BARVIS_MODE_CHANGED -> AceConfigRegistry:NotifyChange (the Interface Options
--          panel; Window re-feeds its own container).
-- Prints:  one result line per chat set, through AceConsole only.
-- Never touches: EllesmereUI (Bridge does), frames (AceConfigDialog and Window do).

local BarVis = LibStub("AceAddon-3.0"):GetAddon("BarVis")
local Options = BarVis:NewModule("Options", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("BarVis")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigCmd = LibStub("AceConfigCmd-3.0")

local function Modes() return BarVis:GetModule("Modes") end
local function Bridge() return BarVis:GetModule("Bridge") end
local function Value(v) return BarVis:GetModule("Style"):Value(v) end

local bar     -- the bar number typed into the window; nil until one is entered
local options -- the registered table, kept for CommandWords

-- AceConfig validate: true, or the error line (AceConfigDialog shows it, AceConfigCmd prints it)
local function ValidateBar(_, value)
    local n = tonumber(value)
    if n and n == math.floor(n) and n >= Bridge().MIN and n <= Bridge().MAX then return true end
    return L["Enter a bar number from 1 to 10."]
end

-- "Action Bar 10: Hide" with the mode in the value color, or the hint while no bar is in
local function StatusLine(n)
    if not n then return L["Type a bar number and press Enter."] end
    local mode, err = Bridge():GetMode(n)
    if not mode then return err end
    local m = Modes():FromEUI(mode)
    return L["Action Bar %d: %s"]:format(n, Value(m and m.label or mode))
end

-- a chat command's apply and its one result line
local function ChatSet(n, m)
    local ok, result = Bridge():SetMode(n, m.eui)
    if not ok then BarVis:Print(result) return end
    local line = StatusLine(n)
    if result then line = line .. " " .. L["(applies after combat)"] end
    BarVis:Print(line)
end

local function OpenWindow() BarVis:GetModule("Window"):Open() end

local function BuildTable()
    local args = {
        status = {
            type = "description", order = 0, width = "full", fontSize = "large",
            cmdHidden = true,
            dialogControl = "BarVisCenteredLabel", -- Widgets\BarVisCentered.lua
            name = function() return StatusLine(bar) .. "\n" end,
        },
        bar = {
            type = "input", order = 1, width = "full",
            cmdHidden = true,
            dialogControl = "BarVisCenteredEditBox", -- Widgets\BarVisCentered.lua
            name = L["Bar number"],
            desc = L["Action bar 1 to 10."],
            validate = ValidateBar,
            get = function() return bar and tostring(bar) or "" end,
            set = function(_, value) bar = tonumber(value) end,
        },

        minimap = {
            type = "toggle", order = 20, width = "full",
            cmdHidden = true, descStyle = "hidden",
            dialogControl = "BarVisCenteredCheckBox", -- Widgets\BarVisCentered.lua
            name = L["Minimap button"],
            get = function() return not BarVis.db.profile.minimap.hide end,
            set = function(_, value)
                BarVis.db.profile.minimap.hide = not value
                Options:SendMessage("BARVIS_OPTIONS_CHANGED", "minimap")
            end,
        },

        -- chat commands, hidden from the window
        gui = {
            type = "execute", order = 70,
            dialogHidden = true,
            name = L["Open the GUI"],
            desc = L["Open the BarVis GUI window."],
            func = OpenWindow,
        },
    }

    for i, m in ipairs(Modes():List()) do
        -- window button: the three share the row in thirds
        args["button_" .. m.word] = {
            type = "execute", order = 10 + i,
            width = "relative", relWidth = 0.333,
            cmdHidden = true,
            name = m.label,
            disabled = function() return not bar end,
            func = function() Bridge():SetMode(bar, m.eui) end,
        }
        -- chat command: /barvis <word> <1-10>
        args[m.word] = {
            type = "input", order = i,
            dialogHidden = true,
            name = m.label,
            desc = L["Set a bar to %s. Use: /barvis %s <1-10>"]:format(m.label, m.word),
            validate = ValidateBar,
            get = function() return "" end,
            set = function(_, value) ChatSet(tonumber(value), m) end,
        }
    end

    return { type = "group", name = L["BarVis"], args = args }
end

-- the words AceConfigCmd exposes: root entries without cmdHidden
function Options:CommandWords()
    local words = {}
    for key, entry in pairs(options.args) do
        if not entry.cmdHidden then words[#words + 1] = key end
    end
    table.sort(words)
    return words
end

function Options:OnInitialize()
    options = BuildTable()
    AceConfig:RegisterOptionsTable(BarVis.APP, options) -- no slashcmd here: /barvis is registered below
    AceConfigDialog:AddToBlizOptions(BarVis.APP, L["BarVis"])
    -- /barvis goes straight to AceConfigCmd: alone it prints the command list, anything
    -- else is parsed and dispatched to the table
    BarVis:RegisterChatCommand("barvis", function(input)
        AceConfigCmd:HandleCommand("barvis", BarVis.APP, input)
    end)
end

function Options:OnEnable()
    self:RegisterMessage("BARVIS_MODE_CHANGED", function() AceConfigRegistry:NotifyChange(BarVis.APP) end)
end
