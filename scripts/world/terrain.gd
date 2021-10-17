#tool
extends Spatial

export var rover_path : NodePath
export var base_color : Color

var texture_size : int = 32 # pixels
var chunk_size : int = 32 # meters
var chunk_radius : int = 14 # num chunks to spawn around player

var noise : OpenSimplexNoise

var chunks : Dictionary = {}
var unready_chunks : Dictionary = {}
var thread : Thread

func _ready():
	noise = OpenSimplexNoise.new()
	noise.seed = 1234
	noise.period = 64
	noise.octaves = 6
	
	thread = Thread.new()

func _process(delta):
	update_chunks()
	clean_chunks()
	reset_chunks()

func add_chunk(x, z):
	var key = str(x) + "," + str(z)
	
	if chunks.has(key) or unready_chunks.has(key):
		return
	
	if not thread.is_active():
		thread.start(self, "load_chunk", [thread, x, z])
		unready_chunks[key] = 1

func load_chunk(arr):
	var thread = arr[0]
	var x = arr[1]
	var z = arr[2]
	
	var chunk = TerrainChunk.new(x, z, chunk_size, texture_size, base_color, noise)
	call_deferred("load_done", chunk, thread)

func load_done(chunk, thread):
	add_child(chunk)
	var key = str(chunk.chunk_x) + "," + str(chunk.chunk_z)
	chunks[key] = chunk
	unready_chunks.erase(key)
	thread.wait_to_finish()

func get_chunk(x, z):
	var key = str(x) + "," + str(z)
	if chunks.has(key):
		return chunks.get(key)
	
	return null

func update_chunks():
	var rover = get_node(rover_path)
	var chunk_origin = Vector3(0, 0, 0)
	if rover:
		chunk_origin = rover.translation
	
	# TO DO - prioritise chunks close to player (radial)
	var p_x = round(chunk_origin.x / chunk_size)
	var p_z = round(chunk_origin.z / chunk_size)
	
	add_chunk(p_x, p_z)
	var chunk = get_chunk(p_x, p_z)
	if chunk != null:
		chunk.remove = false
	
	var x_min = p_x - chunk_radius * 0.5
	var x_max = p_x + chunk_radius * 0.5
	var z_min = p_z - chunk_radius * 0.5
	var z_max = p_z + chunk_radius * 0.5
	for x in range(x_min, x_max + 1):
		for z in range(z_min, z_max + 1):
			add_chunk(x, z)
			chunk = get_chunk(x, z)
			if chunk != null:
				chunk.remove = false

func clean_chunks():
	for key in chunks:
		var chunk = chunks.get(key)
		if chunk.remove:
			chunks.erase(key)
			chunk.queue_free()

func reset_chunks():
	for key in chunks:
		chunks.get(key).remove = true
