extends Node2D

enum GameState{
	MAIN_MENU,
	OPTIONS,
	PLAYING,
	PAUSED,
	GAME_OVER
}

var game_state = GameState.MAIN_MENU



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_game_state() -> GameState:
	return game_state

func set_game_state(gs: GameState):
	var old_state = game_state
	game_state = gs
	change_scene(old_state, game_state)
	
func change_scene(old_state: GameState, new_state: GameState):
	match new_state:
		GameState.MAIN_MENU:
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		GameState.PAUSED:
			var instance = load("res://Scenes/options_menu.tscn").instantiate()
			instance.position = Globals.camera_center
			get_tree().current_scene.add_child(instance)
			get_tree().current_scene.get_child(0).visible = false
			#get_tree().current_scene.get_node("Camera2D").enabled = false
			get_tree().paused = true
		GameState.PLAYING when old_state == GameState.PAUSED:
			get_tree().current_scene.get_node("OptionsMenu").queue_free()
			get_tree().current_scene.get_child(0).visible = true
			get_tree().paused = false
		GameState.PLAYING:
			get_tree().change_scene_to_file("res://Scenes/level.tscn")
			get_tree().paused = false
		GameState.OPTIONS:
			get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")
		#GameState.GAME_OVER:
			#get_tree().change_scene_to_file("res://Scenes/Game_Over.tscn")
			
func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and get_game_state() == GameState.PLAYING:
		set_game_state(GameState.PAUSED)
	#elif event.is_action_pressed("pause") and get_game_state() == GameState.PAUSED:
		#set_game_state(GameState.PLAYING)
