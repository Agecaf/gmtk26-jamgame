class_name SFX extends Object

const DOUBLE_JUMP = preload("res://assets/audio/sfx/bat_jump.wav")
const JUMP = preload("res://assets/audio/sfx/hop.wav")
const GLIDE_VAMPIRE = preload("res://assets/audio/sfx/cape_glide_short.wav")
const GLIDE_BAT = preload("res://assets/audio/sfx/cape_glide_short.wav")
const DOOR_OPEN = preload("res://assets/audio/sfx/clock_door_opens.wav")
const ENTER_COFFIN = preload("res://assets/audio/sfx/coffin.wav")
const DEATH_INTO_ASH = preload("res://assets/audio/sfx/nooo.wav")
const HURT = preload("res://assets/audio/sfx/hurt_and_bats.wav")
const LITTLE_BATS = preload("res://assets/audio/sfx/bat_wings_flap.wav")
const CROSSBOW_SHOT = preload("res://assets/audio/sfx/crossbow.wav")
const RUN = preload("res://assets/audio/sfx/footsteps_two.wav")
const LAND_VAMPIRE = preload("res://assets/audio/sfx/land.wav")
const LAND_BAT = preload("res://assets/audio/sfx/land.wav")
const EAT_FRUIT = preload("res://assets/audio/sfx/yummy.wav")
const EAT_FRUIT_BAT = preload("res://assets/audio/sfx/yummy.wav")

static var volume_dict: Dictionary = {
	LITTLE_BATS: 0.0,
	RUN: -12.0,
	JUMP: -6.0,
	LAND_BAT: -6.0,
	# LAND_VAMPIRE: -6.0,
	DOUBLE_JUMP: -3.0,
	CROSSBOW_SHOT: 3.0,
}

# Play an sfx
static func play(which_sfx) -> void:
	if which_sfx == null: return
	
	var asp: AudioStreamPlayer = Game.audio.get_sfx_asp()
	asp.volume_db = volume_dict.get(which_sfx, 0.0)
	asp.stream = which_sfx
	asp.play()
