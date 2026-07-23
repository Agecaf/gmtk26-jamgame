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
