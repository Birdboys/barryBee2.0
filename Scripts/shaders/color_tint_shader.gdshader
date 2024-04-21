shader_type spatial;
uniform sampler2D sprite_texture;
uniform vec4 color : source_color;
uniform float percent = 0.0;

void fragment() {
	vec4 texture_color = texture(sprite_texture, UV);
	ALBEDO = texture_color.xyz * (1.0-percent) + color.xyz * (percent);
}