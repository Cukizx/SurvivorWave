extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_play_pressed() -> void:
	GameManager.set_game_state(GameManager.GameState.PLAYING)

func _on_options_pressed() -> void:
	GameManager.set_game_state(GameManager.GameState.OPTIONS)

func _on_quit_pressed() -> void:
	get_tree().quit()
