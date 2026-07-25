# This sub-script is for Player logic that involves:
# • Managing the animation player
class_name PlayerAnim extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player

var animator: AnimationPlayer:
	get: return player.get_node(^'Animator')


func _on_player_change_state(state: Player.State) -> void:
	# animator.stop()
	# TODO: Replace the block below with the statement above once bat animations are in
	if player.current_form == Player.Form.VAMPIRE:
		animator.set_process(true)
		animator.stop()
	else:
		animator.set_process(false)
	
	match state:
		Player.State.IDLE:
			animator.play(&'Vampire/Idle_2')
		
		Player.State.RUNNING:
			animator.play(&'Vampire/Run')
		
		Player.State.CROUCHING:
			animator.play(&'Vampire/Crouch')
		
		Player.State.CROUCHING_RUN:
			animator.play(&'Vampire/CrouchRun')
		
		Player.State.HANGING:
			animator.play(&'Vampire/Hang')
		
		Player.State.JUMPING:
			if player.previous_state in [Player.State.RUNNING, Player.State.HANGING]:
				animator.play(&'Vampire/RapidJump')
			else:
				animator.play(&'Vampire/Jump')
		
		Player.State.GLIDING:
			animator.play(&'Vampire/Glide')
		
		Player.State.FALLING,\
		Player.State.JUMPING_FALL:
			animator.play(&'Vampire/Fall')
		
		Player.State.LANDING:
			animator.play(&'Vampire/Land')
		
		# TODO: Play turn-to-ashes animation
		Player.State.TURNING_TO_MIST:
			pass

		# TODO: Play turn-to-ashes animation
		Player.State.TURNING_TO_ASHES:
			pass

		# TODO: Will there be a coffin animation based on the player?
		Player.State.ENTERING_COFFIN:
			pass
