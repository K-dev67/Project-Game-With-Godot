extends Control

onready var interface = get_node("../ShopInterface")
onready var player = get_parent().get_node("../../Character")

func _on_Button_pressed():
	interface.set_visible(false)


func _on_ShieldButton_pressed():
	if player.money < 1500:
		print("Vous n'avez pas assez d'argent")
	else:
		player.money -= 1500
		print(player.money)
		print("Vous avez un shield en plus")
