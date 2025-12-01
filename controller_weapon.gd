extends Bullet

var enemy_charmed: Enemy
var on_screen_enemies: Array
var max_charmed_enemy_number: int = 1
var level: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for weapon in Globals.player.inventory.weapons:
		if weapon.name == "controller":
			level = weapon.level
			break
	on_screen_enemies = get_tree().get_nodes_in_group("on_screen_enemies")
	if on_screen_enemies and get_tree().get_nodes_in_group("charmed_enemies").size() < max_charmed_enemy_number:
		charm_enemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func charm_enemy():
	enemy_charmed = on_screen_enemies[randi_range(0, on_screen_enemies.size() - 1)]
	if enemy_charmed.is_charmed:
		charm_enemy()
		return
	enemy_charmed.is_charmed = true
	enemy_charmed.target = null
	enemy_charmed.speed *= 1.2 * level
	enemy_charmed.contact_damage *= 1.3 * float(level)
	enemy_charmed.health *= 10 * level
