shader_type spatial;
render_mode unshaded, depth_test_disable;

uniform float depth_scale;

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
	float linear_depth = get_depth(UV, DEPTH_TEXTURE, INV_PROJECTION_MATRIX);
	ALBEDO = vec3(linear_depth / depth_scale);
}