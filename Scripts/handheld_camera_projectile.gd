extends Bullet

class_name Handheld_Camera

var player_inventory = Globals.player.inventory
var cone_length_multiplier: Vector2 = Vector2(1, 1)
var tween: Tween
var stun_time: float = 2
var level: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for weapon in player_inventory.weapons:
		if weapon.name == "handheld_camera":
			level = weapon.level
			break
	stun_time = (0.3 * level + 0.2) * Globals.effect_duration_modifier
	cone_length_multiplier = Vector2(0.9 + (0.1 * level), 0.9 + (0.1 * level))
	$Sprite2D.scale = $Sprite2D.scale * (0.9 + (0.1 * level)) * Globals.area_of_effect_modifier
	for i in [1, 2]:
		$CollisionPolygon2D.polygon[i] *= cone_length_multiplier * Globals.area_of_effect_modifier
	$Sprite2D.self_modulate = Color(1, 1, 1, 1)
	global_position = Globals.player_pos
	if Globals.player_dir != Vector2.ZERO:
		self.look_at(Globals.player_pos + Globals.player_dir)
	else:
		self.look_at(Globals.player_pos + Globals.player.last_dir)
	start_tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !tween.is_running():
		queue_free()


func start_tween():
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Sprite2D, "self_modulate", Color(1, 1, 1, 0), 0.2)


func _on_area_entered(_area: Area2D) -> void:
	$CollisionPolygon2D.disabled = true
