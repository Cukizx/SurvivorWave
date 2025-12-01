extends Character
class_name Enemy

@export var dead = false
@export var spawn_enemy: bool = false
@export var spawn_enemy_index: int = -1
@export var spawn_enemy_quantity: int = 0
@export var target = null
@export var experience_dropped: Resource = null

@onready var hit_flash_animation_player = $HitFlashAnimationPlayer
@onready var charmed_collision: Area2D = $CharmedEnemyCollision

var targeting_player: bool
var is_stopped: bool = false
var direction: Vector2 = Vector2.ZERO
var is_charmed: bool = false
var time_since_target_acquisition: float = 0

func _ready() -> void:
	change_target()

func _physics_process(delta: float) -> void:
	if Globals.enemy_stop or dead or is_stopped:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.self_modulate = Color(0.372, 0.568, 1.0, 1.0)
		if $AnimatedSprite2D.animation == "walk":
			$AnimatedSprite2D.pause()
	else:
		if !$AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("walk")
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		if is_charmed:
			time_since_target_acquisition += delta
			$CollisionCheckArea/Collision.disabled = true
			self.set_collision_layer_value(3, false)
			if !target or target.dead or time_since_target_acquisition > 5:
				time_since_target_acquisition = 0
				var on_screen_enemies = get_tree().get_nodes_in_group("on_screen_enemies")
				target = on_screen_enemies[randi_range(0, on_screen_enemies.size() - 1)]
				while target == self:
					target = on_screen_enemies[randi_range(0, on_screen_enemies.size() - 1)]
			self.add_to_group("charmed_enemies")
			$AnimatedSprite2D.self_modulate = Color(0.714, 0.0, 0.0, 1.0)
			charmed_collision.set_collision_mask_value(12, true)
			target.charmed_collision.set_collision_layer_value(12, true)
			direction = self.global_position.direction_to(target.global_position)
		else:
			$AnimatedSprite2D.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
			if self.position.distance_to(Globals.player.global_position) < 100:
				direction = self.global_position.direction_to(Globals.player.global_position)
				targeting_player = true
			else:
				if targeting_player:
					change_target()
				direction = self.global_position.direction_to(target.global_position)
		velocity = direction * speed
		move_and_slide()


func _on_collision_check_area_area_entered(area: Bullet) -> void:
	if !dead:
		if area is Handheld_Camera:
			stop_time(area.stun_time)
		take_damage(area.base_damage * Globals.player_damage_multiplier)
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


func _on_despawn_on_screen_exit_screen_exited() -> void:
	queue_free()

func change_target():
	targeting_player = false
	var target_selector = randi_range(0,3)
	target = Globals.player.get_child(target_selector)

func stop_time(time):
	is_stopped = true
	await get_tree().create_timer(time).timeout
	is_stopped = false


func _on_screen_entered_screen_entered() -> void:
	self.add_to_group("on_screen_enemies")

func _on_screen_entered_screen_exited() -> void:
	self.remove_from_group("on_screen_enemies")


func _on_charmed_enemy_collision_area_entered(area: Area2D) -> void:
	var enemy_target: Enemy = area.get_parent()
	enemy_target.health -= contact_damage
	enemy_target.show_damage(contact_damage)
	health -= enemy_target.contact_damage
	show_damage(enemy_target.contact_damage)
	if enemy_target.health <= 0:
		enemy_target.enemy_death()
	if health <= 0:
		enemy_death()
	#charmed_collision.set_deferred("disabled", true)
	#await  get_tree().create_timer(inv_seconds).timeout
	#charmed_collision.set_deferred("disabled", false)
	
