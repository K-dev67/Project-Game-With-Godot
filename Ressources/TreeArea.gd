extends Node2D

onready var label = $CanvasLayer/Label
onready var Player = get_node("../Player")

func _ready() -> void:
	pass

func _on_Area2D_body_entered(body):
	Player.in_tree_range = true
	print("Enter tree area")
	label.set_visible(true)


func _on_Area2D_body_exited(body):
	Player.in_tree_range = true
	print("Exit tree area")
	label.set_visible(false)
