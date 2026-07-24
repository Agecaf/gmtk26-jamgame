class_name CrossbowBolt extends StaticBody2D

@export var damage : int = 1

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
		var hit_object = collision.get_collider()
		
		if hit_object is Player or hit_object.has_method("get_hit_data"): 
			# The area signal will fire this frame; we queue_free AFTER the frame
			call_deferred("queue_free")
		queue_free()
