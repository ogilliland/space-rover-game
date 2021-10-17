extends KinematicBody

const speed : int = 1
const rot_speed : float = 0.05
const friction : float = 0.95
const gravity : int = 10

var velocity := Vector3()

func _physics_process(delta : float) -> void:
	var direction := Vector2(
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
		Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
	).normalized()
	
	velocity += direction.x * speed * global_transform.basis.z
	rotate_y(direction.y * rot_speed)
	velocity *= friction
	velocity -= gravity * global_transform.basis.y
	
	velocity = move_and_slide_with_snap(velocity, -get_floor_normal(), global_transform.basis.y, true)
