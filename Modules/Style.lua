-- BarVis. MIT, see LICENSE.
--
-- Style: the chat colors, so every line BarVis prints looks the same as
-- SoulShardForever's. AceConsole's Print supplies the "BarVis:" prefix; this module only
-- colors the pieces inside the line.
--
-- Takes:   Style:Value(v)  -> v in the neutral white used for a setting's value
--          Style:Accent(v) -> v in the green branding accent (login line author)
-- Never touches: chat (callers print), frames, EllesmereUI, or saved settings.

local BarVis = LibStub("AceAddon-3.0"):GetAddon("BarVis")
local Style = BarVis:NewModule("Style")

local GREEN, WHITE = "|cff00ff00%s|r", "|cffffffff%s|r"

function Style:Value(v) return WHITE:format(tostring(v)) end

function Style:Accent(v) return GREEN:format(tostring(v)) end
