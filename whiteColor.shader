shader_type canvas_item;

uniform bool active = false;
uniform float outline_width : hint_range(0.0, 1.0);
uniform vec4 outline_color : hint_color;
uniform float outline_height : hint_range(0.0, 100.0);

void fragment(){
	// Fill color
	vec4 previous_color = texture(TEXTURE, UV); // Current color
	vec4 white_color = vec4(1.0, 0.77, 0.1, previous_color.a);
	vec4 new_color = previous_color;

	// Outline
	float size = outline_width / 1000.0; // / float(texture(TEXTURE, vec2(0, 0)).x);
	float alpha = -8.0 * previous_color.a;
	alpha += texture(TEXTURE, UV + vec2(0.0, -outline_height*size)).a;
	alpha += texture(TEXTURE, UV + vec2(size, -outline_height*size)).a;
	alpha += texture(TEXTURE, UV + vec2(size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(size, outline_height*size)).a;
	alpha += texture(TEXTURE, UV + vec2(0.0, outline_height*size)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, outline_height*size)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, 0.0)).a;
	alpha += texture(TEXTURE, UV + vec2(-size, -outline_height*size)).a;

	if (active) {
		new_color = white_color;
		vec4 final_color = mix(new_color, outline_color, clamp(alpha, 0.0, 1.0));
		COLOR = vec4(final_color.rgb, clamp(abs(alpha) + new_color.a, 0.0, 1.0));
	} else {
		COLOR = new_color;
	}
}
