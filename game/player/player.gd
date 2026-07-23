class_name Player
extends CharacterBody2D


@export_range(25, 500, 25) var speed: float = 200
@export_range(0.05, 1.0, 0.05) var jump_time: float = 0.5
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

var can_jump: bool


func _ready() -> void:
	reset()
	Game.player = self


func _physics_process(delta: float) -> void:
	var jump_pressed: bool = Input.is_action_just_pressed('ui_up')

	if jump_pressed and can_jump:
		can_jump = false
		velocity.y = jump_initial_velocity

	if is_on_floor():
		can_jump = true
	
	var move_left: int = 1 if Input.is_action_pressed('ui_left') else 0
	var move_right: int = 1 if Input.is_action_pressed('ui_right') else 0
	
	velocity.x = speed * (move_right - move_left)
	velocity.y += delta * jump_gravity

	move_and_slide()
	
	position.x = clamp(position.x, x_min, x_max)
	position.y = clamp(position.y, y_min, y_max)

		
func reset() -> void:
	can_jump = true
