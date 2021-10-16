extends Control

export var target : NodePath

enum { MESSAGE, WARNING, ERROR }

var output : RichTextLabel

var splash = """
 ___                  ___  ___ 
| _ \\_____ _____ _ _ / _ \\/ __|
|   / _ \\ V / -_) '_| (_) \\__ \\
|_|_\\___/\\_/\\___|_|  \\___/|___/
						 v1.0.0
"""

var messages = [
	{ "type": MESSAGE, "text": "Welcome" },
	{ "type": MESSAGE, "text": "Type \"help\" to see a list of commands" },
	{ "type": WARNING, "text": "Satellite uplink damaged, scan to locate" }
]

func _ready() -> void:
	output = $VBoxContainer/Output
	output.append_bbcode(splash + "\n\n")
	for message in messages:
		output(message)

func output(message : Dictionary) -> void:
	var time = "[color=gray][09:00][/color]"
	var prefix = ""
	var suffix = ""
	match(message.type):
		MESSAGE:
			pass
		WARNING:
			prefix = "[color=yellow]WARNING! "
			suffix = "[/color]"
		ERROR:
			prefix = "[color=red]ERROR! "
			suffix = "[/color]"
	var result = time + "\n" + prefix + message.text + suffix + "\n\n"
	output.append_bbcode(result)
