class_name CrossbowBolt extends StaticBody2D


var velocity: Vector2 = Vector2.ZERO


func face(direction: Enums.Direction) -> void:
	if direction == Enums.Direction.LEFT:
		$Sprite.scale = Vector2.ONE
		$Collider.scale = Vector2.ONE
	elif direction == Enums.Direction.RIGHT:
		$Sprite.scale = Vector2(-1, 1)
		$Collider.scale = Vector2(-1, 1)


func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		if collision.get_collider() is Player:
			# TODO: Signal the bolt colliding with the player
			pass
		
		queue_free()
