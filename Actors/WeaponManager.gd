extends Node2D

signal weapon_changed(new_weapon)

onready var current_weapon: Weapon = $Pistol

var weapons: Array = []

func _ready() -> void:
	weapons = get_children()
	for weapon in weapons:
		weapon.hide()
	current_weapon.show()


func _physics_process(delta: float) -> void:
	if not current_weapon.semi_auto and Input.is_action_pressed("Shoot") and not current_weapon.shotgun and not current_weapon.reloading:
		current_weapon.shoot()


func initialize(team: int):
	for weapon in weapons:
		weapon.initialize(team)


func get_current_weapon() -> Weapon:
	return current_weapon


func reload():
	current_weapon.start_reload()


func switch_weapon(weapon: Weapon):
	if weapon == current_weapon:
		return
	current_weapon.hide()
	weapon.show()
	current_weapon = weapon
	emit_signal("weapon_changed", current_weapon)


func _unhandled_input(event):
	if current_weapon.semi_auto and event.is_action_pressed("Shoot") and not current_weapon.shotgun and not current_weapon.reloading:
		current_weapon.shoot()
	elif current_weapon.shotgun and event.is_action_pressed("Shoot"):
		current_weapon.shoot_shotgun()


func _unhandled_key_input(event):
	if event.is_action_pressed("reload"):
		if current_weapon.shotgun:
			current_weapon.start_reload_shotgun()
		else:
			current_weapon.start_reload()
	elif event.is_action_released("weapon_1"):
		switch_weapon(weapons[0])
		current_weapon.reload_animation = "Reload_Pistol"
		get_parent().get_node("Sprite").frame = 0
	elif event.is_action_released("weapon_2"):
		switch_weapon(weapons[1])
		current_weapon.reload_animation = "Reload_Rifle"
		get_parent().get_node("Sprite").frame = 1
	elif event.is_action_released("weapon_3"):
		switch_weapon(weapons[2])
		current_weapon.reload_animation = "Reload_Shotgun"
		get_parent().get_node("Sprite").frame = 2
		# lance l'animation de pompage
		current_weapon.animation.play("Pompe_Shotgun")
