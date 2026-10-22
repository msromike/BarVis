# Changelog

## 1.0.1 (2026-10-22)

- `/barvis help` shows `<1-10 | all>`; 1.0.0 printed `<1-10|ll>`, because the game reads
  `|a` in chat as the start of a formatting code.

## 1.0.0 (2026-10-22)

First public version. WoW Forever only; requires EllesmereUI with its Action Bars module.

- Set any action bar, 1 to 10 or all of them at once, to Show, Hide or Mouseover. BarVis
  writes EllesmereUI's own visibility setting, so the change sticks across reloads and
  matches EllesmereUI's options.
- A small window: pick a bar from the dropdown (1 to 10, or All) and click a mode. The
  line at the top shows that bar's current setting; with All, the setting every bar
  shares, or "mixed".
- The window opens with `/barvis`, a key binding (Toggle BarVis window) or the minimap
  button, which can be hidden from the window. BarVis is also a LibDataBroker launcher.
- In chat or a macro: `/barvis show|hide|mouseover N`, where N is 1 to 10 or `all`.
  `/barvis help` lists the commands, and Tab completes both words.
