extends Bullet

var pickup_deletion_chance: float = 0.9
var weapon_in_inventory: Weapon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for weapon in Globals.player.inventory.weapons:
		if weapon.name == "Floppy Disk":
			weapon_in_inventory = weapon
			break
	pickup_deletion_chance = 0.97 - 0.07 * weapon_in_inventory.level
	var on_screen_enemies: Array = get_tree().get_nodes_in_group("on_screen_enemies")
	var on_screen_pickups: Array = get_tree().get_nodes_in_group("on_screen_pickups")
	for enemy in on_screen_enemies:
		enemy.enemy_death()
	for pickup in on_screen_pickups:
		if randf() <= pickup_deletion_chance:
			pickup.queue_free()


func _process(_delta: float) -> void:
	global_position = Globals.camera_center

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
