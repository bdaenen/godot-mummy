
shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;


void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb = vec3(1.0) - texture(SCREEN_TEXTURE,SCREEN_UV).rgb;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
