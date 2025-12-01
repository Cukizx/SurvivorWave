extends Control

@export var inventory_slots: Array[Node]
@export var player_inventory: Inventory

var slot_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_player_spawner_inventory_changed(inventory: Inventory) -> void:
	update_inventory()

func update_inventory():
	slot_index = 0
	for weapon in player_inventory.weapons:
		if slot_index > 4:
			break
		inventory_slots[slot_index].texture = weapon.sprite
		slot_index += 1
	slot_index = 5
	for item in player_inventory.items:
		inventory_slots[slot_index].texture = item.sprite
		slot_index += 1
