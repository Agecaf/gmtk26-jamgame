# This sub-script is for Player logic that involves:
# • Top-level modifications on the player object
# • Manipulating objects in the scene tree under the Player
class_name PlayerScene extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player

var last_marked_position: Vector2


func _on_player_ready() -> void:
	last_marked_position = player.position
	
	player.hurtbox_vampire.area_entered.connect(_on_player_hurtbox_area_entered)
	player.hurtbox_bat.area_entered.connect(_on_player_hurtbox_area_entered)


func _on_player_slide_collision(collision: KinematicCollision2D) -> void:
	if collision.get_collider() is Spikes:
		player.hurt()


func _on_player_reset() -> void:
	player.face(Enums.Direction.RIGHT)


func _on_player_face(direction: Enums.Direction) -> void:
	match direction:
		Enums.Direction.RIGHT:
			player.sprite_vampire.scale = Vector2.ONE
			player.sprite_bat.scale = Vector2.ONE

			player.hurtbox_collider_vampire.scale = Vector2.ONE
			player.hurtbox_collider_bat.scale = Vector2.ONE

			player.wall_detector_top.scale = Vector2.ONE
			player.wall_detector_bottom.scale = Vector2.ONE

			player.terrain_collider.scale = Vector2.ONE
		
		Enums.Direction.LEFT:
			player.sprite_vampire.scale = Vector2(-1, 1)
			player.sprite_bat.scale = Vector2(-1, 1)

			player.hurtbox_collider_vampire.scale = Vector2(-1, 1)
			player.hurtbox_collider_bat.scale = Vector2(-1, 1)

			player.wall_detector_top.scale = Vector2(-1, 1)
			player.wall_detector_bottom.scale = Vector2(-1, 1)

			player.terrain_collider.scale = Vector2(-1, 1)


func _on_player_change_state(state: Player.State) -> void:
	match state:
		Player.State.TURNING_TO_MIST:
			var tween: Tween = player.get_tree().create_tween().set_ease(Tween.EASE_OUT_IN)
			tween.finished.connect(player.complete_reform)
			tween.tween_property(player, ^'position', last_marked_position, player.mist_travel_duration)


func _on_player_change_form(form: Player.Form) -> void:
	match player.previous_form:
		Player.Form.VAMPIRE:
			player.sprite_vampire.hide()
			player.hurtbox_collider_vampire.disabled = true
		
		Player.Form.BAT:
			player.sprite_bat.hide()
			player.hurtbox_collider_bat.disabled = true
	
	match form:
		Player.Form.VAMPIRE:
			player.sprite_vampire.show()
			player.hurtbox_collider_vampire.disabled = false
		
		Player.Form.BAT:
			player.sprite_bat.show()
			player.hurtbox_collider_bat.disabled = false


func _on_player_save_spot() -> void:
	last_marked_position = player.position
	MarkerBat.mark(player.position)


func _on_player_hurtbox_area_entered(area: Area2D) -> void:
	if area is not HitboxComponent:
		return
			
	if player.current_state != Player.State.CROUCHING:
		player.hurt()
