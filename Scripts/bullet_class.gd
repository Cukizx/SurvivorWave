extends Area2D
class_name Bullet

@export var base_damage: float = 10
@export var bullet_speed: float = 200
@export var piercing: bool = true

func hit():
	if !piercing:
		queue_free()
