# Game Settings
This page includes the settings necessary to get ReGlass working with various games. If the game you want to play isn't in the list below, check the [Game Settings Discussion][GameSettingsDisc] to see if anyone there has found them. Finally, you can visit the [Find Settings](FindSettings.md) page to learn how to figure these settings for yourself.


| Game | API | Copy Before Clear | Upside Down | Reversed | Logarithmic | Far Importance | Multiplier | Notes |
| :---:   | :-: | :-: | :-: | :-: | :-: | :-: | :-: | :-: |
| Cyberpunk 2077 | D3D12 | Off | 0 | 1 | 0 | 0.2 - 1000 | 0.1 - 200 | **Skylines:** Far Importance 800+, Multiplier 1-2. **Selfies:** Far Importance 0.1-0.5, Multiplier 50-200. |
| Half-Life 2 | D3D9 | On | 0 | 0 | 0 | 1.0 - 350 | 1.0 | Multiplier must be *exactly* 1.0 so not a lot of dynamic range. |
| Halo MCC | D3D11 | Off | 0 | 1 | 0 | 0.2 - 400 | 0.5 - 100 | Play offline with mods enabled. |

**API** is selected during ReShade installation for the game. ReShade won't always ask for this so if you don't see it during installation you can ignore this column.

<img src="Images/APISelection.png" width=500>

**Copy Before Clear** is set on the the last tab in ReShade. This tab will have the same name as the API (for example **D3D9**, **DX11**, etc.)

<img src="Images/CopyDepthBeforeClear.png">

To change **Upside Down**, **Reversed** or **Logarithmic**, click *Edit global preprocessor definitions*,

<img src="Images/PreProcButton.png" width=600>

then use the popup to set these values.

<img src="Images/GlobalSettings.png" width=400>

[GameSettingsDisc]: https://github.com/jbienz/ReGlass/discussions/2 "Games Setting Discussion"

