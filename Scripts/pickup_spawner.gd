extends Node2D

@export var max_pickups: int = 2

@onready var destroyable_object = preload("res://Scenes/destroyable_obstacle.tscn")
@onready var spawn_location = $"../Path2D/Mob Spawn Location"

#var double_damage = preload("res://Scenes/double_damage.tscn")
#var stop_time = preload("res://Scenes/stop_time.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pickups.append(double_damage)
	#pickups.append(stop_time)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Globals.enemy_stop_duration > 0.0:
		Globals.enemy_stop = true
		Globals.enemy_stop_duration -= delta
	else:
		Globals.enemy_stop_duration = 0.0
		Globals.enemy_stop = false


func _on_timer_timeout() -> void:
	if randf() >= 0.8 and get_child_count() < max_pickups + 1:
		spawn_destroyable_object()

func spawn_destroyable_object():
	var destroyable = destroyable_object.instantiate()
	spawn_location.progress_ratio = randf()
	destroyable.position = spawn_location.position + Globals.camera_center
	add_child(destroyable)
