tool
extends TextureRect

func draw_dotted_arc(center, radius, angle_from, angle_to, color) -> void:
	var nb_points = (angle_to - angle_from) * 4 * radius / rect_size.x
	
	for i in range(nb_points + 1):
		var length = 0.9
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var begin = center + Vector2(cos(angle_point), sin(angle_point)) * radius
		var end = center + Vector2(cos(angle_point), sin(angle_point)) * (radius + length)
		draw_line(begin, end, color)

func draw_ticks(center, radius, angle_from, angle_to, color) -> void:
	var nb_points = angle_to - angle_from
	
	for i in range(nb_points + 1):
		var length = 2
		if i % 10 == 0:
			length = 6
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		var begin = center + Vector2(cos(angle_point), sin(angle_point)) * radius
		var end = center + Vector2(cos(angle_point), sin(angle_point)) * (radius + length)
		draw_line(begin, end, color, 1.75)

func _draw() -> void:
	var center = rect_size * 0.5
	var angle_from = 0
	var angle_to = 360
	var color = Color(1, 1, 1)
	draw_ticks(center, rect_size.x * 0.4, angle_from, angle_to, color)
	draw_dotted_arc(center, rect_size.x * 0.35, angle_from, angle_to, color)
	draw_dotted_arc(center, rect_size.x * 0.275, angle_from, angle_to, color)
	draw_dotted_arc(center, rect_size.x * 0.2, angle_from, angle_to, color)
	draw_dotted_arc(center, rect_size.x * 0.125, angle_from, angle_to, color)
	draw_dotted_arc(center, rect_size.x * 0.05, angle_from, angle_to, color)
