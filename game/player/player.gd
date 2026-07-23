class_name Player
extends CharacterBody2D


@export var speed: float = 200
@export var jump_force: float = 1000


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


func _physics_process(_delta: float) -> void:
	var jump_pressed: bool = Input.is_action_just_pressed('ui_up')

	if jump_pressed and can_jump:
		can_jump = false
		velocity.y -= jump_force

	if is_on_floor():
		can_jump = true
	
	var move_left: int = 1 if Input.is_action_pressed('ui_left') else 0
	var move_right: int = 1 if Input.is_action_pressed('ui_right') else 0
	
	velocity.x = speed * (move_right - move_left)
	velocity.y += Game.scene.gravity if Game.scene else 0.0

	move_and_slide()
	
	position.x = clamp(position.x, x_min, x_max)
	position.y = clamp(position.y, y_min, y_max)

		
func reset() -> void:
	can_jump = true
