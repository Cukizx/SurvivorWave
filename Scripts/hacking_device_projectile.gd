extends Bullet

#var damage: float
var target: Enemy
var level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !target:
		queue_free()
	global_position = Vector2(target.global_position.x, target.global_position.y - 100)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target:
		global_position.x = target.global_position.x
		global_position.y = move_toward(global_position.y, target.global_position.y, bullet_speed * delta)
		if global_position.y == target.global_position.y and $Sprite2D.animation_finished:
			queue_free()
