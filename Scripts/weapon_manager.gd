extends Node2D

@onready var toy_gun_timer = $"Toy Gun Bullet Timer"
@onready var hacking_device_timer = $"Hacking Device Timer"

var toy_gun_projectile
var hacking_device_projectile

var active_weapons: Array[Weapon]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func spawn_projectile(projectile: PackedScene):
	var bullet = projectile.instantiate()
	add_child(bullet)


func _on_player_inventory_changed(inventory: Inventory) -> void:
	for weapon in inventory.weapons:
		if weapon.level >= 1:
			active_weapons.append(weapon)
	start_shooting()


func start_shooting():
	for weapon in active_weapons:
		match weapon.name:
			"toy_gun":
				toy_gun_timer.start()
				toy_gun_projectile = weapon.projectile
			"hacking_device":
				hacking_device_timer.start()
				hacking_device_projectile = weapon.projectile


func _on_toy_gun_bullet_timer_timeout() -> void:
	spawn_projectile(toy_gun_projectile)
