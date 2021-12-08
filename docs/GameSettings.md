# Game Settings
This page includes the settings necessary to get ReGlass working with various games. If the game you want to play isn't listed below, check the [Game Settings Discussion][GameSettingsDisc] to see if anyone has it working. Finally, you can visit the [Find Settings](FindSettings.md) page to learn how to configure a new game yourself.

## Games

<table>
  <colgroup>
    <col>
    <col>
	<col style="background-color:#737373">
	<col style="background-color:#6e000f">
	<col style="background-color:#006e1a">
	<col style="background-color:#02006e">
	<col style="background-color:#006e66">
	<col style="background-color:#00616e">
  </colgroup>
  <tr>
    <th>Game</th>
    <th width="12%">API</th>
	<th width="12%">Copy Before Clear</th>
	<th width="12%">Upside Down</th>
	<th width="12%">Reversed</th>
	<th width="12%">Logarithmic</th>
	<th width="12%">Far Importance</th>
	<th width="12%">Multiplier</th>
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
    <td colspan="7"><b>Skylines:</b> Far Importance 800+, Multiplier 1 - 2. <b>Close-ups:</b> Far Importance 0.2 - 0.5, Multiplier 50 - 200.</td>
  </tr>
  <tr>
	<td rowspan="2">Half-Life 2</td>
	<td>D3D9</td>
	<td>On</td>
	<td>0</td>
	<td>0</td>
	<td>0</td>
	<td>1.0 - 350</td>
	<td><b>1.0</b></td>
  </tr>
  <tr>
    <td colspan="7">Multiplier must be <i>exactly</i> <b>1.0</b> or the depth will always be white. Because of this, HL2 has somewhat limited dynamic range.</td>
  </tr>
  <tr>
	<td rowspan="2">Halo Master Chief Collection</td>
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

## API
**API** is selected during ReShade installation for the game. ReShade won't always ask for this so if you don't see it during installation you can ignore this column.

<img src="Images/APISelection.png" width=500>

## Copy Before Clear
**Copy Before Clear** is set on the the last tab in ReShade. This tab will have the same name as the API (for example **D3D9**, **D3D11**, etc.)

<img src="Images/CopyDepthBeforeClear.png">

## Upside Down, Reversed, Logarithmic
To change **Upside Down**, **Reversed** or **Logarithmic**, click *Edit global preprocessor definitions*,

<img src="Images/PreProcButton.png" width=600>

then use the popup to set these values.

<img src="Images/GlobalSettings.png" width=400>

[GameSettingsDisc]: https://github.com/jbienz/ReGlass/discussions/2 "Games Setting Discussion"
