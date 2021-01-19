extends Node

signal bullet_fired(bullet, position, direction)
signal starting(start_timer)
signal between(between_timer)

signal zombie_died

signal score_updated
signal player_died

var body_state = "Idle"
var score: int = 0 setget set_score
var death: int = 0 setget set_death

func set_score(value: int) -> void:
	score = value
	emit_signal("score_updated")


func set_death(value: int) -> void:
	death = value
	emit_signal("player_died")
