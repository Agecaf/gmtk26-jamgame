# This sub-script is for Player logic that involves:
# • Managing the animation player
class_name PlayerAnim extends Resource


# This accessor is set on Player._init(), treat as read-only
var player: Player


func _on_player_change_state(state: Player.State) -> void:
	player.animator.stop()
	
	match state:
		Player.State.IDLE:
			player.animator_vampire.play(&'Vampire/Idle_2')
		
		Player.State.RUNNING:
			player.animator_vampire.play(&'Vampire/Run')
		
		Player.State.CROUCHING:
			player.animator_vampire.play(&'Vampire/Crouch')
		
		Player.State.CROUCHING_RUN:
			player.animator_vampire.play(&'Vampire/CrouchRun')
		
		Player.State.HANGING:
			player.animator_vampire.play(&'Vampire/Hang')
		
		Player.State.JUMPING:
			if player.previous_state in [Player.State.RUNNING, Player.State.HANGING]:
				player.animator_vampire.play(&'Vampire/RapidJump')
			else:
				player.animator_vampire.play(&'Vampire/Jump')
		
		Player.State.JUMPING_BAT:
			player.animator_bat.play(&'BatForm/Flap')
		
		Player.State.GLIDING:
			player.animator_vampire.play(&'Vampire/Glide')
		
		Player.State.GLIDING_BAT:
			player.animator_bat.play(&'BatForm/Glide')
		
		Player.State.BOUNCE_START:
			player.animator_bat.play(&'BatForm/Bounce')
		
		Player.State.FALLING,\
		Player.State.JUMPING_FALL:
			player.animator_vampire.play(&'Vampire/Fall')
		
		Player.State.LANDING:
			player.animator_vampire.play(&'Vampire/Land')
		
		Player.State.LANDING_BAT:
			player.animator_bat.play(&'BatForm/Land')
		
		Player.State.TURNING_TO_MIST:
			player.animator_vampire.play(&'Vampire/TurnToMist')
		
		Player.State.REFORMING:
			player.animator_vampire.play(&'Vampire/Reform')

		Player.State.TURNING_TO_ASHES:
			player.animator_vampire.play(&'Vampire/TurnToAshes')

		Player.State.TURNING_TO_ASHES_BAT:
			player.animator_bat.play(&'BatForm/TurnToAshes')

		# TODO: Will there be a coffin animation based on the player?
		Player.State.ENTERING_COFFIN:
			pass
