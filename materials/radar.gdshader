shader_type spatial;
render_mode unshaded, depth_test_disable;

uniform float contour_height = 2.0; // meters
uniform vec4 contour_color : hint_color;

const float outline_thickness = 1.0;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

float get_depth(vec2 uv, sampler2D depth_texture, mat4 inv_projection_matrix) {
	float depth = texture(depth_texture, uv).x;
	vec3 ndc = vec3(uv, depth) * 2.0 - 1.0;
	vec4 view = inv_projection_matrix * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	return linear_depth;
}

void fragment() {
	float half_floor = floor(outline_thickness * 0.5);
	float half_ceil = ceil(outline_thickness * 0.5);
	vec2 texel = 1.0/VIEWPORT_SIZE;
	
	vec2 uv0 = UV - vec2(texel.x, texel.y) * half_floor;
	vec2 uv1 = UV - vec2(texel.x, texel.y) * half_ceil;
	vec2 uv2 = UV - vec2(texel.x * half_ceil, -texel.y * half_floor);
	vec2 uv3 = UV - vec2(-texel.x * half_floor, texel.y * half_ceil);
	
	float depth_sample0 = get_depth(uv0, DEPTH_TEXTURE, INV_PROJECTION_MATRIX);
	float depth_sample1 = get_depth(uv1, DEPTH_TEXTURE, INV_PROJECTION_MATRIX);
	float depth_sample2 = get_depth(uv2, DEPTH_TEXTURE, INV_PROJECTION_MATRIX);
	float depth_sample3 = get_depth(uv3, DEPTH_TEXTURE, INV_PROJECTION_MATRIX);
	
	float edge0 = floor(depth_sample1 / contour_height);
	float edge1 = floor(depth_sample3 / contour_height);
	if(depth_sample0 < edge0 * contour_height || depth_sample0 > (edge0 + 1.0) * contour_height || depth_sample2 < edge1 * contour_height ||  depth_sample2 > (edge1 + 1.0) * contour_height) {
		ALBEDO = contour_color.rgb;
	} else {
		ALBEDO = vec3(0);
	}
}