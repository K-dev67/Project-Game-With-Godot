extends Button

onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D


func _on_QuitButton_button_up():
	get_tree().quit()


func _on_QuitButton_mouse_entered():
	$".".modulate = Color("eec50a")
	audio.play()


func _on_QuitButton_mouse_exited():
	$".".modulate = Color("ffffff")
