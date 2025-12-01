#extends CharacterBody2D
extends Character
class_name Player

@export var inventory: Inventory
@export var starting_weapon: Weapon

@onready var sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var max_health: float = health
@onready var camera = $Camera2D


var direction: Vector2
var move_vector := Vector2.ZERO
var no_hit_time: float = 0.0
var is_dead = false
var experience: int = 0
var last_dir: Vector2
var has_headphones: bool = false
var shield_number: int = 0
var base_speed
var max_base_health: float


var enemy_spawner
var pickup_spawner
var weapon_manager

#signal experience_gained(experience_amount: int, player: Player)
#signal inventory_changed(inventory: Inventory)

func _ready() -> void:
	max_base_health = health
	base_speed = speed
	Globals.player = self
	has_headphones = false
	shield_number = 0
	add_weapon(starting_weapon)
	enemy_spawner = get_parent().enemy_spawner
	pickup_spawner = get_parent().pickup_spawner
	weapon_manager = get_parent().weapon_manager

func move(direction: Vector2):
	velocity = direction * speed
	Globals.player_pos = global_position
	Globals.player_dir = direction.normalized()

func _physics_process(delta: float) -> void:
	max_health = max_base_health * Globals.player_health_modifier
	speed = base_speed * Globals.player_speed_modifier
	camera.position = Vector2.ZERO
	#enemy_spawner.global_position = Vector2.ZERO
	camera.position_smoothing_enabled = true
	if !is_dead:
		if Globals.is_mobile:
			move_vector = Vector2.ZERO
			move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
			move(move_vector)
		else:
			var direction_x := Input.get_axis("left", "right")
			var direction_y := Input.get_axis("up", "down")
			direction = Vector2(direction_x, direction_y).normalized()
			if direction != Vector2.ZERO:
				last_dir = direction 
			if direction == Vector2.ZERO and sprite.animation == "walking_left":
				sprite.play("idle_left")
			elif direction == Vector2.ZERO and sprite.animation == "walking_right":
				sprite.play("idle_right")
			elif direction.x > 0 or direction.y != 0 and sprite.animation == "idle_right":
				sprite.play("walking_right")
			elif direction.x <0 or direction.y != 0 and sprite.animation == "idle_left":
				sprite.play("walking_left")
			move(direction)
		move_and_slide()
	
	#Lots of magic numbers for the looping of the world, probably could be better but have no time
	if global_position.y > 1567:
		camera.position_smoothing_enabled = false
		camera.position = Globals.camera_center - global_position
		global_position.y = -1505
		enemy_spawner.global_position.y += -1505 - 1567
		pickup_spawner.global_position.y += -1505 - 1567
		weapon_manager.global_position.y += -1505 - 1567 
	if global_position.y < -1505:
		camera.position_smoothing_enabled = false
		camera.position = Globals.camera_center - global_position
		global_position.y = 1567
		enemy_spawner.global_position.y -= -1505 - 1567
		pickup_spawner.global_position.y -= -1505 - 1567
		weapon_manager.global_position.y -= -1505 - 1567
	if global_position.x > 2721:
		camera.position_smoothing_enabled = false
		camera.position = Globals.camera_center - global_position
		global_position.x = -2591
		enemy_spawner.global_position.x += -2591 - 2721
		pickup_spawner.global_position.x += -2591 -2721
		weapon_manager.global_position.x += -2591 -2721
	if global_position.x < -2591:
		camera.position_smoothing_enabled = false
		camera.position = Globals.camera_center - global_position
		global_position.x = 2721
		enemy_spawner.global_position.x -= -2591 - 2721
		pickup_spawner.global_position.x += -2591 -2721
		weapon_manager.global_position.x += -2591 -2721
		
		
	health_bar.value = (health / max_health) * 100
	no_hit_time += delta
	Globals.no_hit_time = no_hit_time + delta

func _on_collision_check_area_body_entered(body: Node2D) -> void:
	if !Globals.enemy_stop and !body.is_stopped:
		if !is_invincible and !is_dead:
			if shield_number <= 0:
				take_damage(body.contact_damage / Globals.player_armor)
				no_hit_time = 0.0
				Globals.no_hit_time = no_hit_time
			else:
				shield_number -= 1
				print("shield subtracted")
	if health <= 0:
		death()

func get_experience(experience_points: int):
	experience += experience_points * Globals.player_experience_modifier
	get_parent().experience_gained.emit(experience, self)

func death():
	is_dead = true
	get_parent().player_dead.emit()
	$AnimatedSprite2D.play("death")
	#await  $AnimatedSprite2D.animation_finished
	#var death_sound = AudioStreamPlayer.new()
	#death_sound.stream = load("res://Sounds/Music/LaMorteSopraggiungeInevitabileEPuntuale.ogg")
	#add_child(death_sound)
	#death_sound.play()

func add_weapon(weapon):
	if weapon is Weapon:
		inventory.weapons.append(weapon)
	if weapon is Item:
		inventory.items.append(weapon)
	update_inventory()
	
func update_inventory():
	get_parent().inventory_changed.emit(inventory)
	
func healed():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "self_modulate", Color(0.0, 0.839, 0.0, 1.0), 0.2)
	tween.tween_property(self, "self_modulate", Color(1.0, 1.0, 1.0, 1.0), 0.2)
