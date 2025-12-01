extends Resource

class_name Weapon

@export var name: String = ""
@export var sprite: Texture2D
@export_range(0, 7) var level: int = 1
@export var projectile: PackedScene
@export var description: String = ""
