extends Label

@onready var enemy_spawner = %"Enemy Spawner"

var minutes: int = 0
var seconds: int = 0
var time_passed: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str("%02d:%02d" % [minutes, seconds])

func _on_timer_timeout() -> void:
	seconds += 1
	time_passed += 1
	if time_passed == 1800:
		Globals.game_won = true
		get_tree().paused = true
		$"../../../CanvasLayer2".visible = true
	#if Globals.player.is_dead:
		#$"../../../CanvasLayer3".visible = true
		#get_tree().paused = true
	if seconds == 60:
		minutes += 1
		seconds = 0
	if minutes == 1 and seconds == 0:
		enemy_spawner.enemy_spawn_table = 1
		enemy_spawner.initialize_enemy_array()
	if minutes == 3 and seconds == 0:
		enemy_spawner.enemy_spawn_table = 2
		enemy_spawner.initialize_enemy_array()
	if minutes == 6 and seconds == 0:
		enemy_spawner.enemy_spawn_table = 3
		enemy_spawner.initialize_enemy_array()
	if minutes == 10 and seconds == 0:
		enemy_spawner.enemy_spawn_table = 4
		enemy_spawner.initialize_enemy_array()
	if minutes == 15 and seconds == 0:
		enemy_spawner.enemy_spawn_table = 5
		enemy_spawner.initialize_enemy_array()
	text = str("%02d:%02d" % [minutes, seconds])
	$Timer.start()
