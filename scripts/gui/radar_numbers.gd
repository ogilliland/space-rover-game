tool
extends Container

const subdiv : int = 36
export var radius_scale : float = 1.0

func _ready() -> void:
	for i in range(1, subdiv):
		var new = $Label.duplicate()
		new.text = str(i * 360 / subdiv)
		add_child(new)

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		# must re-sort the children
		var num_children = get_children().size()
		var center = rect_size * 0.5
		var radius = rect_size * 0.5 * radius_scale
		for child in range(num_children):
			var angle = deg2rad(360 * child / num_children - 90)
			var pos = center + Vector2(cos(angle), sin(angle)) * radius
			get_children()[child].rect_position = pos - get_children()[child].rect_size * 0.5

func set_some_setting():
	# some setting changed, ask for children re-sort
	queue_sort()
