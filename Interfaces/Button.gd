extends Button

onready var pause = get_parent().get_node("../../../UserInterface")
onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var paused = true

func _on_Button_button_up():
	pause.paused = false

func _on_Button_mouse_entered():
	$".".modulate = Color("eec50a")
	audio.play()

func _on_Button_mouse_exited():
	$".".modulate = Color("ffffff")
