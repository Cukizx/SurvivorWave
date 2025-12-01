extends Node

var config = ConfigFile.new()
const CONFIG_PATH = "user://config.cfg"

static var master_volume = 100
static var sfx_volume = 100
static var bgm_volume = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_config()

func fullscreen_toggle(toggled_on: bool):
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		config.set_value("Window mode","Mode", 3)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		config.set_value("Window mode","Mode", 0)

func set_volume(audio_bus: Sounds.AudioBus, volume: float):
	match audio_bus:
		Sounds.AudioBus.Master:
			master_volume = volume
			config.set_value("Sound Volume", "Master", volume)
		Sounds.AudioBus.SFX:
			sfx_volume = volume
			config.set_value("Sound Volume", "SFX", volume)
		Sounds.AudioBus.BGM:
			bgm_volume = volume
			config.set_value("Sound Volume", "BGM", volume)
	AudioServer.set_bus_volume_linear(audio_bus, volume / 100)

func save_config():
	config.save(CONFIG_PATH)

func load_config():
	var err = config.load(CONFIG_PATH)
	if err != OK:
		return
	fullscreen_toggle(config.get_value("Window mode", "Mode", 3))
	for audio_channel in config.get_section_keys("Sound Volume").size():
		set_volume(audio_channel, config.get_value("Sound Volume", config.get_section_keys("Sound Volume")[audio_channel], 100))
