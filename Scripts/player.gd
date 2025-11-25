#extends CharacterBody2D
extends Character
class_name Player

var direction: Vector2
var move_vector := Vector2.ZERO
var no_hit_time: float = 0.0
var is_dead = false
var experience: int = 0

@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	Globals.player = self

func move(direction: Vector2):
	velocity = direction * speed
	Globals.player_pos = global_position
	Globals.player_dir = direction.normalized()

func _physics_process(delta: float) -> void:
	if !is_dead:
		if Globals.is_mobile:
			move_vector = Vector2.ZERO
			move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
			move(move_vector)
		else:
			var direction_x := Input.get_axis("left", "right")
			var direction_y := Input.get_axis("up", "down")
			direction = Vector2(direction_x, direction_y).normalized()
			if direction == Vector2.ZERO:
				sprite.play("idle")
			else:
				sprite.play("walking")
			if direction.x > 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
			move(direction)
		move_and_slide()
		
	no_hit_time += delta
	Globals.no_hit_time = no_hit_time + delta

func _on_collision_check_area_body_entered(body: Node2D) -> void:
	if !Globals.enemy_stop:
		if !is_invincible and !is_dead:
			take_damage(body.contact_damage)
			print(health)
			no_hit_time = 0.0
			Globals.no_hit_time = no_hit_time
	if health <= 0:
		death()

func get_experience(experience_points: int):
	experience += experience_points
	print("Current exp: ", experience)

func death():
	is_dead = true
	$AnimatedSprite2D.play("death")
	await $AnimatedSprite2D.animation_finished
	GameManager.set_game_state(GameManager.GameState.MAIN_MENU)
