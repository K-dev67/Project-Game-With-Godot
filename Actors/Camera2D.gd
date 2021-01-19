extends Camera2D

# !IMPORTANT -> Script a déplacer sur camera du Map01

export var decay = 0.8 # Vitesse ou la vibration s'arrete
export var max_offset = Vector2(100,75) # Max Horizon/Vertical vibre en pixel
export var max_roll = 0.1 # Max rotation 

export (NodePath) var target # Assign le node a cette camera

var trauma = 0.15 # La force actuel de la vibration
var trauma_power = 2 # 

func _ready():
	randomize()

func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)

func shake():
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * rand_range(-1,1)
	offset.x = max_offset.x * amount * rand_range(-1,1)
	offset.y = max_offset.y * amount * rand_range(-1,1)

