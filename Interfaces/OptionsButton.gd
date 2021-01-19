extends Button

onready var button = get_node(".")
onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
export var text_button = "Options"

func _ready():
	pass

func _on_Options_mouse_entered():
	button.text = "Coming Soon"
	audio.play()


func _on_Options_mouse_exited():
	button.text = text_button
