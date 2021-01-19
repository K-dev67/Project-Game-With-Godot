extends CanvasLayer


onready var experience_bar = get_node("ExperienceBar/HBoxContainer/TextureProgress")
onready var current_ammo = $HBoxContainer/CurrentAmmo
onready var max_ammo = $HBoxContainer/MaxAmmo


var character: Player

func ready():
	SetExperienceBar()


func SetExperienceBar() -> void:
	get_node("ExperienceBar/HBoxContainer/TextureRect/Label").set_text(str(character.level))
	experience_bar.max_value = character.experience_required
	experience_bar.value = character.experience


func UpdateExperienceBar(leveled):
	if leveled == true:
		experience_bar.max_value = character.experience_required
		get_node("ExperienceBar/HBoxContainer/TextureRect/Label").set_text(str(character.level))
	else:
		pass
	experience_bar.value = character.experience


func set_character(character: Player):
	self.character = character
	set_weapon(character.weapon_manager.get_current_weapon())
	character.weapon_manager.connect("weapon_changed", self, "set_weapon")


func set_weapon(weapon: Weapon):
	set_current_ammo(weapon.current_ammo)
	set_max_ammo(weapon.max_ammo)
	if not weapon.is_connected("weapon_ammo_changed", self, "set_current_ammo"):
		weapon.connect("weapon_ammo_changed", self, "set_current_ammo")


func set_current_ammo(new_ammo):
	current_ammo.text = str(new_ammo)


func set_max_ammo(new_max_ammo):
	max_ammo.text = str(new_max_ammo)
