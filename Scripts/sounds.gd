extends Node


enum AudioBus {
	Master,
	BGM,
	SFX
}

func _ready() -> void:
	#load_ost()
	#load_button_sound()
	pass


#func load_ost():
	#var ost_player := AudioStreamPlayer.new()
	#ost_player.stream = load("res://Sounds/Music/SeQuestoEUnPixel.ogg")
	#ost_player.bus = "BGM"
	#ost_player.autoplay = true
	#ost_player.process_mode = Node.PROCESS_MODE_ALWAYS
	#add_child(ost_player)

#func load_button_sound():
	#var button_sound := AudioStreamPlayer.new()
	#button_sound.stream = load("res://Sounds/Buttons.ogg")
	#button_sound.bus = "SFX"
	#button_sound.max_polyphony = 1
	#button_sound.process_mode = Node.PROCESS_MODE_ALWAYS
	#add_child(button_sound)
