extends Node2D

export (PackedScene) var Mob

var mob
var pos_spawn = RandomNumberGenerator.new()
var my_random_spawn
var wave = 1


onready var current_string_wave: = "1"
onready var current_wave = ImportData.item_data[current_string_wave]
onready var current_max_zombie = current_wave.zombie
onready var current_zombie: int = 0

const Character = preload("res://Actors/Character.tscn")

onready var bullet_manager = $BulletManager
onready var camera = $Camera2D
onready var gui = $GUI
onready var start_timer: Timer = $Start
onready var mob_timer: Timer = $MobTimer
onready var between_timer: Timer = $BetweenWave

#onready var user_interface = $UserInterface/UserInterface


func _ready() -> void:
	print("ca print?")
	GlobalSignal.connect("bullet_fired", bullet_manager, "handle_bullet_spawned")
	GlobalSignal.connect("zombie_died", self, "next_wave")
	spawn_player()
	start_timer_on_screen()
	ImportData.zombie_max = current_max_zombie


func start_timer_on_screen() -> void:
	$Start.start()
	while start_timer.time_left != 0:
		GlobalSignal.emit_signal("starting", start_timer)
		yield(get_tree().create_timer(0.9), "timeout")
	GlobalSignal.emit_signal("starting", start_timer)


func spawn_player():
	var player = Character.instance()
	add_child(player)
	player.position = $SpawnPlayer.position
	player.set_camera_transform(camera.get_path())
	player.connect("died", self, "spawn_player")
	gui.set_character(player)


func get_spawn() -> void:
	pos_spawn.randomize()
	my_random_spawn = pos_spawn.randi_range(0, 13)


func _on_MobTimer_timeout() -> void:
	current_zombie += 1
	if current_zombie >= current_max_zombie:
		mob_timer.stop()
	var thisMob = Mob.instance()
	add_child(thisMob)
	thisMob.position = $ContainSpawn/SpawnOne.position
	get_spawn()
	var spawn = randi() % 13
	match spawn:
		0: 
			thisMob.position = $ContainSpawn/SpawnOne.position
		1: 
			thisMob.position = $ContainSpawn/SpawnTwo.position
		2: 
			thisMob.position = $ContainSpawn/SpawnThree.position
		3: 
			thisMob.position = $ContainSpawn/SpawnFour.position
		4: 
			thisMob.position = $ContainSpawn/SpawnFive.position
		5: 
			thisMob.position = $ContainSpawn/SpawnSix.position
		6: 
			thisMob.position = $ContainSpawn/SpawnSeven.position
		7: 
			thisMob.position = $ContainSpawn/SpawnEight.position
		8: 
			thisMob.position = $ContainSpawn/SpawnNine.position
		9: 
			thisMob.position = $ContainSpawn/SpawnTen.position
		10: 
			thisMob.position = $ContainSpawn/SpawnEleven.position
		11: 
			thisMob.position = $ContainSpawn/SpawnTwelve.position
		12: 
			thisMob.position = $ContainSpawn/SpawnThirteen.position
		13: 
			thisMob.position = $ContainSpawn/SpawnFourteen.position

	thisMob.current_hp = current_wave.max_health


func next_wave() -> void:
	wave += 1
	if wave == 11:
		return
	current_string_wave = String(wave)
	current_wave = ImportData.item_data[current_string_wave]
	current_max_zombie = current_wave.zombie
	current_zombie = 0
	ImportData.zombie_dead = 0
	ImportData.zombie_max = current_wave.zombie
	between_timer.start()
	while between_timer.time_left != 0:
		GlobalSignal.emit_signal("between", between_timer)
		yield(get_tree().create_timer(0.9), "timeout")
	GlobalSignal.emit_signal("between", between_timer)
	mob_timer.start()


func _on_Start_timeout():
	$MobTimer.start()
