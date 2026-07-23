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

var player_anim: PlayerAnim
var player_hurt: PlayerHurt
var player_traversal: PlayerTraversal
var player_winloss: PlayerWinLoss


func _init() -> void:
	player_anim = PlayerAnim.new()
	player_anim.player = self
	
	player_hurt = PlayerHurt.new()
	player_hurt.player = self

	player_traversal = PlayerTraversal.new()
	player_traversal.player = self

	player_winloss = PlayerWinLoss.new()
	player_winloss.player = self


func _ready() -> void:
	reset()

	Game.player = self

	player_anim._on_player_ready()
	player_hurt._on_player_ready()
	player_traversal._on_player_ready()
	player_winloss._on_player_ready()


func _process(delta: float) -> void:
	player_anim._on_player_process(delta)
	player_hurt._on_player_process(delta)
	player_traversal._on_player_process(delta)
	player_winloss._on_player_process(delta)


func _physics_process(delta: float) -> void:
	player_anim._on_player_physics_process(delta)
	player_hurt._on_player_physics_process(delta)
	player_traversal._on_player_physics_process(delta)
	player_winloss._on_player_physics_process(delta)

	move_and_slide()
	
	position.x = clamp(position.x, x_min, x_max)
	position.y = clamp(position.y, y_min, y_max)

		
func reset() -> void:
	player_anim._on_player_reset()
	player_hurt._on_player_reset()
	player_traversal._on_player_reset()
	player_winloss._on_player_reset()
