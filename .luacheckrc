-- luacheck configuration for BarVis (WoW Forever runs Lua 5.1).
-- Run from the addon root: luacheck .   (the GitHub workflow does this on every push)
-- Every name in read_globals is a real WoW API or FrameXML global that BarVis calls,
-- harvested from a run with no whitelist on 2026-10-22. Add a name only when the game has it.

std = "lua51"
max_line_length = false
self = false -- a method written with ':' may leave self unused
codes = true

exclude_files = { "Libs/**", ".github/**" }

globals = {
    -- the Bindings.xml label, set by Core.lua
    "BINDING_NAME_BARVIS_TOGGLE",
}

read_globals = {
    -- libraries and the addon BarVis drives
    "LibStub", "EllesmereUI",
    -- WoW Lua extensions
    "wipe", "tinsert", "strtrim",
    -- frames and UI globals
    "CreateFrame", "UIParent", "UISpecialFrames",
    -- API namespaces
    "C_AddOns",
    -- functions
    "InCombatLockdown", "PlaySound",
    -- global strings
    "CLOSE",
}
