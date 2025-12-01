extends Control

@onready var fullscreen_toggle = %FullscreenToggle
@onready var master_slider = %MasterSlider
@onready var bgm_slider = %MusicSlider
@onready var sfx_slider = %SoundEffectSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DisplayServer.window_get_mode() == 3:
		fullscreen_toggle.set_pressed_no_signal(true)
	elif DisplayServer.window_get_mode() == 0:
		fullscreen_toggle.set_pressed_no_signal(false)
	
	master_slider.set_value_no_signal(Options.master_volume)
	bgm_slider.set_value_no_signal(Options.bgm_volume)
	sfx_slider.set_value_no_signal(Options.sfx_volume)


func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	Options.fullscreen_toggle(toggled_on)

func _on_back_pressed() -> void:
	Options.save_config()
	GameManager.set_game_state(GameManager.GameState.MAIN_MENU)



func _on_master_slider_value_changed(value: float) -> void:
	Options.set_volume(Sounds.AudioBus.Master, value)

func _on_music_slider_value_changed(value: float) -> void:
	Options.set_volume(Sounds.AudioBus.BGM, value)

func _on_sound_effect_slider_value_changed(value: float) -> void:
	Options.set_volume(Sounds.AudioBus.SFX, value)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		_on_back_pressed()
		accept_event()


func _on_main_menu_pressed() -> void:
	Options.save_config()
	GameManager.set_game_state(GameManager.GameState.MAIN_MENU)
