extends Spatial
class_name TerrainChunk

const terrain_scale : float = 20.0
const subdiv : int = 32

var chunk_x : int
var chunk_z : int
var chunk_size : int
var texture_size : int
var base_color : Color
var remove : bool = true
var noise : OpenSimplexNoise

func _init(x, z, chunk_size, texture_size, base_color, noise):
	self.chunk_x = x
	self.chunk_z = z
	self.chunk_size = chunk_size
	self.texture_size = texture_size
	self.base_color = base_color
	self.noise = noise

func _ready() -> void:
	var ground_texture = generate_texture()
	var ground_mesh = generate_mesh()
	ground_mesh.material_override = SpatialMaterial.new()
	ground_mesh.material_override.albedo_texture = ground_texture
	translation.x = chunk_x * chunk_size
	translation.z = chunk_z * chunk_size
	add_child(ground_mesh)

func get_height(x, y) -> float:
	return noise.get_noise_2d(x + chunk_x * chunk_size, y + chunk_z * chunk_size) * terrain_scale

func generate_texture() -> ImageTexture:
	var ground_texture = ImageTexture.new()
	var image_data = Image.new()

	image_data.create(texture_size, texture_size, false, Image.FORMAT_RGB8)
	image_data.fill(base_color)
	image_data.lock()

#	for x in range(texture_size):
#		for y in range(texture_size):
#			image_data.set_pixel(x, y, Color(1.0, 0.0, 0.0))

	ground_texture.create_from_image(image_data)
	ground_texture.set_flags(0)
	return ground_texture

func generate_mesh() -> MeshInstance:
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.add_smooth_group(true)
	
	for i in range(subdiv):
		for j in range(subdiv):
			var x1 = (float(i) / subdiv - 0.5) * chunk_size
			var x2 = (float(i+1) / subdiv - 0.5) * chunk_size
			var z1 = (float(j) / subdiv - 0.5) * chunk_size
			var z2 = (float(j+1) / subdiv - 0.5) * chunk_size
			
			var y11 = get_height(x1, z1)
			var y12 = get_height(x1, z2)
			var y21 = get_height(x2, z1)
			var y22 = get_height(x2, z2)
			
			var uv11 = Vector2(float(i) / subdiv, float(j) / subdiv)
			var uv12 = Vector2(float(i) / subdiv, float(j+1) / subdiv)
			var uv21 = Vector2(float(i+1) / subdiv, float(j) / subdiv)
			var uv22 = Vector2(float(i+1) / subdiv, float(j+1) / subdiv)
			
			surface_tool.add_uv(uv11)
			surface_tool.add_vertex(Vector3(x1, y11, z1))
			surface_tool.add_uv(uv21)
			surface_tool.add_vertex(Vector3(x2, y21, z1))
			surface_tool.add_uv(uv12)
			surface_tool.add_vertex(Vector3(x1, y12, z2))
			
			surface_tool.add_uv(uv21)
			surface_tool.add_vertex(Vector3(x2, y21, z1))
			surface_tool.add_uv(uv22)
			surface_tool.add_vertex(Vector3(x2, y22, z2))
			surface_tool.add_uv(uv12)
			surface_tool.add_vertex(Vector3(x1, y12, z2))
	
	surface_tool.index()
	surface_tool.generate_normals()
	
	var ground_mesh = MeshInstance.new()
	ground_mesh.mesh = surface_tool.commit()
	
	ground_mesh.create_trimesh_collision()
	return ground_mesh
