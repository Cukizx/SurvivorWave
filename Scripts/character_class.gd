extends CharacterBody2D

class_name Character

@export var health: float =  5
@export var speed: float = 100.0
@export var contact_damage: float = 0
@export var inv_seconds: float = 5.0
@export var is_invincible: bool = false
@export var damage_numbers: bool = false

@onready var collision: CollisionShape2D = self.get_node("CollisionCheckArea/Collision")
@onready var collision_area: Area2D = collision.get_parent()
var hit_particles = null

var damage_num = preload("res://Scenes/damage_numbers.tscn")

func invincibility(seconds: float):
	collision.set_deferred("disabled", true)
	is_invincible = true
	await get_tree().create_timer(seconds).timeout
	collision.disabled = false
	is_invincible = false

func take_damage(damage):
	if self is Player:
		hit_particles = self.get_node("HitParticles")
	while collision_area.has_overlapping_bodies() or collision_area.has_overlapping_areas() and !is_invincible:
		health -= damage
		if hit_particles:
			hit_particles.emitting = true
		if damage_numbers:
			show_damage(damage)
		if health <= 0:
			if hit_particles:
				hit_particles.emitting = false
			return
		await invincibility(inv_seconds)
	if hit_particles:
		hit_particles.emitting = false

func show_damage(damage: float):
	var damage_number = damage_num.instantiate()
	damage_number.text = str(damage)
	damage_number.label_settings = LabelSettings.new()
	damage_number.label_settings.outline_size = 3
	damage_number.label_settings.outline_color = Color()
	damage_number.label_settings.font_size = clamp(10 + (damage / 2), 15, 30)
	damage_number.label_settings.font_color = Color(1, clamp(1 + ((10 - damage) / 100), 0, 1), clamp(1 + ((10 - damage) / 100), 0, 1), 1)
	add_child(damage_number)
	await get_tree().create_timer(2).timeout
	var label_array = find_children("*", "Label", false, false)
	label_array[0].queue_free()
	label_array.clear()
