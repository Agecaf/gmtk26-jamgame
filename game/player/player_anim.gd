# This sub-script is for Player logic that involves:
# • Controlling the various jump/glide/landing animation states
class_name PlayerAnim extends Resource


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
