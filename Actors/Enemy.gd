extends KinematicBody2D


var floating_text = preload("res://Ressources/FloatingText.tscn")
var blood_particles = preload("res://Ressources/BloodParticles.tscn")


onready var target: KinematicBody2D = get_node("../Character")
onready var map_navigation: Navigation2D = get_node("../Navigation2D")
onready var anim: AnimationPlayer = $AnimationPlayer
onready var animated_sprite: Sprite = $Sprite


export var min_speed = 700
export var max_speed: = 700


var max_hp: int = 200
var current_hp: int

var damage: int = 50
var can_hit: bool = true

var experience_pool: int = 100
var score: int = 50

var dead: bool = false
var in_range: bool = false

var destination
var player_position

var move_rotation
var _velocity: = Vector2.ZERO


func _ready() -> void:
	current_hp = max_hp


func OnHit(damage):
	current_hp -= damage
	var text = floating_text.instance()
	text.amount = damage
	add_child(text)
	if current_hp <= 0:
		OnDeath()


func OnDeath():
	# Desactive sa hitbox
	get_node("CollisionPolygon2D").set_deferred("disabled", true)
	if dead == true:
		return
	else:
		dead = true
		var blood = blood_particles.instance()
		add_child(blood)
		anim.play("Disappear")
		yield(get_tree().create_timer(1.4), "timeout")
		ImportData.zombie_dead += 1
		if ImportData.zombie_dead >= ImportData.zombie_max:
			GlobalSignal.emit_signal("zombie_died")
		target.OnKill(experience_pool, score)
		queue_free()


func _physics_process(delta: float) -> void:
	move_along_path(delta)


func AnimationLoop(distance, move_rotation) -> void:
	animated_sprite.rotation = move_rotation


func move_along_path(delta) -> void:
	if destination == null or dead:
		return
	var path_to_destination = map_navigation.get_simple_path(get_global_position(), destination)
	var start_point: = position
	var distance = max_speed * delta
	for i in range(path_to_destination.size()):
		var distance_to_next: = start_point.distance_to(path_to_destination[0])
		if distance <= distance_to_next:
			move_rotation = get_angle_to(start_point.linear_interpolate(path_to_destination[0], distance / distance_to_next))
			var motion = Vector2(max_speed, 0).rotated(move_rotation)
			var move_direction = (start_point.angle_to_point(path_to_destination[0])/3.14 * 180)
			move_and_slide(motion)
			AnimationLoop(distance_to_next, move_rotation)
			break
		distance -= distance_to_next
		start_point = path_to_destination[0]
		path_to_destination.remove(0)


func _on_ChaseTimer_timeout():
	player_position = target.get_global_position()
	destination = map_navigation.get_closest_point(player_position)


func _on_MeleeRange_body_exited(body):
	if body.name == "Character":
		in_range = false


func _on_MeleeRange_body_entered(body):
	if body.name == "Character":
		in_range = true
		while in_range == true:
			yield(get_tree().create_timer(0.3), "timeout")
			if in_range == true and can_hit == true:
				anim.play("Attack")
				body.OnHit(damage)
				can_hit = false
				yield(get_tree().create_timer(0.5), "timeout")
				can_hit = true
			else:
				return
