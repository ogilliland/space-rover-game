extends Camera

export var target : NodePath

func _physics_process(_delta : float) -> void:
	if target:
		global_transform = get_node(target).global_transform
