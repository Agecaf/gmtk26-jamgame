class_name Player
extends CharacterBody2D


enum State {
	IDLE,
	RUNNING,
	CROUCHING,
	CROUCHING_RUN,
	HANGING,
	JUMPING,
	JUMPING_FALL,
	JUMPING_BAT,
	GLIDING,
	GLIDING_BAT,
	FALLING,
	FALLING_BAT,
	LANDING,
	LANDING_BAT,
	TURNING_TO_MIST,
	TURNING_TO_ASHES,
	ENTERING_COFFIN,
}

enum Form {
	VAMPIRE,
	BAT,
}

@export_range(25, 500, 25) var run_speed: float = 250
@export_range(0.05, 0.5, 0.05) var coyote_time: float = 0.1
@export_range(288, 576, 24) var max_fall_speed: float = 384

@export_range(0.05, 1.0, 0.05) var jump_time: float = 0.3
@export_range(0.05, 1.0, 0.05) var double_jump_time: float = 0.3

@export_range(12, 192, 12) var jump_height: float = 72
@export_range(12, 192, 12) var double_jump_height: float = 72

@export_range(0.01, 0.2, 0.01) var double_jump_keypress_interval_min: float = 0.15
# @export_range(0.21, 0.4, 0.01) var double_jump_keypress_interval_max: float = 0.4

@export_range(0.05, 0.5, 0.05) var falling_delay: float = 0.3
@export_range(0.05, 0.5, 0.05) var landing_delay: float = 0.2
@export_range(0.05, 0.5, 0.05) var bat_landing_delay: float = 0.2

@export_range(0.05, 0.5, 0.05) var glide_start_delay: float = 0.4
@export_range(0.05, 0.5, 0.05) var bat_glide_start_delay: float = 0.4

@export_range(12, 96, 12) var glide_max_fall_speed: float = 48
@export_range(12, 96, 12) var bat_glide_max_fall_speed: float = 12
@export_range(0, 24, 2) var bat_bounce_min_speed_required: float = 2

@export_range(0.005, 0.01, 0.001) var glide_fall_speed_decay_rate: float = 0.008
@export_range(0.005, 0.01, 0.001) var bat_glide_fall_speed_decay_rate: float = 0.008

@export_range(0.005, 0.05, 0.005) var run_speed_change_rate: float = 0.02
@export_range(0.002, 0.02, 0.002) var air_speed_change_rate: float = 0.012
@export_range(0.002, 0.02, 0.002) var bat_air_speed_change_rate: float = 0.008
@export_range(0.001, 0.01, 0.001) var glide_air_speed_change_rate: float = 0.004
@export_range(0.001, 0.01, 0.001) var bat_glide_air_speed_change_rate: float = 0.004

@export_range(0.05, 0.5, 0.05) var wall_jump_min_buildup_time: float = 0.25
@export_range(0.05, 0.5, 0.05) var wall_jump_cooldown: float = 0.1
@export_range(0.05, 0.5, 0.05) var bat_bounce_cooldown: float = 1

@export_range(0, 0.95, 0.05) var short_jump_velocity_attenuation: float = 0.3

var sprite: Sprite2D:
	get: return $Sprite
var collider: CollisionShape2D:
	get: return $Collider
var hurtbox: Area2D:
	get: return $Hurtbox
var wall_detector: RayCast2D:
	get: return $WallDetector

var x_min: float:
	get: return 0
var x_max: float:
	get: return get_viewport_rect().size.x

var y_min: float:
	get: return 0
var y_max: float:
	get: return get_viewport_rect().size.y

var player_scene: PlayerScene
var player_state: PlayerState
var player_motion: PlayerMotion
var player_anim: PlayerAnim
var player_sound: PlayerSound

var script_order: Array[Resource]

var previous_state: State
var current_state: State
var current_form: Form
var current_facing: Enums.Direction


# For callbacks, auxiliary scripts are executed in the order defined here
func _init() -> void:
	player_scene = PlayerScene.new()
	player_state = PlayerState.new()
	player_motion = PlayerMotion.new()
	player_anim = PlayerAnim.new()
	player_sound = PlayerSound.new()

	script_order.append_array([
		player_scene,
		player_state,
		player_motion,
		player_anim,
		player_sound,
	])

	for script: Resource in script_order:
		script.player = self
	
	previous_state = State.IDLE
	current_state = State.IDLE
	current_form = Form.VAMPIRE
	current_facing = Enums.Direction.RIGHT


# Each auxiliary script can implement a different part of _ready()
func _ready() -> void:
	reset()

	Game.player = self

	for script: Resource in script_order:
		if '_on_player_ready' in script:
			script._on_player_ready()


# Each auxiliary script can implement a different part of _process()
func _process(delta: float) -> void:
	for script: Resource in script_order:
		if '_on_player_process' in script:
			script._on_player_process(delta)


# Each auxiliary script can implement a different part of _physics_process()
func _physics_process(delta: float) -> void:
	for script: Resource in script_order:
		if '_on_player_physics_process' in script:
			script._on_player_physics_process(delta)

	move_and_slide()

	for i: int in get_slide_collision_count():
		_slide_collision(get_slide_collision(i))
	
	position.x = clamp(position.x, x_min, x_max)
	position.y = clamp(position.y, y_min, y_max)


# Each auxiliary script can implement a different part of _slide_collision()
func _slide_collision(collision: KinematicCollision2D) -> void:
	for script: Resource in script_order:
		if '_on_player_slide_collision' in script:
			script._on_player_slide_collision(collision)


# Each auxiliary script can implement a different part of reset()
func reset() -> void:
	for script: Resource in script_order:
		if '_on_player_reset' in script:
			script._on_player_reset()


# Each auxiliary script can implement a different part of face()
func face(direction: Enums.Direction) -> void:
	if direction == Enums.Direction.NONE:
		return
	
	current_facing = direction

	for script: Resource in script_order:
		if '_on_player_face' in script:
			script._on_player_face(direction)


# Each auxiliary script can implement a different part of change_state()
func change_state(state: State) -> void:
	if current_state == state:
		return
	
	previous_state = current_state
	current_state = state

	for script: Resource in script_order:
		if '_on_player_change_state' in script:
			script._on_player_change_state(state)


# Each auxiliary script can implement a different part of change_form()
func change_form(form: Form) -> void:
	if current_form == form:
		return
	
	current_form = form

	for script: Resource in script_order:
		if '_on_player_change_form' in script:
			script._on_player_change_form(form)


# Each auxiliary script can implement a different part of save_spot()
func save_spot() -> void:
	for script: Resource in script_order:
		if '_on_player_save_spot' in script:
			script._on_player_save_spot()


# Each auxiliary script can implement a different part of hurt()
func hurt() -> void:
	for script: Resource in script_order:
		if '_on_player_hurt' in script:
			script._on_player_hurt()


func enter_coffin() -> void:
	for script: Resource in script_order:
		if '_on_player_enter_coffin' in script:
			script._on_player_enter_coffin()


func turn_to_ashes() -> void:
	for script: Resource in script_order:
		if '_on_player_turn_to_ashes' in script:
			script._on_player_turn_to_ashes()


# For opening and closing the pocketwatch
func pocketwatch_open() -> void: if Game.pocketwatch != null: Game.pocketwatch.open()
func pocketwatch_close() -> void: if Game.pocketwatch != null: Game.pocketwatch.close()
