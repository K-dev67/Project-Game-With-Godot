extends Control


onready var label: Label = $Score

func _ready() -> void:
	label.text = label.text % [GlobalSignal.score, GlobalSignal.death]
