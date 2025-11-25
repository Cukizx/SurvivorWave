extends Pickup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_area_entered(_player: Area2D) -> void:
	Globals.enemy_stop_duration = 5.0
	await picked_up()
	queue_free()
