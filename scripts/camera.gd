extends Camera

export var target : NodePath
export var copy_rotation : bool = true

func _physics_process(_delta : float) -> void:
	if target:
		if copy_rotation:
			global_transform = get_node(target).global_transform
		else:
			global_transform.origin = get_node(target).global_transform.origin
