extends ProgressBar

@onready var level_text = $Level

var level: int = 1
var max_level_experience: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_text.text = "Level: %d" % level
	new_max_level_experience()

func _on_player_experience_gained(experience_amount: int, player: Player) -> void:
	value = (experience_amount / max_level_experience) * 100
	if value == 100:
		player.experience = 0
		level_up()

func level_up():
	value = 0
	level += 1
	new_max_level_experience()
	level_text.text = "Level: %d" % level
	GameManager.set_game_state(GameManager.GameState.LEVELUP)

func new_max_level_experience():
	max_level_experience = 50 + exp(0.9 * level)
