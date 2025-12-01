extends Bullet

@export var familiars: Array[SpriteFrames]

var direction: Vector2
var delta_rotation = 0
var enemy_found: Area2D = null
var level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bullet_speed *= Globals.bullet_speed_modifier
	for weapon in Globals.player.inventory.weapons:
		if weapon.name == "Digital Pen":
			level = weapon.level
			break
	base_damage = 7 + 3 * level
	position = Globals.player_pos
	$AnimatedSprite2D.sprite_frames = familiars[randi_range(0, familiars.size() - 1)]
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if enemy_found:
		if enemy_found.get_parent().dead == true:
			enemy_found = null
			$AnimatedSprite2D.animation = "idle"
			$AnimatedSprite2D.rotation_degrees = 0
		else:
			direction = global_position.direction_to(enemy_found.global_position)
			position += direction * bullet_speed * delta
	else:
		delta_rotation += delta
		position = Vector2(50 * cos(delta_rotation) + Globals.player_pos.x, 50 * sin(delta_rotation) + Globals.player_pos.y)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_enemy_check_area_area_entered(area: Area2D) -> void:
	if !enemy_found:
		enemy_found = area
		$AnimatedSprite2D.animation = "attack"
		$AnimatedSprite2D.play()
		$AnimatedSprite2D.rotation_degrees = -150
		self.look_at(enemy_found.global_position)
