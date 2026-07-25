# This sub-script is for Player logic that involves:
# • Manipulating objects in the scene tree under the Player
class_name PlayerScene extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player


func _on_player_ready() -> void:
	setup_hurtbox()


func _on_player_process(_delta: float) -> void:
	pass


func _on_player_physics_process(_delta: float) -> void:
	pass


func _on_player_slide_collision(_collision: KinematicCollision2D) -> void:
	pass


func _on_player_reset() -> void:
	player.face(Enums.Direction.RIGHT)


func _on_player_face(direction: Enums.Direction) -> void:
	match direction:
		Enums.Direction.RIGHT:
			player.sprite.scale = Vector2.ONE
			player.collider.scale = Vector2.ONE
			player.wall_detector.scale = Vector2.ONE
		
		Enums.Direction.LEFT:
			player.sprite.scale = Vector2(-1, 1)
			player.collider.scale = Vector2(-1, 1)
			player.wall_detector.scale = Vector2(-1, 1)


func _on_player_change_state(_state: Player.State) -> void:
	pass


func _on_player_change_form(form: Player.Form) -> void:
	player.sprite.hide()
	player.collider.hide()
	player.hurtbox.hide()

	player.sprite.queue_free.call_deferred()
	player.collider.queue_free.call_deferred()
	player.hurtbox.queue_free.call_deferred()
	
	player.remove_child(player.sprite)
	player.remove_child(player.collider)
	player.remove_child(player.hurtbox)

	var new_sprite: Sprite2D
	var new_collider: CollisionShape2D
	var new_hurtbox: Area2D
	
	match form:
		Player.Form.VAMPIRE:
			new_sprite = player.get_node(^'VampireSprite').duplicate()
			new_collider = player.get_node(^'VampireCollider').duplicate()
			new_hurtbox = player.get_node(^'VampireHurtbox').duplicate()
		Player.Form.BAT:
			new_sprite = player.get_node(^'BatSprite').duplicate()
			new_collider = player.get_node(^'BatCollider').duplicate()
			new_hurtbox = player.get_node(^'BatHurtbox').duplicate()

	new_sprite.name = &'Sprite'
	new_collider.name = &'Collider'
	new_hurtbox.name = &'Hurtbox'
	
	player.add_child(new_sprite)
	player.add_child(new_collider)
	player.add_child(new_hurtbox)

	player.move_child(new_sprite, 0)
	player.move_child(new_collider, 1)
	player.move_child(new_hurtbox, 2)

	new_sprite.show()
	new_collider.show()
	new_hurtbox.show()

	setup_hurtbox()
	
	player.face(player.current_facing)


func _on_player_save_spot() -> void:
	pass


func _on_player_hurt() -> void:
	pass


func setup_hurtbox() -> void:
	player.hurtbox.area_entered.connect(
		func(area: Area2D) -> void:
			if area is not HitboxComponent:
				return
					
			if player.current_state != Player.State.CROUCHING:
				player.hurt()
	)
