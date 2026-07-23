class_name Player
extends CharacterBody2D


@export_range(25, 500, 25) var speed: float = 250
@export_range(0.05, 1.0, 0.05) var jump_time: float = 0.2
@export_range(12, 192, 12) var jump_height: float = 72

var jump_initial_velocity: float:
	get: return - 2.0 * jump_height / jump_time
var jump_gravity: float:
	get: return 2.0 * jump_height / jump_time / jump_time

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

var script_order: Array[Resource]


func _init() -> void:
	player_state = PlayerState.new()
	player_motion = PlayerMotion.new()
	player_triggers = PlayerTriggers.new()

	script_order.append_array([
		player_state,
		player_motion,
		player_triggers,
	])

	for script: Resource in script_order:
		script.player = self


func _ready() -> void:
	reset()

	Game.player = self

	for script: Resource in script_order:
		script._on_player_ready()


func _process(delta: float) -> void:
	for script: Resource in script_order:
		script._on_player_process(delta)


func _physics_process(delta: float) -> void:
	for script: Resource in script_order:
		script._on_player_physics_process(delta)

	move_and_slide()
	
	position.x = clamp(position.x, x_min, x_max)
	position.y = clamp(position.y, y_min, y_max)

		
func reset() -> void:
	for script: Resource in script_order:
		script._on_player_reset()
