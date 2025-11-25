extends Sprite2D

@export var experience_points: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_experience_pickup_check_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("get_experience"):
		area.get_parent().get_experience(experience_points)
		queue_free()
