shader_type canvas_item;
uniform float onoff;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if(UV.x < 0.1) {
		COLOR = mix(COLOR, vec4(0, 1, 0, 1.0), onoff);
	}
	if(UV.y < 0.1) {
		COLOR = mix(COLOR, vec4(0, 1, 0, 1.0), onoff);
	}
	if(UV.x > 0.9) {
		COLOR = mix(COLOR, vec4(0, 1, 0, 1.0), onoff);
	}
	if(UV.y > 0.9) {
		COLOR = mix(COLOR, vec4(0, 1, 0, 1.0), onoff);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
