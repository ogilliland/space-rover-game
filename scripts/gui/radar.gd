tool
extends Control

export var texture_path : NodePath
export var camera_path : NodePath

var range_key : int = 1
var range_opts = [ 50, 100, 200]
export var range_path : NodePath

var rings_key : int = 1
var rings_opts = [ 10, 25, 50, 0]
export var rings_path : NodePath

func _ready() -> void:
	_resize()
	get_tree().get_root().connect("size_changed", self, "_resize")
	
	update_range()
	update_rings()

func _resize() -> void:
	yield(get_tree(), "idle_frame")
	rect_min_size.x = rect_size.y

func update_range() -> void:
	get_node(camera_path).size = 2 * range_opts[range_key] / 0.8
	get_node(range_path).value = range_opts[range_key]
	update_rings()

func _toggle_range() -> void:
	if range_key + 1 < range_opts.size():
		range_key += 1
	else:
		range_key = 0
	
	update_range()

func update_rings() -> void:
	get_node(rings_path).value = rings_opts[rings_key]
	get_node(texture_path).ring_scale = float(rings_opts[rings_key]) / range_opts[range_key]
	get_node(texture_path).update()

func _toggle_rings() -> void:
	if rings_key + 1 < rings_opts.size():
		rings_key += 1
	else:
		rings_key = 0
	
	update_rings()
