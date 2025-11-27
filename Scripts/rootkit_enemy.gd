extends Enemy

func _on_turn_visible_area_body_entered(_body: Player) -> void:
	if !self.dead:
		$CollisionShape2D.disabled = false
		$CollisionCheckArea/Collision.disabled = false
		$TurnVisibleArea/TurnVisibleCollision.shape.radius = 200
		is_invincible = false
		$AnimatedSprite2D.play("walk")

func _on_turn_visible_area_body_exited(_body: Player) -> void:
	if !self.dead:
		$CollisionShape2D.disabled = true
		$CollisionCheckArea/Collision.disabled = true
		$TurnVisibleArea/TurnVisibleCollision.shape.radius = 150
		is_invincible = true
		$AnimatedSprite2D.play("invisible_shimmer")
