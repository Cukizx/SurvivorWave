extends Character
class_name Enemy

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var raycasts = $Rays
@export var dead = false
@export var spawn_enemy: bool = false
@export var spawn_enemy_index: int = -1
@export var spawn_enemy_quantity: int = 0

var max_steering: float = 50
var direction: Vector2 = Vector2.ZERO
var avoid_force: int = 1000
var rays: Array

func _ready() -> void:
	#nav_agent.target_position = Globals.player_pos + (Globals.player_dir * 70 * clampf(position.distance_to(Globals.player_pos)/100, 0.0, 1.0))
	rays = raycasts.get_children()
	pass

func _physics_process(delta: float) -> void:
	var steering: Vector2 = Vector2.ZERO
	steering += seek_steering()
	steering += avoid_obstacles_steering()
	steering = steering.clampf(-max_steering, max_steering)

	velocity += steering
	velocity = velocity.clampf(-speed, speed)
	
	raycasts.rotation = velocity.angle()
	#var direction = to_local(nav_agent.get_next_path_position()).normalized()
	#var new_velocity = direction * speed
	if Globals.enemy_stop or dead:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.pause()
	#else:
		#if !$AnimatedSprite2D.is_playing():
			#$AnimatedSprite2D.play("walk")
		#if nav_agent.avoidance_enabled:
			#nav_agent.set_velocity(new_velocity)
		#else:
			#_on_navigation_agent_2d_velocity_computed(new_velocity)
		#move_and_slide()
		#

	else:
		if !$AnimatedSprite2D.is_playing():
			$AnimatedSprite2D.play("walk")
		#direction = global_position.direction_to(Globals.player_pos)
		#if rays[0].is_colliding():
			#print("Direction not rotated: ", direction)
			#direction = direction.rotated(ray_not_colliding().global_rotation)
			#print("Direction rotated: ", direction)
			#print("Ray not colliding: ", ray_not_colliding())
			#print("Ray rotation: ", ray_not_colliding().global_rotation)
		#velocity = direction * speed
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		move_and_slide()

	queue_redraw()
		
	#for ray in rays:
		#pass
func _draw() -> void:
	draw_line(Vector2.ZERO, direction * 100, Color.WHITE)

func seek_steering() -> Vector2:
	var desired_velocity: Vector2 = global_position.direction_to(Globals.player_pos) * speed
	return desired_velocity - velocity
	
func avoid_obstacles_steering() -> Vector2:
	raycasts.rotation = velocity.angle()
	
	for ray in rays:
		#ray.target_position.x = velocity.length()
		if ray.is_colliding() and ray.get_collider() is CharacterBody2D :
			var enemy: CharacterBody2D = ray.get_collider()
			return (global_position + velocity - enemy.global_position).normalized() * avoid_force
	return Vector2.ZERO

func ray_not_colliding():
	var colliding: bool = true
	for ray in rays:
		colliding = ray.is_colliding()
		if !colliding:
			return ray
	return null

func makepath():
	if Globals.player_pos.distance_to(nav_agent.target_position) > 50:
		nav_agent.target_position = Globals.player_pos + (Globals.player_dir * 70 * clampf(position.distance_to(Globals.player_pos)/100, 0.0, 1.0))

#func _on_timer_timeout() -> void:
	#await get_tree().create_timer(randf_range(0.2, 1)).timeout
	#if !Globals.enemy_stop:
		#makepath()


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity

func _on_collision_check_area_area_entered(area: Bullet) -> void:
	take_damage(area.damage)
	area.hit()
	if health <= 0:
		enemy_death()

func enemy_death():
	#$CollisionCheckArea/Collision.set_deferred("disabled", true)
	if spawn_enemy:
		for i in spawn_enemy_quantity:
			self.get_parent().spawn(spawn_enemy_index, true, self.global_position + Vector2(randf_range(-20, 20), randf_range(-20, 20)))
	$CollisionCheckArea.queue_free()
	$CollisionShape2D.set_deferred("disabled", true)
	$NavigationAgent2D.avoidance_enabled = false
	dead = true
	#print("collision status: ", $CollisionCheckArea/Collision.disabled)
	$AnimatedSprite2D.self_modulate = Color(1, 1, 1, 0)
	self.remove_from_group("enemies")
	await get_tree().create_timer(2).timeout
	queue_free()
	return dead


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
