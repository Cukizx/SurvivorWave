extends Node2D

@onready var plastic_roscoe_timer: Timer = $"Plastic Roscoe Bullet Timer"
@onready var hacking_device_timer: Timer = $"Hacking Device Timer"
@onready var digital_pen_timer: Timer = $"Digital Pen Timer"
@onready var hyper_mega_super_blaster_timer: Timer = $"Hyper Mega Super Blaster Timer"
@onready var handheld_camera_timer: Timer = $"Handheld Camera Timer"
@onready var electric_guitar_timer: Timer = $"Electric Guitar Timer"
@onready var floppy_disk_timer: Timer = $"Floppy Disk Timer"
@onready var trident_timer: Timer = $"Trident Timer"
@onready var headphones_timer: Timer = $"Headphones Timer"
@onready var controller_timer: Timer = $"Controller Timer"


var plastic_roscoe_projectile: PackedScene = null
var plastic_roscoe_damage

var hacking_device_projectile: PackedScene = null
var hacking_device_damage
var hacking_device_max_projectile

var digital_pen_projectile: PackedScene = null
var digital_pen_damage
var digital_pen_max_familiars

var hyper_mega_super_blaster_projectile: PackedScene = null
var hyper_mega_super_blaster_damage

var handheld_camera_projectile: PackedScene = null
var handheld_camera_damage

var electric_guitar_projectile: PackedScene = null
var electric_guitar_spawned: bool = false
var electric_guitar

var floppy_disk_projectile: PackedScene = null

var trident_projectile: PackedScene = null
var trident_damage

var headphones_projectile: PackedScene = null
var headphones_max_shields: int


var controller_projectile: PackedScene = null
var controller_damage

var active_weapons: Array[Weapon]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Globals.player.inventory_changed.connect(_on_player_inventory_changed)
	pass


func spawn_projectile(projectile: PackedScene, damage: float = 0.0):
	var bullet = projectile.instantiate()
	if projectile == hacking_device_projectile:
		var enemy_target = hacking_device_target_selector()
		if !enemy_target:
			return
		bullet.target = enemy_target
	bullet.base_damage = damage
	add_child(bullet)


func start_shooting():
	for weapon in active_weapons:
		match weapon.name:
			"Plastic Roscoe":
				plastic_roscoe_timer.wait_time = (0.07 + (0.93 / weapon.level)) * Globals.weapon_cooldown_modifier
				plastic_roscoe_projectile = weapon.projectile
				plastic_roscoe_damage = 3.5 * weapon.level + 0.5
				plastic_roscoe_timer.start()
			"Hacking Device":
				hacking_device_max_projectile = weapon.level
				hacking_device_timer.wait_time = (0.07 + (0.93 / weapon.level)) * Globals.weapon_cooldown_modifier
				hacking_device_projectile = weapon.projectile
				hacking_device_damage = 4 * weapon.level + 2
				hacking_device_timer.start()
			"Digital Pen":
				digital_pen_max_familiars = weapon.level
				digital_pen_timer.wait_time = (2.03 - (0.03 * (weapon.level ** 2))) * Globals.weapon_cooldown_modifier
				digital_pen_projectile = weapon.projectile
				digital_pen_damage = 7 + 3 * weapon.level
				digital_pen_timer.start()
			"Hyper Mega Super Blaster":
				hyper_mega_super_blaster_projectile = weapon.projectile
				hyper_mega_super_blaster_damage = 5.5 * weapon.level + 1.5
				hyper_mega_super_blaster_timer.wait_time = 2.25 - (0.25 * weapon.level) * Globals.weapon_cooldown_modifier
				hyper_mega_super_blaster_timer.start()
			"Handheld Camera":
				handheld_camera_projectile = weapon.projectile
				handheld_camera_damage = 5
				handheld_camera_timer.wait_time = 2.8 - (0.3 * weapon.level)
				handheld_camera_timer.start()
			"Electric Guitar":
				electric_guitar_projectile = weapon.projectile
				if !electric_guitar_spawned:
					electric_guitar = electric_guitar_projectile.instantiate()
					add_child(electric_guitar)
					electric_guitar_spawned = true
				else:
					electric_guitar.level = weapon.level
			"Floppy Disk":
				floppy_disk_projectile = weapon.projectile
				floppy_disk_timer.wait_time = 200 - 20 * weapon.level
				floppy_disk_timer.start()
			"Trident":
				trident_projectile = weapon.projectile
				trident_damage = 2.8 + 3 * weapon.level
				trident_timer.wait_time = 2.3 - 0.3 * weapon.level
				trident_timer.start()
			"Headphones":
				Globals.player.has_headphones = true
				headphones_max_shields = 1 + weapon.level / 4
				headphones_timer.wait_time = 5
				headphones_timer.start()
			"Controller":
				controller_projectile = weapon.projectile
				controller_timer.wait_time = 21.6 - 1.6 * weapon.level
				controller_timer.start()

func update_modifiers():
	for item in Globals.player.inventory.items:
		match item.name:
			"Helmet":
				Globals.player_armor = 1 + (0.1 * item.level)
			"Robert":
				Globals.bullet_speed_modifier = 1 + (0.3 * item.level)
			"Kicktail Board":
				Globals.player_speed_modifier = 1 + (0.2 * item.level)
			"Swag Sunglases":
				Globals.effect_duration_modifier = 1 + (0.1 * item.level)
			"Plastic Magazine":
				Globals.projectile_number_modifier = 1 + item.level
			"Amplifier":
				Globals.player_damage_multiplier = 1 + (0.2 * item.level)
			"Graphic Tablet":
				Globals.area_of_effect_modifier = 1 + (0.2 * item.level)
			"Disk Reader":
				Globals.weapon_cooldown_modifier = 1 + (0.2 * item.level)
			"Fighting Character":
				Globals.player_experience_modifier = 1 + (2 * item.level)
			"Cassette":
				Globals.player_health_modifier = 1 + (0.2 * item.level)

func _on_digital_pen_timer_timeout() -> void:
	var familiars_spawned_number = get_tree().get_node_count_in_group("digital_pen_familiars")
	if familiars_spawned_number  < digital_pen_max_familiars:
		spawn_projectile(digital_pen_projectile, digital_pen_damage)


func _on_hacking_device_timer_timeout() -> void:
	for i in Globals.projectile_number_modifier:
		spawn_projectile(hacking_device_projectile, hacking_device_damage)


func _on_plastic_roscoe_bullet_timer_timeout() -> void:
	for i in Globals.projectile_number_modifier:
		spawn_projectile(plastic_roscoe_projectile, plastic_roscoe_damage)


func _on_hyper_mega_super_blaster_timer_timeout() -> void:
	for i in Globals.projectile_number_modifier:
		spawn_projectile(hyper_mega_super_blaster_projectile, hyper_mega_super_blaster_damage)


func _on_handheld_camera_timer_timeout() -> void:
	for i in Globals.projectile_number_modifier:
		spawn_projectile(handheld_camera_projectile, handheld_camera_damage)


func _on_electric_guitar_timer_timeout() -> void:
	spawn_projectile(electric_guitar_projectile)


func _on_floppy_disk_timer_timeout() -> void:
	spawn_projectile(floppy_disk_projectile)


func hacking_device_target_selector() -> Enemy:
	var on_screen_enemies: Array = get_tree().get_nodes_in_group("on_screen_enemies")
	var enemy_target: Enemy
	var targetable_enemies: Array
	if on_screen_enemies.size() == 0:
		return null
	for enemy in on_screen_enemies:
		if !enemy.is_invincible and !enemy.dead:
			targetable_enemies.append(enemy)
	for current_projectile in clampi(hacking_device_max_projectile, 1, targetable_enemies.size()):
		enemy_target = targetable_enemies[randi_range(0, targetable_enemies.size() - 1)]
		targetable_enemies.erase(enemy_target)
	return enemy_target


func _on_trident_timer_timeout() -> void:
	for i in Globals.projectile_number_modifier:
		spawn_projectile(trident_projectile, trident_damage)


func _on_headphones_timer_timeout() -> void:
	if Globals.player.shield_number < headphones_max_shields:
		Globals.player.shield_number += 1
		print("shield added")


func _on_controller_timer_timeout() -> void:
	for i in Globals.projectile_number_modifier:
		spawn_projectile(controller_projectile)


func _on_player_spawner_inventory_changed(inventory: Inventory) -> void:
	for weapon in inventory.weapons:
		var already_equipped = false
		if weapon.level >= 1:
			for equipped_weapon in active_weapons:
				if weapon.name == equipped_weapon.name:
					equipped_weapon = weapon
					already_equipped = true
					break
		if !already_equipped:
			active_weapons.append(weapon)
	start_shooting()
	update_modifiers()
