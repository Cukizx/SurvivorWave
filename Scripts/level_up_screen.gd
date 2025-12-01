extends Control

class_name LevelUpScreen

@onready var weapon_slot1 = %Panel
@onready var weapon_slot2 = %Panel2
@onready var weapon_slot3 = %Panel3
@onready var weapon_frame1 = %WeaponIcon1
@onready var weapon_frame2 = %WeaponIcon2
@onready var weapon_frame3 = %WeaponIcon3


@onready var level_box_empty = preload("res://Sprites/Level_box_empty.png")
@onready var level_box_full = preload("res://Sprites/Level_box_full.png")




@export var inventory_slots: Array[Node]
@export var inventory_slots_level: Array[Node]
@export var weapons: Array[Weapon]
@export var items: Array[Item]
@export var player_inventory: Resource
@export var weapon_name: Array[Node]
@export var weapon_description: Array[Node]

var level_up_weapons: Array[Resource]
var possible_weapons: Array[Weapon]
var possible_items: Array[Item]
var possible_choices: Array[Resource]

func _ready() -> void:
	update_inventory()
	
	%Health.text = "Health " + "\nx" + str(Globals.player_health_modifier)
	%Armor.text = "Dmg reduction " + "\nx" + str(Globals.player_armor)
	%Speed.text = "Speed " + "\nx" + str(Globals.player_speed_modifier)
	%EffectDuration2.text = "Effect duration " + "\nx" + str(Globals.effect_duration_modifier)
	%ExpGain2.text = "Exp Gain " + "\nx" + str(Globals.player_experience_modifier)
	%DamageAmp.text = "Dmg amp " + "\nx" + str(Globals.player_damage_multiplier)
	%BulletSpeed2.text = "Bullet speed " + "\nx" + str(Globals.bullet_speed_modifier)
	%ProjectileNumber2.text = "Add projectiles " + "\n+" + str(Globals.projectile_number_modifier)
	%WeaponCooldown2.text = "Wpn Cooldown " + "\nx" + str(Globals.weapon_cooldown_modifier)
	%AoE2.text = "Area of Effect " + "\nx" + str(Globals.area_of_effect_modifier)
	
	if Globals.player.inventory.weapons.size() >= 5:
		for weapon in Globals.player.inventory.weapons:
			if weapon.level < 7:
				possible_weapons.append(weapon)
	else:
		for weapon in weapons:
			if weapon.level < 7:
				possible_weapons.append(weapon)
	if Globals.player.inventory.items.size() >= 5:
		for item in Globals.player.inventory.items:
			if item.level < 6:
				possible_items.append(item)
	else:
		for item in items:
			if item.level < 6:
				possible_items.append(item)
	possible_choices.append_array(possible_items)
	possible_choices.append_array(possible_weapons)
	if possible_choices.size() < 3:
		weapon_slot3.visible = false
	if possible_choices.size() < 2:
		weapon_slot2.visible = false
	if possible_choices.size() == 0:
		weapon_slot1.visible = false
		%NoPossibleWeapons.visible = true
		await get_tree().create_timer(3).timeout
		GameManager.set_game_state(GameManager.GameState.PLAYING)

	var slots: Array[TextureRect]
	var possible_choices_size = possible_choices.size()
	slots.append(weapon_frame1)
	slots.append(weapon_frame2)
	slots.append(weapon_frame3)
	for slot_number in clamp(possible_choices_size, 0, 3):
		var choice = possible_choices.pop_at(randi_range(0, possible_choices.size() - 1))
		slots[slot_number].texture = choice.sprite
		weapon_name[slot_number].text = choice.name
		weapon_description[slot_number].text = choice.description
		level_up_weapons.append(choice)


func _on_weapon_1_pressed() -> void:
	check_choice_owned(0)
	GameManager.set_game_state(GameManager.GameState.PLAYING)


func _on_weapon_2_pressed() -> void:
	check_choice_owned(1)
	GameManager.set_game_state(GameManager.GameState.PLAYING)


func _on_weapon_3_pressed() -> void:
	check_choice_owned(2)
	GameManager.set_game_state(GameManager.GameState.PLAYING)

func check_choice_owned(index):
	if level_up_weapons[index] is Weapon:
		for weapon in Globals.player.inventory.weapons:
			if level_up_weapons[index].name == weapon.name:
				weapon.level += 1
				Globals.player.get_parent().inventory_changed.emit(Globals.player.inventory)
				return
	if level_up_weapons[index] is Item:
		for item in Globals.player.inventory.items:
			if level_up_weapons[index].name == item.name:
				item.level += 1
				Globals.player.get_parent().inventory_changed.emit(Globals.player.inventory)
				return
	Globals.player.add_weapon(level_up_weapons[index])

func update_inventory():
	var slot_index = 0
	for weapon in player_inventory.weapons:
		if slot_index > 4:
			break
		inventory_slots[slot_index].texture = weapon.sprite
		for level in weapon.level:
			inventory_slots_level[slot_index].get_children()[level].texture = level_box_full
		slot_index += 1
	slot_index = 5
	for item in player_inventory.items:
		inventory_slots[slot_index].texture = item.sprite
		for level in item.level:
			inventory_slots_level[slot_index].get_children()[level].texture = level_box_full
		slot_index += 1
