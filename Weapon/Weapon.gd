extends Node2D
class_name Weapon

signal weapon_ammo_changed(new_ammo_count)
signal weapon_out_of_ammo


export (PackedScene) var ReworkBullet
export (int) var max_ammo: int = 10
export (bool) var shotgun: bool = true
export (float) var cooldown: float = 1
export (float) var damage_multiplier: float = 1
export (bool) var semi_auto: bool = true
export var reload_duration = 1

onready var current_ammo = max_ammo setget set_current_ammo
onready var end_of_gun = $EndOfGun
onready var attack_cooldown = $AttackCooldown
onready var animation = $AnimationPlayer
onready var muzzle_flash = $MuzzleFlash
onready var sound_shoot = $Shoot
onready var gun_flash = $Flash

var reloading = false
var team: int = 1
var reload_animation = "Reload_Pistol"


func _ready():
	muzzle_flash.hide()
	current_ammo = max_ammo



func initialize(team: int):
	pass # Initialisera la team du player =>


func start_reload():
	reloading = true
	GlobalSignal.body_state = "Reloading"
	animation.play(reload_animation)
	yield(get_tree().create_timer(reload_duration), "timeout")
	_stop_reload()

func _stop_reload():
	current_ammo = max_ammo
	emit_signal("weapon_ammo_changed", current_ammo)
	GlobalSignal.body_state = "Idle"
	reloading = false
	animation.stop()

func start_reload_shotgun():
	if current_ammo == max_ammo:
		return
	while current_ammo < max_ammo:
		if GlobalSignal.body_state == "Shooting":
			return
		GlobalSignal.body_state = "Reloading"
		current_ammo += 1
		animation.play(reload_animation)
		# lance l'animation de chargement d'une balle
		yield(get_tree().create_timer(0.4), "timeout")
		# Mettre a jour l'affichage des balles
		emit_signal("weapon_ammo_changed", current_ammo)
		if current_ammo == max_ammo:
			# lance l'animation de pompage
			animation.play("Pompe_Shotgun")
			GlobalSignal.body_state = "Idle"
			return

func set_current_ammo(new_ammo: int):
	var actual_ammo = clamp(new_ammo, 0, max_ammo)
	if actual_ammo != current_ammo:
		current_ammo = actual_ammo
		if current_ammo == 0:
			#muzzle_flash.hide()
			emit_signal("weapon_out_of_ammo")
			if shotgun:
				start_reload_shotgun()
			else:
				start_reload()
		emit_signal("weapon_ammo_changed", current_ammo)


func shoot():
	print("Ca tire!")
	if current_ammo != 0 and attack_cooldown.is_stopped() and Bullet != null:
		var bullet_instance = ReworkBullet.instance()
		var direction = (end_of_gun.global_position - global_position).normalized()
		bullet_instance.damage = bullet_instance.damage * damage_multiplier
		print(animation)
		animation.play("muzzle_flash")
		sound_shoot.play()
		GlobalSignal.emit_signal("bullet_fired", bullet_instance, end_of_gun.global_position, direction)
		GlobalSignal.body_state = "Shooting"
		attack_cooldown.start()
		set_current_ammo(current_ammo - 1)
		yield(get_tree().create_timer(0.3), "timeout")
		muzzle_flash.hide()
		gun_flash.hide()
		GlobalSignal.body_state = "Idle"

func shoot_shotgun():
	print("Ca tire!")
	if current_ammo != 0 and attack_cooldown.is_stopped() and Bullet != null:
		#print("shotgun")
		for angle in [-5, 0, 5]:
			var radians = deg2rad(angle)
			print(radians)
			var bullet_instance = ReworkBullet.instance()
			var direction = (end_of_gun.global_position - global_position).normalized()
			bullet_instance.damage = bullet_instance.damage * damage_multiplier
			direction = direction.rotated(radians)
			GlobalSignal.emit_signal("bullet_fired", bullet_instance, end_of_gun.global_position, direction)
		#animation.play("muzzle_flash")
		print(animation)
		animation.play("Shoot_Shotgun")
		GlobalSignal.body_state = "Shooting"
		attack_cooldown.start()
		yield(get_tree().create_timer(0.3), "timeout")
		muzzle_flash.hide()
		gun_flash.hide()
		GlobalSignal.body_state = "Idle"
		set_current_ammo(current_ammo - 1)
