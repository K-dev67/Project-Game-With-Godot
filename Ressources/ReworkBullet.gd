extends Area2D

class_name Bullet

onready var kill_timer = $KillTimer
var damage = 50

export (int) var speed = 50
var direction := Vector2.ZERO

func _ready():
	kill_timer.start()

func _physics_process(delta: float) -> void:
	if direction != Vector2.ZERO:
		var velocity = direction * speed
		global_position += velocity

func set_direction(direction: Vector2):
	self.direction = direction
	rotation += direction.angle()


func _on_KillTimer_timeout():
	queue_free()


func _on_Bullet_body_entered(body):
	get_node("CollisionShape2D").set_deferred("disabled", true)
	if body.is_in_group("Enemies"):
		body.OnHit(damage)
	self.hide()
