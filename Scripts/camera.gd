extends Camera2D

const camera_offset = Vector2(30, 30)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	align()
	Globals.camera_center = get_screen_center_position()
	
func get_camera_rect() -> Rect2:
	var screen_center = self.get_target_position()
	var half_size = get_viewport_rect().size / 2
	Globals.camera_size = Rect2(screen_center - half_size, get_viewport_rect().size)
	return Globals.camera_size
