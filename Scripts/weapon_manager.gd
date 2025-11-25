extends Node2D

@export var weapons: Array

var bullet_scene = preload("res://Scenes/bullet.tscn")
var seeker_bullet_scene = preload("res://Scenes/seeker_bullet.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	weapons.append(bullet_scene)
	weapons.append(seeker_bullet_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func spawn_bullet():
	var bullet = bullet_scene.instantiate()
	bullet.position = Globals.player_pos
	add_child(bullet)

func spawn_seeker_bullet():
	var seeker_bullet = seeker_bullet_scene.instantiate()
	seeker_bullet.position = Globals.player_pos
	add_child(seeker_bullet)




func _on_bullet_timer_timeout() -> void:
	spawn_bullet()


func _on_seeker_bullet_timer_timeout() -> void:
	spawn_seeker_bullet()
