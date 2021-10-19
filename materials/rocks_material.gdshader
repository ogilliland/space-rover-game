shader_type spatial;

uniform sampler2D noisemap;
uniform sampler2D albedo_gradient : hint_albedo;

varying vec3 world_pos;

void vertex() {
	world_pos = (WORLD_MATRIX * vec4(0.0, 0.0, 0.0, 1.0)).xyz;
//	if(mod(world_pos.x, 1.0) > 0.5) {
//		VERTEX *= vec3(0.5, 1, 1);
//	}
	float noise = texture(noisemap, world_pos.zx * 0.02 + VERTEX.xz * 2.0).r;
	float scale = texture(noisemap, world_pos.xz * 0.02).r;
	
	VERTEX *= noise * scale * scale * scale * 3.0;
}

void fragment() {
	float color = mod(world_pos.x + world_pos.z, 0.25) / 0.25;
	ALBEDO = texture(albedo_gradient, vec2(color, 0.5)).rgb;
}
