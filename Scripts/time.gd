extends Label

var minutes: int = 0
var seconds: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str("%02d:%02d" % [minutes, seconds])

func _on_timer_timeout() -> void:
	seconds += 1
	if seconds == 60:
		minutes += 1
		seconds = 0
	text = str("%02d:%02d" % [minutes, seconds])
	$Timer.start()
