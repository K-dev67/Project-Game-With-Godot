extends KinematicBody2D


class_name Player


onready var hp_bar = get_parent().get_node("GUI/HpBar")
onready var shop_interface = get_parent().get_node("Shop/ShopInterface")
onready var skillTree_interface = get_parent().get_node("SkillTree2/Skills")
onready var GUI = get_node("../GUI")
onready var weapon_manager = $WeaponManager
onready var camera_transform = $CameraTransform

var in_shop_range = false
var in_skillTree_range = false

var max_hp = 400
var current_hp
var percentage_hp

var level = 0
var experience = 0
var experience_required = 200

var max_speed = 800
var speed = 0
var acceleration = 2800
var move_direction = Vector2(0,0)

# Future Var ->
#onready var health = $Health
#var money = 2000


func _ready() -> void:
	current_hp = max_hp


func set_camera_transform(camera_path: NodePath):
	camera_transform.remote_path = camera_path


func _physics_process(delta: float) -> void:
	MovementLoop(delta)
	AnimationLoop()
	look_at(get_global_mouse_position())


func _process(delta):
	open_shop()
	open_skilltree()


func MovementLoop(delta: float) -> void:
	move_direction.x = int(Input.is_action_pressed("Right"))- int(Input.is_action_pressed("Left"))
	move_direction.y = (int(Input.is_action_pressed("Down")) - int(Input.is_action_pressed("Up"))) / float(2)
	speed += acceleration * delta
	if speed > max_speed:
		speed = max_speed
	var motion = move_direction.normalized() * speed
	move_and_slide(motion)


func AnimationLoop() -> void:
	match GlobalSignal.body_state:
		"Idle":
			max_speed = 800
		"Shooting":
			max_speed = 800
		"Reloading":
			max_speed = 400


func shoot(bullet_instance, location: Vector2, direction: Vector2):
	GlobalSignal.emit_signal("bulled_fired", bullet_instance, location, direction)


func open_shop():
	if in_shop_range == true:
		if Input.is_action_just_pressed("openShop"):
			shop_interface.set_visible(true)


func open_skilltree():
	if in_skillTree_range == true:
		if Input.is_action_just_pressed("openSkillTree"):
			skillTree_interface.set_visible(true)


func OnHit(damage):
	current_hp -= damage
	HpBarUpdate()
	if current_hp <= 0:
		OnDeath()


func OnDeath():
	# Desactive sa hitbox
	get_node("CollisionPolygon2D").set_deferred("disabled", true)
	GlobalSignal.death +=1
	hp_bar.hide()
	queue_free()


func OnKill(experience_gained, score) -> void:
	var leveled = false
	experience += experience_gained
	GlobalSignal.score += score
	while experience >= experience_required:
		LevelUp()
		experience -= experience_required
		leveled = true
	GUI.UpdateExperienceBar(leveled)


func LevelUp():
	level += 1


func HpBarUpdate():
	percentage_hp = int((float(current_hp) / max_hp) * 100)
	get_parent().get_node("GUI/HpBar/Tween").interpolate_property(hp_bar, "value", hp_bar.value, percentage_hp, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	get_parent().get_node("GUI/HpBar/Tween").start()
	if percentage_hp >= 60:
		hp_bar.set_tint_progress("14e114")#Green
	elif percentage_hp <= 60 and percentage_hp >= 25:
		hp_bar.set_tint_progress("e1be32")#Orange
	else:
		hp_bar.set_tint_progress("e11e1e")#Red
