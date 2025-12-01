extends Bullet

var direction: Vector2
#var damage: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Globals.player_pos
	direction = Globals.player.last_dir
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	self.look_at(global_position + Globals.player.last_dir)
	#damage = base_damage * Globals.player_damage_multiplier


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * bullet_speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
