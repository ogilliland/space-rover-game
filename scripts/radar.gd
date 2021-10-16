tool
extends Control

func _ready() -> void:
	_resize()
	get_tree().get_root().connect("size_changed", self, "_resize")

func _resize() -> void:
	yield(get_tree(), "idle_frame")
	rect_min_size.x = rect_size.y
