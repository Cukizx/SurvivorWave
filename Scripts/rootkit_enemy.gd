extends Enemy

func _on_turn_visible_area_body_entered(_body: Player) -> void:
	if !self.dead:
		$CollisionShape2D.disabled = false
		$CollisionCheckArea/Collision.disabled = false
		is_invincible = false
		$AnimatedSprite2D.visible = true

func _on_turn_visible_area_body_exited(_body: Player) -> void:
	if !self.dead:
		$CollisionShape2D.disabled = true
		$CollisionCheckArea/Collision.disabled = true
		is_invincible = true
		$AnimatedSprite2D.visible = false
