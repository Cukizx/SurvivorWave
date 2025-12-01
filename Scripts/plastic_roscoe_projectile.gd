extends Bullet

@onready var main_bullet = $Bullet1
@onready var bullet_up = $Bullet2
@onready var bullet_down = $Bullet3

var main_direction: Vector2
var side_direction_up: Vector2
var side_direction_down: Vector2
var rotation_angle = deg_to_rad(30)
var level
#var distance: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_bullet.bullet_speed *= Globals.bullet_speed_modifier
	bullet_up.bullet_speed *= Globals.bullet_speed_modifier
	bullet_down.bullet_speed *= Globals.bullet_speed_modifier
	global_position = Globals.player_pos
	main_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	main_bullet.look_at(main_direction + global_position)
	side_direction_up = main_direction.rotated(rotation_angle)
	bullet_up.look_at(side_direction_up + global_position)
	side_direction_down = main_direction.rotated(-rotation_angle)
	bullet_down.look_at(side_direction_down + global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#distance = main_bullet.global_position.distance_to(self.global_position)
	#if distance >= 50:
		#queue_free()
	if main_bullet:
		main_bullet.global_position += main_bullet.bullet_speed * main_direction * delta
	if bullet_up:
		bullet_up.global_position += bullet_up.bullet_speed * side_direction_up * delta
	if bullet_down:
		bullet_down.global_position += bullet_down.bullet_speed * side_direction_down * delta


func _on_main_bullet_visible_screen_notifier_screen_exited() -> void:
	main_bullet.queue_free()


func _on_bullet_up_visible_screen_notifier_screen_exited() -> void:
	bullet_up.queue_free()


func _on_bullet_down_visible_screen_notifier_screen_exited() -> void:
	bullet_down.queue_free()
