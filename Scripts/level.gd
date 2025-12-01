extends Node2D

@export var player_characters: PlayerList

@onready var enemy_spawner = %"Enemy Spawner"
@onready var pickup_spawner = %PickupSpawner
@onready var weapon_manager = %"Weapon Manager"

signal inventory_changed(inventory: Inventory)
signal experience_gained(experience_amount: int, player: Player)
signal player_dead
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = player_characters.player_list[Globals.character_selected].instantiate()
	add_child(player)


func _on_player_dead() -> void:
	$"../AudioStreamPlayer".stream = load("res://Sounds/Music/LaMorteSopraggiungeInevitabileEPuntuale.ogg")
	$"../AudioStreamPlayer".play()
	get_tree().paused = true
	$"../CanvasLayer3".visible = true
