shader_type canvas_item;
uniform float onoff;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    if (COLOR.r == 0.0 && COLOR.g == 0.0 && COLOR.b == 0.0 && COLOR.a > 0.0) {
        COLOR = mix(COLOR, vec4(0, 1, 0, 1.0), onoff);
    }
    // Left side
	if(UV.x < 0.1) {
		COLOR = mix(COLOR, vec4(0, 1, 0, 1.0), onoff);
	}
    // top side
	if(UV.y < 0.1 && UV.x < .2) {
		COLOR = mix(COLOR, vec4(0, 1, 0, 1.0), onoff);
	}
    // right side
	if(UV.x > 0.9 && UV.y > 0.55) {
		COLOR = mix(COLOR, vec4(0, 1, 0, 1.0), onoff);
	}
    // bottom side
	if(UV.y > 0.9) {
		COLOR = mix(COLOR, vec4(0, 1, 0, 1.0), onoff);
	}	 
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
