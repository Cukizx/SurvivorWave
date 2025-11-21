#extends CharacterBody2D
extends Character
class_name Player

var direction: Vector2
var move_vector := Vector2.ZERO
var no_hit_time: float = 0.0

func move(direction: Vector2):
	velocity.x = direction.x * speed
	velocity.y = direction.y * speed
	Globals.player_pos = global_position
	Globals.player_dir = direction.normalized()

func _physics_process(delta: float) -> void:
	if Globals.is_mobile:
		move_vector = Vector2.ZERO
		move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
		move(move_vector)
	else:
		var direction_x := Input.get_axis("left", "right")
		var direction_y := Input.get_axis("up", "down")
		var direction := Vector2(direction_x, direction_y).normalized()
		move(direction)
		
	move_and_slide()
	
	no_hit_time += delta
	Globals.no_hit_time = no_hit_time + delta


func _on_collision_check_area_body_entered(body: Node2D) -> void:
	if !is_invincible:
		take_damage(body.contact_damage)
		print(health)
		no_hit_time = 0.0
		Globals.no_hit_time = no_hit_time
	if health <= 0:
		death()

func death():
	get_tree().quit()
