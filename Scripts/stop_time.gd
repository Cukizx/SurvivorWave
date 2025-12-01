extends Pickup


func _on_area_entered(_player: Area2D) -> void:
	Globals.enemy_stop_duration = 5.0 * Globals.effect_duration_modifier
	await picked_up()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	self.add_to_group("on_screen_pickups")
	

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.remove_from_group("on_screen_pickups")
