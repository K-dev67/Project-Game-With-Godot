tool
extends Button

export (String, FILE) var next_scene_path: = ""
onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_PlayButton_button_up():
	get_tree().change_scene(next_scene_path)
	get_tree().paused = false


func _get_configuration_warning() -> String:
	return "next_scene_path must be set for the button to work" if next_scene_path == "" else ""


func _on_ChangeSceneButton_mouse_entered():
	$".".modulate = Color("eec50a")
	audio.play()

func _on_ChangeSceneButton_mouse_exited():
	$".".modulate = Color("ffffff")
