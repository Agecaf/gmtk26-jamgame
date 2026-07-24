class_name Player
extends CharacterBody2D


enum State {
	IDLE,
	HANGING,
	JUMPING,
	JUMPING_BAT,
	GLIDING,
	GLIDING_BAT,
	FALLING,
	FALLING_BAT,
}

@export_range(25, 500, 25) var speed: float = 250

@export_range(0.05, 1.0, 0.05) var jump_time: float = 0.2
@export_range(0.05, 1.0, 0.05) var double_jump_time: float = 0.2

@export_range(12, 192, 12) var jump_height: float = 72
@export_range(12, 192, 12) var double_jump_height: float = 72

@export_range(0.01, 0.2, 0.01) var double_jump_keypress_interval_min: float = 0.15
@export_range(0.21, 0.4, 0.01) var double_jump_keypress_interval_max: float = 0.3

@export_range(0.05, 0.5, 0.05) var glide_start_delay: float = 0.3
@export_range(0.05, 0.5, 0.05) var bat_glide_start_delay: float = 0.4

@export_range(12, 96, 12) var glide_max_fall_speed: float = 48
@export_range(12, 96, 12) var bat_glide_max_fall_speed: float = 12

@export_range(0.005, 0.01, 0.001) var glide_fall_speed_decay_rate: float = 0.008
@export_range(0.005, 0.01, 0.001) var bat_glide_fall_speed_decay_rate: float = 0.008

@export_range(0.05, 0.5, 0.05) var wall_jump_min_buildup_time: float = 0.25
@export_range(0.05, 0.5, 0.05) var wall_jump_cooldown: float = 0.1

var collider: CollisionShape2D:
	get: return $Collider

var x_min: float:
	get: return 0
var x_max: float:
	get: return get_viewport_rect().size.x

var y_min: float:
	get: return 0
var y_max: float:
	get: return get_viewport_rect().size.y

var player_state: PlayerState
var player_motion: PlayerMotion
var player_triggers: PlayerTriggers
var player_sound: PlayerSound

var script_order: Array[Resource]

var previous_state: State
var current_state: State


# For callbacks, auxiliary scripts are executed in the order defined here
func _init() -> void:
	player_state = PlayerState.new()
	player_motion = PlayerMotion.new()
	player_triggers = PlayerTriggers.new()
	player_sound = PlayerSound.new()

	script_order.append_array([
		player_state,
		player_motion,
		player_triggers,
		player_sound,
	])

	for script: Resource in script_order:
		script.player = self
	
	previous_state = State.IDLE
	current_state = State.IDLE


# Each auxiliary script can implement a different part of _ready()
func _ready() -> void:
	reset()

	Game.player = self

	for script: Resource in script_order:
		script._on_player_ready()


# Each auxiliary script can implement a different part of _process()
func _process(delta: float) -> void:
	for script: Resource in script_order:
		script._on_player_process(delta)


# Each auxiliary script can implement a different part of _physics_process()
func _physics_process(delta: float) -> void:
	for script: Resource in script_order:
		script._on_player_physics_process(delta)

	move_and_slide()
	
	position.x = clamp(position.x, x_min, x_max)
	position.y = clamp(position.y, y_min, y_max)


# Each auxiliary script can implement a different part of reset()
func reset() -> void:
	for script: Resource in script_order:
		script._on_player_reset()


# Each auxiliary script can implement a different part of change_state()
func change_state(state: State) -> void:
	previous_state = current_state
	current_state = state

	for script: Resource in script_order:
		script._on_player_change_state(state)
	

func _on_hurtbox_component_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		for script: Resource in script_order:
			script._on_player_hurt()
