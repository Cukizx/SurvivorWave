extends Area2D
class_name Pickup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func picked_up(duration: float = 0):
	self.visible = false
	var children = get_children()
	for child in children.size():
		children[child].queue_free()
	await get_tree().create_timer(duration, false).timeout
