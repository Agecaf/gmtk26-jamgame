# This sub-script is for Player logic that involves:
# • Manipulating objects in the scene tree under the Player
class_name PlayerScene extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player


func _on_player_ready() -> void:
	pass


func _on_player_process(_delta: float) -> void:
	pass


func _on_player_physics_process(_delta: float) -> void:
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

	player.sprite.queue_free.call_deferred()
	player.collider.queue_free.call_deferred()
	
	player.remove_child(player.sprite)
	player.remove_child(player.collider)

	var new_sprite: Sprite2D
	var new_collider: CollisionShape2D
	
	match form:
		Player.Form.VAMPIRE:
			new_sprite = player.get_node(^'VampireSprite').duplicate()
			new_collider = player.get_node(^'VampireCollider').duplicate()
		Player.Form.BAT:
			new_sprite = player.get_node(^'BatSprite').duplicate()
			new_collider = player.get_node(^'BatCollider').duplicate()

	new_sprite.name = &'Sprite'
	new_collider.name = &'Collider'
	
	player.add_child(new_sprite)
	player.add_child(new_collider)

	player.move_child(new_sprite, 0)
	player.move_child(new_collider, 1)

	new_sprite.show()
	new_collider.show()
	
	player.face(player.current_facing)


func _on_player_save_spot() -> void:
	pass


func _on_player_hurt() -> void:
	pass
