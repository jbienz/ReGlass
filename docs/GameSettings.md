# Game Settings
This page includes the settings necessary to get ReGlass working with various games. If the game you want to play isn't in the list below, check the [Game Settings Discussion][GameSettingsDisc] to see if anyone there has found them. Finally, you can visit the [Find Settings](FindSettings.md) page to learn how to figure these settings for yourself.

<table>
  <tr>
    <td>**Game**</td>
    <td width="12%">**API**</td>
	<td width="12%">**Copy Before Clear**</td>
	<td width="12%">**Upside Down**</td>
	<td width="12%">**Reversed**</td>
	<td width="12%">**Logarithmic**</td>
	<td width="12%">**Far Importance**</td>
	<td width="12%">**Multiplier**</td>
  </tr>
  <tr>
	<td rowspan="2">Cyberpunk 2077</td>
	<td>D3D12</td>
	<td>Off</td>
	<td>0</td>
	<td>1</td>
	<td>0</td>
	<td>0.2 - 1000</td>
	<td>0.1 - 200</td>
  </tr>
  <tr>
    <td colspan="7">**Skylines:** Far Importance 800+, Multiplier 1-2. **Close-ups:** Far Importance 0.1-0.5, Multiplier 50-200.</td>
  </tr>
  <tr>
	<td rowspan="2">Half-Life 2</td>
	<td>D3D9</td>
	<td>On</td>
	<td>0</td>
	<td>0</td>
	<td>0</td>
	<td>1.0 - 350</td>
	<td>**1.0**</td>
  </tr>
  <tr>
    <td colspan="7">Multiplier must be *exactly* **1.0** or the depth will always be white. This limits dynamic range.</td>
  </tr>
  <tr>
	<td rowspan="2">Halo: The Master Chief Collection</td>
	<td>D3D11</td>
	<td>Off</td>
	<td>0</td>
	<td>1</td>
	<td>0</td>
	<td>0.2 - 400</td>
	<td>0.5 - 100</td>
  </tr>
  <tr>
    <td colspan="7">Start the game with mods enabled and play in offline mode.</td>
  </tr>
</table>

**API** is selected during ReShade installation for the game. ReShade won't always ask for this so if you don't see it during installation you can ignore this column.

<img src="Images/APISelection.png" width=500>

**Copy Before Clear** is set on the the last tab in ReShade. This tab will have the same name as the API (for example **D3D9**, **D3D11**, etc.)

<img src="Images/CopyDepthBeforeClear.png">

To change **Upside Down**, **Reversed** or **Logarithmic**, click *Edit global preprocessor definitions*,

<img src="Images/PreProcButton.png" width=600>

then use the popup to set these values.

<img src="Images/GlobalSettings.png" width=400>

[GameSettingsDisc]: https://github.com/jbienz/ReGlass/discussions/2 "Games Setting Discussion"

