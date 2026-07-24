shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float r = length((UV - vec2(0.5, 0.5)) * vec2(16.0, 9.0));
	COLOR = textureLod(screen_texture, UV, smoothstep(3.0, 10.0, r) * 2.0);
	COLOR.rgb *= 1.0 - smoothstep(4.0, 10.0, r);
	COLOR.rgb += textureLod(screen_texture, UV, 4.0).rgb * 0.5;
	COLOR.rgb += textureLod(screen_texture, UV, 8.0).rgb * 0.5;
}
