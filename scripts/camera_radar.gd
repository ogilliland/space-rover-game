extends Camera

export var target : NodePath

var height : float

func _ready() -> void:
	height = global_transform.origin.y

func _physics_process(_delta : float) -> void:
	if target:
		global_transform.origin = get_node(target).global_transform.origin
		global_transform.origin.y = height;
		
		# TO DO - make this more robust
		rotation.y = get_node(target).get_parent().rotation.y
