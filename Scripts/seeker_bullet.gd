extends Bullet

@onready var closest: Area2D
#var closest_distance: float = 1000
var direction: Vector2
var damage: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Globals.player_pos
	closest = closest_target()
	damage = base_damage * Globals.player_damage_multiplier
	if !closest:
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	else:
		direction = global_position.direction_to(closest_target().global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * bullet_speed * delta

func closest_target():
	var enemies: Array = get_tree().get_nodes_in_group("enemies")
	closest = get_tree().get_first_node_in_group("enemies")
	if !closest:
		return
	var closest_distance = global_position.distance_to(closest.global_position)
	for enemy in enemies.size():
		if closest_distance > global_position.distance_to(enemies[enemy].global_position) and enemies[enemy].get_parent().dead == false:
			closest_distance = global_position.distance_to(enemies[enemy].global_position)
			closest = enemies[enemy]
	return closest

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
