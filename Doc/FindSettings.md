# Find Game Settings
So you've already checked the [Game Settings](GameSettings.md) page and the [Game Settings Discussion][GameSettingsDisc], but the game you want to play isn't listed. Fear not! This page will help you determine the right settings for your game, and once you find them please don't forget to share them in the [Game Settings Discussion][GameSettingsDisc]!

## Compatibility
Before digging into settings it's best to verify that ReShade is compatible with your game. For that, visit the [ReShade Compatibility List][ReShadeCompat] and see if you can find your game. Note that this list isn't updated often, so if your game isn't listed it might still work. But if your game is in the list with depth buffer issues, it probably isn't compatible with ReGlass.

Below are some of the common depth issues and the behavior to expect from a game that has them. The "Counted" / "Not Counted" part indicates whether I allowed the issue in the "500+ supported games".

- **No depth buffer access -** Everything will appear flat and in the background. (Not Counted)
- **Depth buffer is empty -** Same as above. (Not Counted)
- **Depth buffer only shows XYZ (e.g. hands) -** Only XYZ will "pop out". Everything else will be flat and in the background. (Not Counted)
- **Depth buffer is flipped -** No problem. Just configure ReShade accordingly. (Counted)
- **Game uses a logarithmic depth buffer -** No problem. Just configure ReShade accordingly. (Counted)
- **Use game in offline mode -** ReShade disables depth in multiplayer because bots can use it for cheating. Offline supported. (Counted)
- **Partial depth buffer access -** Unclear but depends on the game. Might be like the hands example above. Might not work at all. (Not Counted)
- **Depth buffer flickers -** Will probably work, but you may have to take several screenshots before you get one with depth. (Counted)
- **XYZ (e.g. trees) missing from depth buffer -** Everything BUT XYZ will look OK. XYZ will appear flat and in the background. (Not Counted)
- **Depth buffer access only in menu** - May or may not work depending on where the menu is displayed. When the shader is enabled only the center 50% of the screen is displayed. If the menu is on the left or right side, you might be OK. If it's in the middle of the screen, it'll be in the way. (Not Counted)  

## API
Now that you've verified your game is compatible, it's time to install ReGlass. 

**API** selection happens during the ReShade installation for your game. Sometimes ReShade already knows the API and won't ask for this. If it does, just search the web to find out which Graphics API the game uses. 

<img src="Images/APISelection.png" width=500>

## Main Settings
Now that ReGlass is installed, launch the game and press the 'Home' button on your keyboard to bring up the ReShade menu.

When you check the box next to LookingGlass, you'll see two main sliders that can be used to achieve the desired effect:

<img src="Images/MainSettings.png" width=600>

- **Wide open shots like skylines:** Use large values for **Far Importance** (800+) and small values for **Multiplier** (1-2).
- **Narrow shots like selfies:** Use very small values for **Far Importance** (0.1 - 0.5) and large values for **Multiplier** (50-200).

## Blur Settings

The blur settings can be used to "smooth out" sharp differences in the depth map.

<img src="Images/BlurSettings.png" width=600>

There are three sliders that can be used to adjust the blur, but the defaults should work well for most screenshots.

### Why blur the depth map at all?

The primary reason is to make life easier for HoloPlay Studio when recreating the scene.

In CyberPunk 2077, for example, the depth map often has holes and pixelation in areas like hair:

<img src="Images/HairNoBlur.png">

These wreak havoc when HoloPlay tries to recreate the 3D surface for the hair. Blurring the depth map fills in holes and smoothes out the pixelation.

<img src="Images/HairBlur.png">

It's also common in games for a subject to be close to the camera when the background is far away:

<img src="Images/FaceNoBlur.png">

This again is *very* difficult for HoloPlay Studio. The sharp contrast between things that are close and things that are far causes tearing in the image. This tearing is especially visible when you view the scene from the sides. Blurring the depth map "rounds off" these sharp edges and creates a smooth transition from close to far.  

<img src="Images/FaceBlur.png">

Smooth transition means far less tearing.

## Troubleshooting

Here are some of the most common issues:

### Depth is always black or is inverted

Press the 'Edit global preprocessor definitions' button.

<img src="Images/PreProcButton.png" width=600>

Change `RESHADE_DEPTH_INPUT_IS_REVERSED` from 0 to 1 or from 1 to 0

<img src="Images/DeptheReversed.png" width=400>

Then click somewhere else to leave the popup.

### Depth is always white

#### Multiplier issues

Some games work best with a Multiplier of 1.0 or less. Other games, like Half-Life 2, only work with a multiplier of *exactly* 1.0.

<img src="Images/EditMulti.png" width=600>

#### MSAA

Multisample anti-aliasing (MSAA) is known to cause problems with ReShade depth. If your game supports MSAA, try turning it off.

#### Depth buffer clearing

Some games, like Half-Life 2, clear the depth buffer each time they clear the frame. ReShade offers a setting to make a full copy of the depth buffer before the frame is cleared. You can find this setting on the the last tab in ReShade. It's the tab with the name of the graphics API used by the game (e.g. **D3D9**, **DX11**).

<img src="Images/CopyDepthBeforeClear.png">

### Depth works in single player or campaign but not in online multiplayer

ReShade intentionally disables depth buffer access for online play. This is to keep bots from using the depth buffer to cheat. Unfortunately, ReGlass will only work in offline mode for these games.

### Other issues

When troubleshooting it can be helpful to turn OFF the **LookingGlass** shader and turn ON the **DisplayDepth** shader. Just keep in mind that by default ReShade depth is inverted compared to Looking Glass (black is close and white is far).

For additional help I recommend watching the [ReShade Depth Tutorial](https://www.youtube.com/watch?v=52KZrMOo4Y8) by Daemon White. Also, the [Depth Buffer Guide](https://github.com/martymcmodding/ReShade-Guide/wiki/The-Depth-Buffer) by martymcmodding is quite helpful. 

[GameSettingsDisc]: https://github.com/jbienz/ReGlass/issues/1 "Games Setting Discussion"
[ReShadeCompat]: https://reshade.me/compatibility "ReShade Compatibility List"