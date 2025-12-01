extends Bullet

var scale_tween: Tween
var collision_tween: Tween
var weapon_in_inventory: Weapon
var sprite_scale: float
var collision_scale: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for weapon in Globals.player.inventory.weapons:
		if weapon.name == "Hyper Mega Super Blaster":
			weapon_in_inventory = weapon
			break
	sprite_scale = (2 + 0.5 * weapon_in_inventory.level) * Globals.area_of_effect_modifier
	collision_scale = (8 * weapon_in_inventory.level + 32) * Globals.area_of_effect_modifier
	global_position = Globals.player_pos
	rotation_degrees = randf_range(-180, 180)
	$AnimatedSprite2D.scale.y = 0
	$CollisionShape2D.shape.size.x = 0
	start_tween()
	
func start_tween():
	scale_tween = get_tree().create_tween()
	collision_tween = get_tree().create_tween()
	scale_tween.set_trans(Tween.TRANS_BOUNCE)
	scale_tween.set_ease(Tween.EASE_IN)
	scale_tween.tween_property($AnimatedSprite2D, "scale:y", sprite_scale, 0.1)
	collision_tween.tween_property($CollisionShape2D, "shape:size:x", collision_scale, 0.1)
	collision_tween.tween_property($CollisionShape2D, "shape:size:x", collision_scale, 0.1)
	scale_tween.tween_property($AnimatedSprite2D, "scale:y", sprite_scale, 0.1)
	scale_tween.tween_property($AnimatedSprite2D, "scale:y", 0, 0.1)
	collision_tween.tween_property($CollisionShape2D, "shape:size:x", 0, 0.1)

func _process(_delta: float) -> void:
	if !scale_tween.is_running():
		queue_free()
