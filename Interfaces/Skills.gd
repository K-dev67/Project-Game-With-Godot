extends Control

onready var interface = get_node("../Skills")
onready var player = get_parent().get_node("../../Character")


func _on_Button_pressed():
	print("click")
	interface.set_visible(false)
