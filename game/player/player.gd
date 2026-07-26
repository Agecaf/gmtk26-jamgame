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
	BOUNCE_START,
	BOUNCE_END,
	FALLING,
	FALLING_BAT,
	LANDING,
	LANDING_BAT,
	TURNING_TO_MIST,
	TURNING_TO_MIST_BAT,
	TURNING_TO_MIST_POST_BAT,
	REFORMING,
	TURNING_TO_ASHES,
	TURNING_TO_ASHES_BAT,
	ENTERING_COFFIN,
}

enum Form {
	VAMPIRE,
	BAT,
}

signal coffin_sequence_start()
signal coffin_sequence_complete()

@export_range(25, 500, 25) var run_speed: float = 250
@export_range(25, 500, 25) var crouch_run_speed: float = 75
@export_range(25, 500, 25) var air_speed: float = 300
@export_range(25, 500, 25) var glide_speed: float = 350
@export_range(25, 500, 25) var bat_glide_speed: float = 400

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
@export_range(0.05, 0.5, 0.05) var bat_bounce_delay: float = 0.2

@export_range(0.05, 0.5, 0.05) var glide_start_delay: float = 0.4
@export_range(0.05, 0.5, 0.05) var bat_glide_start_delay: float = 0.4

@export_range(12, 96, 12) var glide_max_fall_speed: float = 48
@export_range(12, 96, 12) var bat_glide_max_fall_speed: float = 12
# @export_range(0, 24, 2) var bat_bounce_min_speed_required: float = 2

@export_range(0.005, 0.01, 0.001) var glide_fall_speed_decay_rate: float = 0.007
@export_range(0.005, 0.01, 0.001) var bat_glide_fall_speed_decay_rate: float = 0.008

@export_range(0.005, 0.05, 0.005) var run_speed_change_rate: float = 0.02
@export_range(0.005, 0.05, 0.005) var crouch_run_speed_change_rate: float = 0.04
@export_range(0.002, 0.02, 0.002) var air_speed_change_rate: float = 0.012
@export_range(0.002, 0.02, 0.002) var bat_air_speed_change_rate: float = 0.008
@export_range(0.001, 0.01, 0.001) var glide_air_speed_change_rate: float = 0.004
@export_range(0.001, 0.01, 0.001) var bat_glide_air_speed_change_rate: float = 0.006

@export_range(0.05, 0.5, 0.05) var wall_jump_min_buildup_time: float = 0.05
@export_range(0.05, 0.5, 0.05) var wall_jump_cooldown: float = 0.1
@export_range(0.05, 0.5, 0.05) var bat_bounce_cooldown: float = 1

@export_range(0, 0.95, 0.05) var short_jump_velocity_attenuation: float = 0.3

@export var mist_travel_duration: float = 2.0

var sprite_vampire: Sprite2D:
	get: return $VampireSprite
var hurtbox_vampire: Area2D:
	get: return $VampireHurtbox
var hurtbox_collider_vampire: CollisionShape2D:
	get: return $VampireHurtbox/Collider
var animator_vampire: AnimationPlayer:
	get: return $VampireAnimator

var sprite_bat: Sprite2D:
	get: return $BatSprite
var hurtbox_bat: Area2D:
	get: return $BatHurtbox
var hurtbox_collider_bat: CollisionShape2D:
	get: return $BatHurtbox/Collider
var animator_bat: AnimationPlayer:
	get: return $BatAnimator

var sprite_coffin: Sprite2D:
	get: return $CoffinSprite
var animator_coffin: AnimationPlayer:
	get: return $CoffinAnimator

var sprite: Sprite2D:
	get: return sprite_vampire if current_form == Form.VAMPIRE else sprite_bat
var hurtbox: Area2D:
	get: return hurtbox_vampire if current_form == Form.VAMPIRE else hurtbox_bat
var hurtbox_collider: CollisionShape2D:
	get: return hurtbox_collider_vampire if current_form == Form.VAMPIRE else hurtbox_collider_bat
var animator: AnimationPlayer:
	get: return animator_vampire if current_form == Form.VAMPIRE else animator_bat

var terrain_collider: CollisionShape2D:
	get: return $TerrainCollider
var wall_detector_top: RayCast2D:
	get: return $WallDetectorTop
var wall_detector_bottom: RayCast2D:
	get: return $WallDetectorBottom

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
var previous_form: Form

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
	previous_form = Form.VAMPIRE

	current_state = State.IDLE
	current_form = Form.VAMPIRE
	current_facing = Enums.Direction.RIGHT


# Each auxiliary script can implement part of _ready()
func _ready() -> void:
	reset()
	
	Game.player = self
	
	for script: Resource in script_order:
		if '_on_player_ready' in script:
			script._on_player_ready()
	
	# Listen to end of game
	Game.countdown.timeout.connect(turn_to_ashes)


# Each auxiliary script can implement part of _process() ... and so on
func _process(delta: float) -> void:
	for script: Resource in script_order:
		if '_on_player_process' in script:
			script._on_player_process(delta)


func _physics_process(delta: float) -> void:
	for script: Resource in script_order:
		if '_on_player_physics_process' in script:
			script._on_player_physics_process(delta)

	move_and_slide()

	for i: int in get_slide_collision_count():
		_slide_collision(get_slide_collision(i))
	
	# No need to clamp position
	# position.x = clamp(position.x, x_min, x_max)
	# position.y = clamp(position.y, y_min, y_max)


func _slide_collision(collision: KinematicCollision2D) -> void:
	for script: Resource in script_order:
		if '_on_player_slide_collision' in script:
			script._on_player_slide_collision(collision)


func reset() -> void:
	for script: Resource in script_order:
		if '_on_player_reset' in script:
			script._on_player_reset()


func face(direction: Enums.Direction) -> void:
	if direction == Enums.Direction.NONE:
		return
	
	current_facing = direction

	for script: Resource in script_order:
		if '_on_player_face' in script:
			script._on_player_face(direction)


func change_state(state: State) -> void:
	if current_state == state:
		return
	
	previous_state = current_state
	current_state = state

	for script: Resource in script_order:
		if '_on_player_change_state' in script:
			script._on_player_change_state(state)


func change_form(form: Form) -> void:
	if current_form == form:
		return
	
	previous_form = current_form
	current_form = form

	for script: Resource in script_order:
		if '_on_player_change_form' in script:
			script._on_player_change_form.call_deferred(form)


func save_spot() -> void:
	for script: Resource in script_order:
		if '_on_player_save_spot' in script:
			script._on_player_save_spot()


func hurt() -> void:
	if current_form == Form.VAMPIRE:
		change_state(State.TURNING_TO_MIST)
	else:
		change_state(State.TURNING_TO_MIST_BAT)


func turn_to_ashes() -> void:
	if current_form == Form.VAMPIRE:
		change_state(State.TURNING_TO_ASHES)
	else:
		change_state(State.TURNING_TO_ASHES_BAT)


func enter_coffin() -> void:
	change_state(State.ENTERING_COFFIN)


func complete_reform() -> void:
	change_state(State.IDLE)


# For opening and closing the pocketwatch
func pocketwatch_open() -> void: if Game.pocketwatch != null: Game.pocketwatch.open()
func pocketwatch_close() -> void: if Game.pocketwatch != null: Game.pocketwatch.close()
