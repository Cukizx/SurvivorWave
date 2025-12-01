extends Pickup


func _on_area_entered(_player: Area2D) -> void:
	Globals.player_damage_multiplier *= 2
	await picked_up(5)
	Globals.player_damage_multiplier /= 2
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	self.add_to_group("on_screen_pickups")


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.remove_from_group("on_screen_pickups")
