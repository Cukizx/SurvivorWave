extends StaticBody2D

@export var pickups: PickupList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	var cumulative_spawn_rate: float = 0
	for pickup in pickups.pickup_list:
		if randf() <= pickup.spawn_rate + cumulative_spawn_rate:
			var spawned_pickup = pickup.pickup_scene.instantiate()
			spawned_pickup.global_position = global_position
			add_sibling(spawned_pickup)
			break
		cumulative_spawn_rate += pickup.spawn_rate
	queue_free()


func _on_floppy_disk_on_screen_notifier_screen_entered() -> void:
	self.add_to_group("on_screen_pickups")


func _on_floppy_disk_on_screen_notifier_screen_exited() -> void:
	self.remove_from_group("on_screen_pickups")
