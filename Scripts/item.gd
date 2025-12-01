extends Resource

class_name Item

@export var name: String = ""
@export var sprite: Texture2D
@export_range(0, 6) var level: int = 1
@export var description: String = ""
