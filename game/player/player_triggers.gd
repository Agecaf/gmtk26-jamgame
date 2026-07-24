# This sub-script is for Player logic that involves:
# • The response to being hurt by traps
# • The response to the countdown reaching zero
# • The response to completing levels and/or the game
class_name PlayerTriggers extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player


func _on_player_ready() -> void:
	pass


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


func _on_player_hurt() -> void:
	print("Player got hit!")
