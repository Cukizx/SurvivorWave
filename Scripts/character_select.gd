extends Control


func _on_back_pressed() -> void:
	GameManager.set_game_state(GameManager.GameState.MAIN_MENU)


func _on_start_pressed() -> void:
	GameManager.set_game_state(GameManager.GameState.PLAYING)


func _on_character_1_pressed() -> void:
	Globals.character_selected = 0


func _on_character_2_pressed() -> void:
	Globals.character_selected = 1


func _on_character_3_pressed() -> void:
	Globals.character_selected = 2
