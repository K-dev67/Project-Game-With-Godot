extends Position2D

onready var label = get_node("Label")
onready var tween = get_node("Tween")


var velocity = Vector2(0,0)
var max_size = Vector2(1,1)

var type = ""
var amount = 0

func _ready():
	label.set_text(str(amount))
	
#	match type:
#		"Heal":
#			label.set("custom_colors/font_color", Color("2eff27"))
#		"Damage":
#			label.set("custom_colors/font_color", Color("ff3131"))
#		"Critical":
#			max_size = Vector2(1.5,1.5)
#			label.set("custom_colors/font_color", Color("ff3131"))
#		"Poison": # Par exemple
	randomize()
	var side_movement = randi() % 300-200
	velocity = Vector2(side_movement, 125)
	
	tween.interpolate_property(self, 'scale', scale, max_size, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.interpolate_property(self, 'scale', max_size, Vector2(0.2,0.2), 0.8, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.4)
	tween.start()
	

func _on_Tween_tween_all_completed():
	self.queue_free()

func _process(delta):
	position -= velocity * delta
