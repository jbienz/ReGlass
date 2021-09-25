/*
  LookingGlass by Jared Bienz. Based on the incredible DisplayDepth Fx originally 
  created by CeeJay.dk (with many updates and additions by the Reshade community)

  Visualizes color and depth in a format ready to be imported into HoloPlay Studio.
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

	uniform int LG_about <
		ui_type = "radio"; ui_label = " ";
		ui_text =
			"These settings configure how your screen should appear when taking screenshots for Looking Glass.\n"
			"\n"
			"\n"
			"Using the sliders below, try to achieve a full range of bright white to grey to black. When ready,\n"
			"make sure to use ReShade to take the screenshot and not the game itself.\n";
	>;

	uniform int LG_help <
		ui_category = "Additional Info"; 
		ui_category_closed = true;		
		ui_type = "radio"; ui_label = " ";
		ui_text =
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
#endif

// -- Advanced options --

uniform float fUIFarPlane <
	ui_type = "drag";
	ui_label = "Far Importance";
	ui_tooltip = "How much importance is given to objects that are far away.\n";
	ui_min = 0.0; ui_max = 1000.0;
	ui_step = 0.1;
> = 200;

uniform float fUIDepthMultiplier <
	ui_type = "drag";
	ui_label = "Multiplier";
	ui_tooltip = "RESHADE_DEPTH_MULTIPLIER=<value>";
	ui_min = 0.0; ui_max = 1000.0;
	ui_step = 0.1;
> = 2;


float GetLinearizedDepth(float2 texcoord)
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
	             "Global depth settings are intentionally overwritten while this shader is active.\n";
>

{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = PS_DisplayDepth;
	}
}
