extends Control

@onready var fullscreen_toggle = %FullscreenToggle
@onready var master_slider = %MasterSlider
@onready var bgm_slider = %MusicSlider
@onready var sfx_slider = %SoundEffectSlider
@onready var main_menu_nutton = %MainMenu

@onready var level_box_empty = preload("res://Sprites/Level_box_empty.png")
@onready var level_box_full = preload("res://Sprites/Level_box_full.png")

@export var inventory_slots: Array[Node]
@export var inventory_slots_level: Array[Node]
@export var player_inventory: Inventory

# Called when the node enters the scene tree for the first time.
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
	
	if DisplayServer.window_get_mode() == 3:
		fullscreen_toggle.set_pressed_no_signal(true)
	elif DisplayServer.window_get_mode() == 0:
		fullscreen_toggle.set_pressed_no_signal(false)
	
	master_slider.set_value_no_signal(Options.master_volume)
	bgm_slider.set_value_no_signal(Options.bgm_volume)
	sfx_slider.set_value_no_signal(Options.sfx_volume)
	
	if GameManager.get_game_state() == GameManager.GameState.PAUSED:
		main_menu_nutton.visible = true
	else:
		main_menu_nutton.visible = false

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	Options.fullscreen_toggle(toggled_on)

func _on_back_pressed() -> void:
	Options.save_config()
	var game_state = GameManager.get_game_state()
	if game_state == GameManager.GameState.PAUSED:
		GameManager.set_game_state(GameManager.GameState.PLAYING)

	elif game_state == GameManager.GameState.OPTIONS:
		GameManager.set_game_state(GameManager.GameState.MAIN_MENU)



func _on_master_slider_value_changed(value: float) -> void:
	Options.set_volume(Sounds.AudioBus.Master, value)

func _on_music_slider_value_changed(value: float) -> void:
	Options.set_volume(Sounds.AudioBus.BGM, value)

func _on_sound_effect_slider_value_changed(value: float) -> void:
	Options.set_volume(Sounds.AudioBus.SFX, value)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_on_back_pressed()
		accept_event()


func _on_main_menu_pressed() -> void:
	Options.save_config()
	GameManager.set_game_state(GameManager.GameState.MAIN_MENU)
	
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
