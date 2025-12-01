extends Bullet


var level: int = 0
var hit_time: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_damage = 5 * level
	global_position = Globals.player_pos
	for weapon in Globals.player.inventory.weapons:
		if weapon.name == "Electric Guitar":
			level = weapon.level
			break


func _process(_delta: float) -> void:
	global_position = Globals.player_pos
	$ElectricGuitarVFX.scale = Vector2(2, 2) * level * Globals.area_of_effect_modifier

func _physics_process(_delta: float) -> void:
	$DonutCollisionPolygon2D.radius = 54 * level * Globals.area_of_effect_modifier
	

func _on_timer_timeout() -> void:
	$Timer.wait_time = hit_time * 2 / level
	base_damage = 5 * level
	$DonutCollisionPolygon2D.set_deferred("disabled", false)
	await get_tree().create_timer(0.1).timeout
	$DonutCollisionPolygon2D.set_deferred("disabled", true)
	$Timer.start()
