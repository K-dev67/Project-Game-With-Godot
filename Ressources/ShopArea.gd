extends Node2D

onready var label = $CanvasLayer/Label
onready var Player = get_node("../Player")

#func _on_ShopArea_body_entered(body):
#	print("Enter shop area")
#	get_node("Label").set_visible(true)
#
#
#func _on_ShopArea_area_entered(area):
#	print("Enter shop area")
#	get_node("Label").set_visible(true)

func _ready() -> void:
	pass

func _on_Area2D_body_entered(body):
	Player.in_shop_range = true
	print("Enter shop area")
	label.set_visible(true)


func _on_Area2D_body_exited(body):
	Player.in_shop_range = false
	print("Exit shop area")
	label.set_visible(false)
