# This sub-script is for Player logic that involves:
# • Playing sounds
class_name PlayerSound extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player


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
			if previously_bat:
				SFX.play(SFX.LAND_BAT)
			elif player.previous_state != Player.State.RUNNING:
				SFX.play(SFX.LAND_VAMPIRE)
		
		Player.State.JUMPING:
			SFX.play(SFX.JUMP)
		
		Player.State.RUNNING:
			run_timer = 0.1
		
		Player.State.JUMPING_BAT:
			SFX.play(SFX.DOUBLE_JUMP)
		
		Player.State.GLIDING:
			SFX.play(SFX.GLIDE_VAMPIRE)
		
		Player.State.GLIDING_BAT:
			SFX.play(SFX.GLIDE_BAT)
		
		Player.State.TURNING_TO_MIST:
			SFX.play(SFX.HURT)
		
		Player.State.TURNING_TO_ASHES:
			SFX.play(SFX.DEATH_INTO_ASH)


# Running
var run_timer: float = 0.0
var run_timer_max: float = 0.3 
func _on_player_process(delta: float):
	if player.current_state == Player.State.RUNNING:
		run_timer -= delta
		if run_timer < 0:
			run_timer = run_timer_max
			SFX.play(SFX.RUN)

# Save spot
func _on_player_save_spot() -> void:
	SFX.play(SFX.DOUBLE_JUMP)


func _on_player_turn_to_bats() -> void:
	SFX.play(SFX.LITTLE_BATS)
