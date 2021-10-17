tool
extends "res://scripts/gui/display_param.gd"

signal toggle

func _on_click():
	emit_signal("toggle")
