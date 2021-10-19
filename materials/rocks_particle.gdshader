shader_type particles;

uniform float rows = 4;
uniform float spacing = 1;
uniform sampler2D noisemap;

const float noise_scale = 16.0;

void vertex() {
	// arrange into rows
	vec3 pos = vec3(0, 0, 0);
	pos.z = float(INDEX);
	pos.x = mod(pos.z, rows);
	pos.z = (pos.z - pos.x) / rows;
	
	// center position
	pos.x -= rows * 0.5;
	pos.z -= rows * 0.5;
	
	// apply spacing
	pos *= spacing;
	
	// center on emitter
	pos.x += EMISSION_TRANSFORM[3][0] - mod(EMISSION_TRANSFORM[3][0], spacing);
	pos.z += EMISSION_TRANSFORM[3][2] - mod(EMISSION_TRANSFORM[3][2], spacing);
	
	// add noise based on world position
	float noise = texture(noisemap, pos.xz * 0.02).r;
	float noise2 = texture(noisemap, pos.zx * 0.02 + vec2(0.01)).r;
	pos.x += (noise - 0.5) * spacing * noise_scale;
	pos.z += (noise2 - 0.5) * spacing * noise_scale;
	
	// move particle to position
	TRANSFORM[3][0] = pos.x;
	TRANSFORM[3][1] = pos.y;
	TRANSFORM[3][2] = pos.z;
}