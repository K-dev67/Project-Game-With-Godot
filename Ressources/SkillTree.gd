extends Node2D

onready var label: Label = $CanvasLayer/Label
onready var Player = get_node("../Player")

func _ready() -> void:
	pass

func _on_Area2D_body_entered(body):
	Player.in_skillTree_range = true
	print("Enter skillTree area")
	label.set_visible(true)


func _on_Area2D_body_exited(body):
	Player.in_skillTree_range = false
	print("Exit skillTree area")
	label.set_visible(false)
