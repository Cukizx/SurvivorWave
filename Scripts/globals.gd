extends Node

var player_pos: Vector2
var player: Player
var camera_center: Vector2
var camera_size: Rect2
var player_dir: Vector2
var is_mobile: bool
var player_damage_multiplier: float = 1.0
var enemy_stop: bool = false
var enemy_stop_duration: float = 0.0
var no_hit_time: float = 0.0
var player_experience: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("mobile"):
		is_mobile = true
	else:
		is_mobile = false
