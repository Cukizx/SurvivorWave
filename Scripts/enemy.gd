extends Character
class_name Enemy

@export var dead = false
@export var spawn_enemy: bool = false
@export var spawn_enemy_index: int = -1
@export var spawn_enemy_quantity: int = 0
@export var target = null
@export var experience_dropped: Resource = null

@onready var hit_flash_animation_player = $HitFlashAnimationPlayer

var targeting_player: bool

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	targeting_player = false
	var target_selector = randi_range(0,3)
	target = Globals.player.get_child(target_selector)
	pass

func _physics_process(_delta: float) -> void:
	if Globals.enemy_stop or dead:
		velocity = Vector2.ZERO
		if $AnimatedSprite2D.animation == "walk":
			$AnimatedSprite2D.pause()
	else:
		if !$AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("walk")
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		if self.position.distance_to(Globals.player.global_position) < 100:
			direction = self.global_position.direction_to(Globals.player.global_position)
			targeting_player = true
		else:
			if targeting_player:
				_ready()
			direction = self.global_position.direction_to(target.global_position)
		velocity = direction * speed
		move_and_slide()
		#queue_redraw()

func _draw() -> void:
	draw_line(Vector2.ZERO, direction * 100, Color.WHITE)

func _on_collision_check_area_area_entered(area: Bullet) -> void:
	if !dead:
		take_damage(area.damage)
		area.hit()
	if health <= 0:
		enemy_death()
	hit_flash_animation_player.play("hit_flash")

func enemy_death():
	dead = true
	if spawn_enemy:
		for i in spawn_enemy_quantity:
			self.get_parent().spawn(spawn_enemy_index, true, self.global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20)))
	$CollisionCheckArea.remove_from_group("enemies")
	$CollisionCheckArea/Collision.set_deferred("disabled", true)
	$CollisionShape2D.set_deferred("disabled", true)
	$AnimatedSprite2D.play("death")
	drop_experience()
	await get_tree().create_timer(2).timeout
	#await $AnimatedSprite2D.animation_finished
	queue_free()
	return dead

func drop_experience():
	var experience = experience_dropped.instantiate()
	experience.global_position = self.global_position
	await $AnimatedSprite2D.animation_finished
	add_sibling(experience)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
