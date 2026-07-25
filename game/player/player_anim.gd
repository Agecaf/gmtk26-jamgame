# This sub-script is for Player logic that involves:
# • Managing the animation player
class_name PlayerAnim extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player


func _on_player_change_state(state: Player.State) -> void:
	player.animator.stop()
	
	match state:
		Player.State.IDLE:
			player.animator.play(&'Vampire/Idle_2')
		
		Player.State.RUNNING:
			player.animator.play(&'Vampire/Run')
		
		Player.State.CROUCHING:
			player.animator.play(&'Vampire/Crouch')
		
		Player.State.CROUCHING_RUN:
			player.animator.play(&'Vampire/CrouchRun')
		
		Player.State.HANGING:
			player.animator.play(&'Vampire/Hang')
		
		Player.State.JUMPING:
			if player.previous_state in [Player.State.RUNNING, Player.State.HANGING]:
				player.animator.play(&'Vampire/RapidJump')
			else:
				player.animator.play(&'Vampire/Jump')
		
		Player.State.GLIDING:
			player.animator.play(&'Vampire/Glide')
		
		Player.State.FALLING,\
		Player.State.JUMPING_FALL:
			player.animator.play(&'Vampire/Fall')
		
		Player.State.LANDING:
			player.animator.play(&'Vampire/Land')
		
		Player.State.TURNING_TO_MIST:
			player.animator.play(&'Vampire/TurnToMist')
		
		Player.State.REFORMING:
			player.animator.play(&'Vampire/Reform')

		Player.State.TURNING_TO_ASHES:
			player.animator.play(&'Vampire/TurnToAshes')

		# TODO: Will there be a coffin animation based on the player?
		Player.State.ENTERING_COFFIN:
			pass
