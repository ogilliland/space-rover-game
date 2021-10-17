extends Control

export var target : NodePath

enum { MESSAGE, WARNING, ERROR }

var output : RichTextLabel

var splash = """
 _____                        ____   _____ 
|  __ \\                      / __ \\ / ____|
| |__) |__ ___   _____ _ __ | |  | | (___  
|  _  // _` \\ \\ / / _ \\ '_ \\| |  | |\\___ \\ 
| | \\ \\ (_| |\\ V /  __/ | | | |__| |____) |
|_|  \\_\\__,_| \\_/ \\___|_| |_|\\____/|_____/ 
									v1.0.0
"""

var messages = [
	{ "type": MESSAGE, "text": "Welcome! Type \"help\" to see a list of commands, or use the graphical interface to the left of this terminal" },
	{ "type": WARNING, "text": "Satellite uplink damaged, scan to locate" }
]

func _ready() -> void:
	output = $VBoxContainer/Output
	output.append_bbcode(splash + "\n\n")
	for message in messages:
		_output(message)

func _output(message : Dictionary) -> void:
	var time = "[color=gray][T+10.23d][/color]"
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
