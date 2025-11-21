extends Bullet

var direction: Vector2
var damage: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	look_at(position + direction)
	rotation_degrees += 450
	damage = base_damage * Globals.player_damage_multiplier

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += bullet_speed * direction * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
