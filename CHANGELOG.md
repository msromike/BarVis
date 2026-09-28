# Changelog

## 0.1.0 (unreleased)

First version. WoW Forever only; requires EllesmereUI Action Bars.

- Set action bars 1 to 10 to Show, Hide or Mouseover. Writes EllesmereUI's own
  visibility setting, so it persists and matches EllesmereUI's options.
- Window with the bar's current setting, a bar number box and one button per mode.
- Blizzard key binding (Toggle BarVis window) opens and closes the window.
- Minimap button and LibDataBroker launcher open and close the window; the button can be
  hidden from the window. Saved once per account.
- `/barvis show|hide|mouseover N` in chat or a macro; `/barvis` lists the commands;
  `/barvis gui` opens the window. Tab completion for the command words.
