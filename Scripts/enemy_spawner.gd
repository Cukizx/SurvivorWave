extends Node2D

@export var max_enemy_default: int
@export var enemy_scenes: Array[PackedScene]
@export var enemy_arrays: Array[EnemyArray]

@onready var player = Globals.player


const camera_offset = Vector2(100, 100)
var minimum_spawn_time = 0.2
var maximum_spawn_time = 0.5
var max_enemy: int
var enemy_spawn_table: int = 0


var enemy_array: EnemyArray

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#enemy_array.append_array(enemy_scenes)
	initialize_enemy_array()
	max_enemy = max_enemy_default
	_on_timer_timeout()

func _process(delta: float) -> void:
	player.camera.get_camera_rect()
	%Path2D.position = Globals.player_pos
	var point_0 = Globals.player_pos - Globals.camera_center - (Globals.camera_size.size) / 2
	var point_1 = Vector2(point_0.x + Globals.camera_size.size.x, point_0.y) 
	var point_2 = point_0 + Globals.camera_size.size
	var point_3 = Vector2(point_0.x, point_0.y + Globals.camera_size.size.y)
	
	%Path2D.curve.set_point_position(0, point_0 - camera_offset)
	%Path2D.curve.set_point_position(1, Vector2(point_1.x + camera_offset.x, point_1.y - camera_offset.y))
	%Path2D.curve.set_point_position(2, point_2 + camera_offset)
	%Path2D.curve.set_point_position(3, Vector2(point_3.x - camera_offset.x, point_3.y + camera_offset.y))
	%Path2D.curve.set_point_position(4, point_0 - camera_offset)


func spawn(spawn_index: int = -1, spawn_on_death: bool = false, spawn_point:= Vector2.ZERO):
	var index = randi_range(0, enemy_array.enemy_array.size() - 1)
	var mob: Node
	if spawn_index < 0 or spawn_index > enemy_array.enemy_array.size():
		mob = enemy_array.enemy_array[index].instantiate()
	else:
		mob = enemy_array.enemy_array[spawn_index].instantiate()
	
	#player.camera.get_camera_rect()
	#%Path2D.position = Globals.player_pos
	#var point_0 = Globals.player_pos - Globals.camera_center - (Globals.camera_size.size) / 2
	#var point_1 = Vector2(point_0.x + Globals.camera_size.size.x, point_0.y) 
	#var point_2 = point_0 + Globals.camera_size.size
	#var point_3 = Vector2(point_0.x, point_0.y + Globals.camera_size.size.y)
	#
	#%Path2D.curve.set_point_position(0, point_0 - camera_offset)
	#%Path2D.curve.set_point_position(1, Vector2(point_1.x + camera_offset.x, point_1.y - camera_offset.y))
	#%Path2D.curve.set_point_position(2, point_2 + camera_offset)
	#%Path2D.curve.set_point_position(3, Vector2(point_3.x - camera_offset.x, point_3.y + camera_offset.y))
	#%Path2D.curve.set_point_position(4, point_0 - camera_offset)
	
	if !spawn_on_death:
		var mob_spawn_location = $"../Path2D/Mob Spawn Location"
		mob_spawn_location.progress_ratio = randf()
		spawn_point = mob_spawn_location.global_position
		mob.global_position = spawn_point - global_position
	else:
		mob.global_position = spawn_point
	add_child(mob)
	#call_deferred("add_child", mob)
	


func _on_timer_timeout() -> void:
	var enemy_number = get_tree().get_node_count_in_group("enemies")
	if enemy_number < max_enemy:
		spawn()
		if Globals.no_hit_time > 15.0:
			max_enemy *= 2
			minimum_spawn_time = 0.1
			maximum_spawn_time = 0.2
		else:
			max_enemy = max_enemy_default
			minimum_spawn_time = 0.2
			maximum_spawn_time = 0.5
		$Timer.wait_time = (((maximum_spawn_time - minimum_spawn_time) * get_tree().get_node_count_in_group("enemies")) / max_enemy) + minimum_spawn_time


func _on_clock_timer_timeout() -> void:
	max_enemy = clamp((%ExperienceBar.level * 5) + (%Time.time_passed / 10), 20, max_enemy_default)
	
func initialize_enemy_array():
	enemy_array = enemy_arrays[enemy_spawn_table]
