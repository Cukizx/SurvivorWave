extends Resource

class_name PickupItem

@export var name: String = ""
@export var sprite: Texture2D
@export var pickup_scene: PackedScene
@export_range(0, 1, 0.05) var spawn_rate: float = 0
