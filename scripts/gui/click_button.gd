tool
extends Control

export var label : String = "Action" setget set_label
export var command : bool = true

signal click

func _ready() -> void:
	update()

func update() -> void:
	var prefix = ""
	if command:
		prefix = "> "
	$Label.text = prefix + label

func set_label(new : String) -> void:
	label = new
	update()

func _on_click():
	emit_signal("click")
