extends ProgressBar

var level: int = 1
var max_level_experience = 50 + exp(0.4 * level)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_player_experience_gained(experience_amount: Variant) -> void:
	value = (experience_amount / max_level_experience) * 100
