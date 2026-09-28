# BarVis

Set an EllesmereUI action bar to Show, Hide or Mouseover from a small window, a key binding or chat. It changes the same setting as the Visibility dropdown in EllesmereUI's Action Bars options, so the change sticks and shows up there too.

Requires EllesmereUI with its Action Bars module. For WoW Forever.

## Using it

- **A key.** Escape > Options > Key Bindings > BarVis > Toggle BarVis window. The key opens the window and closes it again.
- **The minimap button.** Click to open or close the window. Also available to broker display addons as "BarVis".
- **The window.** Type a bar number (1 to 10), press Enter, then click Show, Hide or Mouseover. The line at the top shows that bar's current setting. The checkbox at the bottom shows or hides the minimap button.
- **From chat or a macro.** `/barvis hide 10`

In combat, EllesmereUI holds the change until combat ends.

## Commands

| Command | What it does |
|---|---|
| `/barvis` | This list |
| `/barvis show N` | Always show bar N |
| `/barvis hide N` | Hide bar N |
| `/barvis mouseover N` | Show bar N only on mouseover |
| `/barvis gui` | Opens the window |

Tab autocompletes the BarVis commands in chat. The minimap button setting is shared by every character on the account.

## License

MIT, see [LICENSE](LICENSE).

Bundles Ace3 (BSD-style), LibDBIcon, LibDataBroker and LibStub. Each keeps its own license.
