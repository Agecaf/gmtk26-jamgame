# This sub-script is for Player logic that involves:
# • The response to being hurt by traps
# • The response to the countdown reaching zero
# • The response to completing levels and/or the game
class_name PlayerTriggers extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player

var last_marked_position: Vector2


func _on_player_ready() -> void:
	last_marked_position = player.position


func _on_player_process(_delta: float) -> void:
	pass


func _on_player_physics_process(_delta: float) -> void:
	pass


func _on_player_reset() -> void:
	pass


func _on_player_face(_direction: Enums.Direction) -> void:
	pass


func _on_player_change_state(_state: Player.State) -> void:
	pass


func _on_player_change_form(_form: Player.Form) -> void:
	pass


func _on_player_save_spot() -> void:
	last_marked_position = player.position
	Debug.warning('Safe spot marked.')


func _on_player_hurt() -> void:
	player.position = last_marked_position
	Debug.warning('The player got hit!')
