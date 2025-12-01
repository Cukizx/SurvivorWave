extends TextureProgressBar

@onready var game_won_progress_bar = $"../../CanvasLayer2/Panel/TextureProgressBar"
@onready var game_lost_progress_bar = $"../../CanvasLayer3/Panel2/TextureProgressBar"
@onready var death_sound = load("res://Sounds/Music/LaMorteSopraggiungeInevitabileEPuntuale.ogg")


var death_sound_audio_stream_player

func _on_timer_timeout() -> void:
	value = %Time.time_passed / 18

func _process(delta: float) -> void:
	if Globals.player.is_dead:
		game_lost_progress_bar.value -= delta * sin(randf_range(0, deg_to_rad(195))) * 100
		if game_lost_progress_bar.value <= 10:
			$"../../CanvasLayer4/Panel".visible = true
			await get_tree().create_timer(1).timeout
			GameManager.set_game_state(GameManager.GameState.GAME_OVER)
		
	if Globals.game_won:
		if game_won_progress_bar.value <= 90:
			game_won_progress_bar.value += delta * sin(randf_range(0, deg_to_rad(195))) * 100
		else:
			$"../../CanvasLayer4/Panel".visible = true
			await get_tree().create_timer(1).timeout
			GameManager.set_game_state(GameManager.GameState.GAME_OVER)
