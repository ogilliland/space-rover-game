tool
extends Particles

export var rows = 4 setget set_rows
export var spacing = 1.0 setget set_spacing

const max_height = 10

func update_aabb():
	var size = rows * spacing + 8
	visibility_aabb = AABB(Vector3(-0.5 * size, 0, -0.5 * size), Vector3(size, max_height, size))

func set_rows(new_rows):
	rows = new_rows
	amount = rows * rows;
	update_aabb()
	if process_material:
		process_material.set_shader_param("rows", new_rows)

func set_spacing(new_spacing):
	spacing = new_spacing
	update_aabb()
	if process_material:
		process_material.set_shader_param("spacing", new_spacing)

func _ready():
	set_rows(rows)
