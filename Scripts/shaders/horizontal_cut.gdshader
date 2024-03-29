shader_type spatial;
uniform sampler2D texture_albedo;
uniform float progress: hint_range(0, 1);
void fragment()
{
	vec4 albedo_tex = texture(texture_albedo, UV);
	ALBEDO = albedo_tex.rgb;
	ALPHA = albedo_tex.a;
	
	// May need to be flipped. I do not remember if UVs start at 1 or 0...
	if ((1.0-UV.y) > progress)
	{
		ALPHA = 0.0;
	}
}