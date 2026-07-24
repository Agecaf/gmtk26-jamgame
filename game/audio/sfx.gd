class_name SFX extends Object

const DOUBLE_JUMP = preload("res://assets/audio/sfx/bat_transformation.wav")
const JUMP = preload("res://assets/audio/sfx/beep_placeholder.wav")
const GLIDE_VAMPIRE = preload("res://assets/audio/sfx/cape_glide_short.wav")
const GLIDE_BAT = preload("res://assets/audio/sfx/cape_glide_short.wav")
const DOOR_OPEN = preload("res://assets/audio/sfx/clock_door_opens.wav")
const ENTER_COFFIN = preload("res://assets/audio/sfx/vampire_enters_coffin.wav")
const DEATH_INTO_ASH = preload("res://assets/audio/sfx/ash_sizzle.wav")
const HURT = preload("res://assets/audio/sfx/crash_placeholder.wav")
const LITTLE_BATS = preload("res://assets/audio/sfx/bat_transformation.wav")
const CROSSBOW_SHOT = preload("res://assets/audio/sfx/beep_placeholder.wav")
const RUN = null
const LAND_VAMPIRE = preload("res://assets/audio/sfx/beep_placeholder.wav")
const LAND_BAT = preload("res://assets/audio/sfx/beep_placeholder.wav")

# Play an sfx
static func play(which_sfx) -> void:
	if which_sfx == null: return
	
	var asp: AudioStreamPlayer = Game.audio.get_sfx_asp()
	asp.stream = which_sfx
	asp.play()
