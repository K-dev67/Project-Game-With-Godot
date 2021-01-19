extends Button


onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D

func _on_RetryButton_button_up():
	GlobalSignal.score = 0
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_RetryButton_mouse_entered():
	$".".modulate = Color("eec50a")
	audio.play()


func _on_RetryButton_mouse_exited():
	$".".modulate = Color("ffffff")
