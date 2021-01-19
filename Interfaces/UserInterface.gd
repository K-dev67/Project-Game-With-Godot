extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = $PauseOverlay
onready var score: Label = $Score
onready var pause_title: Label = $PauseOverlay/Title
onready var timer: Label = $Label
onready var continue_button: Button = $PauseOverlay/PauseMenu/Continue

var paused: = false setget set_paused


func _ready() -> void:
	GlobalSignal.connect("score_updated", self, "update_interface")
	GlobalSignal.connect("player_died", self, "_on_PlayerData_player_died")
	GlobalSignal.connect("starting", self, "update_timer_interface")
	GlobalSignal.connect("between", self, "second_timer_interface")
	update_interface()


func _on_PlayerData_player_died() -> void:
	self.paused = true
	pause_title.text = "You died."
	continue_button.set_visible(false)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and pause_title.text != "You died.":
		self.paused = not paused
		scene_tree.set_input_as_handled()


func set_paused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value


func update_interface() -> void:
	score.text = "Score: %s" % GlobalSignal.score


func update_timer_interface(this_timer) -> void:
	timer.text = String(int(this_timer.time_left))
	if this_timer.time_left == 0:
		timer.set_visible(false)


func second_timer_interface(the_timer) -> void:
	print("ca arrive jusque la")
	timer.set_visible(true)
	timer.text = String(int(the_timer.time_left))
	if the_timer.time_left == 0:
		timer.set_visible(false)
