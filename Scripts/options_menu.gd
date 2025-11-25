extends Control

@onready var fullscreen_toggle = $HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/FullscreenToggle
@onready var master_slider = $HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/MasterSlider
@onready var bgm_slider = $HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/MusicSlider
@onready var sfx_slider = $HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/GridContainer/SoundEffectSlider
@onready var main_menu_nutton = $HBoxContainer/VBoxContainer/MarginContainer/VBoxContainer/MarginContainer2/HBoxContainer/MainMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if DisplayServer.window_get_mode() == 3:
		fullscreen_toggle.set_pressed_no_signal(true)
	elif DisplayServer.window_get_mode() == 0:
		fullscreen_toggle.set_pressed_no_signal(false)
	
	master_slider.set_value_no_signal(Options.master_volume)
	bgm_slider.set_value_no_signal(Options.bgm_volume)
	sfx_slider.set_value_no_signal(Options.sfx_volume)
	
	if GameManager.get_game_state() == GameManager.GameState.PAUSED:
		main_menu_nutton.visible = true
	else:
		main_menu_nutton.visible = false

func _on_fullscreen_toggle_toggled(toggled_on: bool) -> void:
	Options.fullscreen_toggle(toggled_on)

func _on_back_pressed() -> void:
	Options.save_config()
	var game_state = GameManager.get_game_state()
	if game_state == GameManager.GameState.PAUSED:
		GameManager.set_game_state(GameManager.GameState.PLAYING)

	elif game_state == GameManager.GameState.OPTIONS:
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
