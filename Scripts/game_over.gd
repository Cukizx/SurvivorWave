extends Control

func _ready() -> void:
	if Globals.game_won:
		$AnimatedSprite2D.animation = "won"
		$AnimatedSprite2D.play()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("enter"):
		GameManager.set_game_state(GameManager.GameState.MAIN_MENU)
