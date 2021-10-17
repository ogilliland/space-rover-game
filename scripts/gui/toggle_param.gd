 tool
extends Control

export var label : String = "Label" setget set_label
export var value : float = 0.0 setget set_value
export var unit : String = "m" setget set_unit

signal toggle

func _ready() -> void:
	update()

func update() -> void:
	$HBoxContainer/Label.text = label
	$HBoxContainer/Value.text = str(value) if value != 0 else "-"
	$HBoxContainer/Unit.text = unit

func set_label(new : String) -> void:
	label = new
	update()

func set_value(new : float) -> void:
	value = new
	update()

func set_unit(new : String) -> void:
	unit = new
	update()

func _on_click():
	emit_signal("toggle")
