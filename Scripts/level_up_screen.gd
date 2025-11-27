extends Control

class_name LevelUpScreen

@onready var weapon_slot1 = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Weapon1
@onready var weapon_slot2 = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Weapon2
@onready var weapon_slot3 = $MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Weapon3


@export var weapons: Array[Weapon]

var level_up_weapons: Array[Weapon]
var possible_weapons: Array[Weapon]

func _ready() -> void:
	if Globals.player.inventory.weapons.size() >= 7:
		possible_weapons.append_array(Globals.player.inventory.weapons)
	else:
		possible_weapons.append_array(weapons)
	var slots: Array[Button]
	slots.append(weapon_slot1)
	slots.append(weapon_slot2)
	slots.append(weapon_slot3)
	for slot in slots:
		var weapon = possible_weapons[randi_range(0, possible_weapons.size() - 1)]
		slot.icon = weapon.sprite
		level_up_weapons.append(weapon)


func _on_weapon_1_pressed() -> void:
	check_weapon_owned(0)
	GameManager.set_game_state(GameManager.GameState.PLAYING)


func _on_weapon_2_pressed() -> void:
	check_weapon_owned(1)
	GameManager.set_game_state(GameManager.GameState.PLAYING)


func _on_weapon_3_pressed() -> void:
	check_weapon_owned(2)
	GameManager.set_game_state(GameManager.GameState.PLAYING)

func check_weapon_owned(index):
	for weapon in Globals.player.inventory.weapons:
		if level_up_weapons[index].name == weapon.name:
			weapon.level += 1
			return
	Globals.player.add_weapon(level_up_weapons[index])
