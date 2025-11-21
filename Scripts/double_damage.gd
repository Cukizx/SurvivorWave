extends Pickup


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_entered(_player: Area2D) -> void:
	Globals.player_damage_multiplier *= 2
	await picked_up(5)
	Globals.player_damage_multiplier /= 2
	queue_free()
