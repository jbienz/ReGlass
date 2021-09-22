/*
  LookingGlass by Jared Bienz. Based on the incredible DisplayDepth Fx originally 
  created by CeeJay.dk (with many updates and additions by the Reshade community)

  Visualizes color and depth in a format ready to be imported into HoloPlay Studio.
  Use this to configure the depth input preprocessor definitions (RESHADE_DEPTH_INPUT_*).
*/

#include "ReShade.fxh"

// -- Basic options --
#if __RESHADE__ >= 40500 // If Reshade version is above or equal to 4.5
	#if RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN
		#define UPSIDE_DOWN_HELP_TEXT "RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN is currently set to 1.\n"\
			"If the depth map is upside down, change this to 0."
	#else
		#define UPSIDE_DOWN_HELP_TEXT "RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN is currently set to 0.\n"\
			"If the depth map is upside down, change this to 1."
	#endif
	
	#if RESHADE_DEPTH_INPUT_IS_REVERSED
		#define REVERSED_HELP_TEXT "RESHADE_DEPTH_INPUT_IS_REVERSED is currently set to 1.\n"\
			"If near objects are dark and far objects are bright, change this to 0."
	#else
		#define REVERSED_HELP_TEXT "RESHADE_DEPTH_INPUT_IS_REVERSED is currently set to 0.\n"\
			"If near objects are dark and far objects are bright, change this to 1."
	#endif
	
	#if RESHADE_DEPTH_INPUT_IS_LOGARITHMIC
		#define LOGARITHMIC_HELP_TEXT "RESHADE_DEPTH_INPUT_IS_LOGARITHMIC is currently set to 1.\n"\
			"If the depth map has banding artifacts (extra stripes) change this to 0."
	#else
		#define LOGARITHMIC_HELP_TEXT "RESHADE_DEPTH_INPUT_IS_LOGARITHMIC is currently set to 0.\n"\
			"If the depth map has banding artifacts (extra stripes) change this to 1."
	#endif

	uniform int Depth_help <
		ui_type = "radio"; ui_label = " ";
		ui_text =
			"These settings configure how your screen should appear when taking screenshots for Looking Glass.\n"
			"\n"
			"\n"
			"Using the sliders below, try to achieve a full range of bright white to grey to black. When ready,\n"
			"make sure to use ReShade to take the screenshot and not the game itself.\n"
			"\n"
			"\n"
			"The settings below are only used while this filter is active, but some global settings will affect.\n"
			"how screenshots appear. For example:\n"
			"\n"
			"\n"
			UPSIDE_DOWN_HELP_TEXT "\n"
		    "\n"
			REVERSED_HELP_TEXT "\n"
		    "\n"
			LOGARITHMIC_HELP_TEXT "\n";
	>;
#else // "ui_text" was introduced in ReShade 4.5, so cannot show instructions in older versions
	uniform bool bUIUseLivePreview <
		ui_label = "Show live preview";
		ui_tooltip = "Enable this to show use the preview settings below rather than the saved preprocessor settings.";
	> = true;

#endif

// -- Advanced options --
#if __RESHADE__ >= 40500
uniform int Advanced_help <
	ui_category = "Advanced settings"; 
	ui_category_closed = true;
	ui_type = "radio"; ui_label = " ";
	ui_text =
		"\nThe following settings also need to be set using \"Edit global preprocessor definitions\" above in order to take effect.\n"
		"You can preview how they will affect the Depth map using the controls below.\n\n"
		"It is rarely necessary to change these though, as their defaults fit almost all games.";
	>;

	uniform bool bUIUseLivePreview <
		ui_category = "Advanced settings";
		ui_label = "Show live preview";
		ui_tooltip = "Enable this to show use the preview settings below rather than the saved preprocessor settings.";
	> = true;
#endif

uniform float fUIFarPlane <
	ui_category = "Advanced settings"; 
	ui_type = "drag";
	ui_label = "Far Plane (Preview)";
	ui_tooltip = "RESHADE_DEPTH_LINEARIZATION_FAR_PLANE=<value>\n"
	             "Changing this value is not necessary in most cases.";
	ui_min = 0.0; ui_max = 1000.0;
	ui_step = 0.1;
> = RESHADE_DEPTH_LINEARIZATION_FAR_PLANE;

uniform float fUIDepthMultiplier <
	ui_category = "Advanced settings"; 
	ui_type = "drag";
	ui_label = "Multiplier (Preview)";
	ui_tooltip = "RESHADE_DEPTH_MULTIPLIER=<value>";
	ui_min = 0.0; ui_max = 1000.0;
	ui_step = 0.001;
> = RESHADE_DEPTH_MULTIPLIER;


float GetLinearizedDepth(float2 texcoord)
{
	if (!bUIUseLivePreview)
	{
		return ReShade::GetLinearizedDepth(texcoord);
	}
	else
	{
		if (RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN)
			texcoord.y = 1.0 - texcoord.y;

		float depth = tex2Dlod(ReShade::DepthBuffer, float4(texcoord, 0, 0)).x * fUIDepthMultiplier;

		const float C = 0.01;
		if (RESHADE_DEPTH_INPUT_IS_LOGARITHMIC)
			depth = (exp(depth * log(C + 1.0)) - 1.0) / C;

		if (RESHADE_DEPTH_INPUT_IS_REVERSED)
			depth = 1.0 - depth;

		const float N = 1.0;
		depth /= fUIFarPlane - depth * (fUIFarPlane - N);

		return depth;
	}
}

void CenterView(inout float4 position : SV_Position, inout float2 texcoord : TEXCOORD, out float half_buffer)
{
	// Calculate half and quarter buffer width
	half_buffer = BUFFER_WIDTH * 0.5;
	float quarter_buffer = half_buffer * 0.5;
	
	// Force to use the left side of the view only
	if (position.x <= half_buffer)
	{
		position.x = position.x + quarter_buffer;
		texcoord.x = texcoord.x + 0.25;
	}
	else
	{
		position.x = (position.x - half_buffer) + quarter_buffer;
		texcoord.x = (texcoord.x - 0.5) + 0.25;	
	}
}

void PS_DisplayDepth(in float4 position : SV_Position, in float2 texcoord : TEXCOORD, out float3 color : SV_Target)
{
	// Save the original x
	float original_x = position.x;

	// Place to recieve half buffer
	float half_buffer = 0;
	
	// Center the viewport
	CenterView(position, texcoord, half_buffer);

	// Calculate depth and normal
	float3 depth = 1.0 - GetLinearizedDepth(texcoord).xxx; // Invert since LookingGlass wants white as close

	// Ordered dithering
#if 1
	const float dither_bit = 8.0; // Number of bits per channel. Should be 8 for most monitors.
	// Calculate grid position
	float grid_position = frac(dot(texcoord, (BUFFER_SCREEN_SIZE * float2(1.0 / 16.0, 10.0 / 36.0)) + 0.25));
	// Calculate how big the shift should be
	float dither_shift = 0.25 * (1.0 / (pow(2, dither_bit) - 1.0));
	// Shift the individual colors differently, thus making it even harder to see the dithering pattern
	float3 dither_shift_RGB = float3(dither_shift, -dither_shift, dither_shift); // Subpixel dithering
	// Modify shift acording to grid position.
	dither_shift_RGB = lerp(2.0 * dither_shift_RGB, -2.0 * dither_shift_RGB, grid_position);
	depth += dither_shift_RGB;
#endif

	// Get the original color at this position
	float3 color_orig = tex2D(ReShade::BackBuffer, texcoord).rgb;

	// Show split color and depth
	color = lerp(color_orig, depth, step(half_buffer, original_x));
}

technique LookingGlass <
	ui_tooltip = "This shader allows you to capture screenshots in the right format for Looking Glass Portrait.\n"
	             "To set the settings click on 'Edit global preprocessor definitions' and set them there - not in this shader.\n"
	             "The settings will then take effect for all shaders, including this one.\n"  
	             "\n"
	             "By default calculated normals and depth are shown side by side.\n"
	             "Normals (on the left) should look smooth and the ground should be greenish when looking at the horizon.\n"
	             "Depth (on the right) should show close objects as dark and use gradually brighter shades the further away objects are.\n";
>

{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_DisplayDepth;
	}
}
