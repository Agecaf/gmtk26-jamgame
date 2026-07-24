# This sub-script is for Player logic that involves:
# • Playing sounds
class_name PlayerSound extends Resource


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


## As yet unused clips from SFX:
# const DOOR_OPEN = preload("res://assets/audio/sfx/clock_door_opens.wav")
# const ENTER_COFFIN = preload("res://assets/audio/sfx/vampire_enters_coffin.wav")
# const DEATH_INTO_ASH = preload("res://assets/audio/sfx/ash_sizzle.wav")
# const LITTLE_BATS = preload("res://assets/audio/sfx/bat_transformation.wav")
# const CROSSBOW_SHOT = preload("res://assets/audio/sfx/beep_placeholder.wav")
# const RUN = null

func _on_player_change_state(state: Player.State) -> void:
	var previously_bat: bool = player.previous_state in [
		Player.State.JUMPING_BAT,
		Player.State.GLIDING_BAT,
		Player.State.FALLING_BAT,
	]

	match state:
		Player.State.IDLE:
			SFX.play(SFX.LAND_BAT if previously_bat else SFX.LAND_VAMPIRE)
		
		Player.State.JUMPING:
			SFX.play(SFX.JUMP)
		
		Player.State.JUMPING_BAT:
			SFX.play(SFX.DOUBLE_JUMP)
		
		Player.State.GLIDING:
			SFX.play(SFX.GLIDE_VAMPIRE)
		
		Player.State.GLIDING_BAT:
			SFX.play(SFX.GLIDE_BAT)


func _on_player_change_form(_form: Player.Form) -> void:
	pass


func _on_player_save_spot() -> void:
	pass


func _on_player_hurt() -> void:
	SFX.play(SFX.HURT)
