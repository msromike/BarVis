# Changelog

## 0.1.0 (unreleased)

First version. WoW Forever only; requires EllesmereUI Action Bars.

- Set action bars 1 to 10 to Show, Hide or Mouseover. Writes EllesmereUI's own
  visibility setting, so it persists and matches EllesmereUI's options.
- Window with the bar's current setting, a bar dropdown and one button per mode.
- Blizzard key binding (Toggle BarVis window) opens and closes the window.
- Minimap button and LibDataBroker launcher open and close the window; the button can be
  hidden from the window. Saved once per account.
- `/barvis show|hide|mouseover N` in chat or a macro; `/barvis` lists the commands;
  `/barvis gui` opens the window. Tab completion for the command words.
- `all` in place of the bar number sets bars 1 to 10 at once: `/barvis hide all`.
- `/barvis` alone opens the window; the command list moved to `/barvis help` (or `?`).
- The window's bar number box is a dropdown: 1 to 10, then All. With All, the buttons set
  every bar, and the line at the top reads "All action bars: Hide", or "mixed".
- Tab completes the bar number too: `/barvis mo` and Tab gives `/barvis mouseover ` and
  lists 1 to 10 and `all`; each further Tab cycles `mouseover 1`, `mouseover 2` and on.
