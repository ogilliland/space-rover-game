shader_type canvas_item;

uniform vec2 curvature = vec2(6.0);
uniform float scanline_opacity = 0.25;

void fragment() {
	// remap UVs to cubic function to simulate screen curvature
	vec2 uv = SCREEN_UV * 2.0 - vec2(1.0);
	vec2 offset = abs(uv.yx) / vec2(curvature.x, curvature.y);
	uv += uv * offset * offset;
    uv = uv * 0.5 + 0.5;
	
	if(uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
		COLOR = vec4(0, 0, 0, 1); // texture(SCREEN_TEXTURE, vec2(0, 0));
	} else {
		ivec2 iuv = ivec2(
			int(uv.x / SCREEN_PIXEL_SIZE.x),
			int(uv.y / SCREEN_PIXEL_SIZE.y)
		);
		vec4 color = texelFetch(SCREEN_TEXTURE, iuv, 0);
		
		// modulate color by sin wave to simulate scanlines
		float resolution = 0.25 / SCREEN_PIXEL_SIZE.y;
		float intensity = sin(uv.y * resolution * 3.141 * 2.0);
		intensity = ((0.5 * intensity) + 0.5) * 0.9 + 0.1;
		COLOR = color * vec4(vec3(pow(intensity, scanline_opacity)), 1.0);
	}
}