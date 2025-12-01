extends Sprite2D

class_name Experience

@export var experience_points: int = 1

var picked_up: bool = false
var speed = 300
var reached_position: bool = false
var original_position: Vector2
var pickup_position: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = global_position

func _process(delta: float) -> void:
	if picked_up and !reached_position:
		global_position = global_position.move_toward(Globals.player_pos, - (400 / position_smoothing()) * delta)
		if global_position.distance_to(original_position) > 50:
			reached_position = true
	elif picked_up and reached_position:
		global_position = global_position.move_toward(Globals.player_pos, speed * delta)
	
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_experience_pickup_check_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("get_experience") and !picked_up:
		pickup_position = Globals.player_pos
		picked_up = true


func _on_experience_pickup_check_body_entered(body: Node2D) -> void:
		body.get_experience(experience_points)
		queue_free()

func position_smoothing() -> float:
	var smoothing: float
	smoothing = clampf(global_position.distance_to(Globals.player_pos) * 0.02, 0.8, 1.5)
	return smoothing


func _on_floppy_disk_on_screen_notifier_screen_entered() -> void:
	self.add_to_group("on_screen_pickups")


func _on_floppy_disk_on_screen_notifier_screen_exited() -> void:
	self.remove_from_group("on_screen_pickups")
