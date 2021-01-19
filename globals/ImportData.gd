extends Node

var item_data
var zombie_dead = 0
var zombie_max
var path = "res://Data/Wave.json"

func _ready():
	var itemdata_file = File.new()
	itemdata_file.open(path, File.READ)
	#itemdata_file.open("user://Data/Wave.json", File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	item_data = itemdata_json.result
