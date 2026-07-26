class_name Crossbow extends StaticBody2D


@export var left_or_right: bool = false
@export_range(24, 1920, 24) var detection_range: float = 96
@export_range(25, 500, 25) var bolt_speed_initial: float = 600
@export_range(25, 500, 25) var bolt_speed_final: float = 200
@export_range(0.5, 10, 0.5) var bolt_cooldown: float = 2.5

@onready var raycast: RayCast2D = $Raycast
@onready var collider: CollisionShape2D = $Collider
@onready var sprite: Sprite2D = $Sprite
@onready var animation: AnimationPlayer = $AnimationPlayer

var bolt_template: PackedScene = preload('res://game/traps/crossbow/crossbow_bolt.tscn')
var bolt_cooldown_remaining: float = 0


func _process(delta: float) -> void:
	
	if bolt_cooldown_remaining > 0:
		bolt_cooldown_remaining -= delta
		if bolt_cooldown_remaining <= 0.0:
			bolt_cooldown_remaining = 0.0
			animation.play(&"reload")


func _physics_process(_delta: float) -> void:
	# Face in player direction
	if left_or_right:
		face(Enums.Direction.LEFT)
	else:
		face(Enums.Direction.RIGHT)
	
	# Raycast
	if left_or_right:
		raycast.target_position = detection_range * Vector2.LEFT
		raycast.force_raycast_update()
		
		if raycast.is_colliding():
			fire(Enums.Direction.LEFT)
	
	else:
		raycast.target_position = detection_range * Vector2.RIGHT
		raycast.force_raycast_update()

		if raycast.is_colliding():
			fire(Enums.Direction.RIGHT)


func face(direction: Enums.Direction) -> void:
	if direction == Enums.Direction.LEFT:
		sprite.scale = Vector2.ONE
		collider.scale = Vector2.ONE
	elif direction == Enums.Direction.RIGHT:
		sprite.scale = Vector2(1, -1)
		collider.scale = Vector2(-1, 1)


func fire(direction: Enums.Direction) -> void:
	if bolt_cooldown_remaining:
		return
	
	var spawn_point: Marker2D
	
	if direction == Enums.Direction.LEFT:
		spawn_point = $BoltSpawnPointLeft
	elif direction == Enums.Direction.RIGHT:
		spawn_point = $BoltSpawnPointRight
	else:
		return
	
	bolt_cooldown_remaining = bolt_cooldown
	
	var bolt: CrossbowBolt = bolt_template.instantiate() as CrossbowBolt
	add_child(bolt)
	
	bolt.position = spawn_point.position
	bolt.face(direction)
	
	if direction == Enums.Direction.LEFT:
		bolt.final_velocity = bolt_speed_final * Vector2.LEFT
		bolt.velocity = bolt_speed_initial * Vector2.LEFT
	elif direction == Enums.Direction.RIGHT:
		bolt.final_velocity = bolt_speed_final * Vector2.RIGHT
		bolt.velocity = bolt_speed_initial * Vector2.RIGHT
	
	# Play animation and SFX
	animation.play(&"fire")
	SFX.play(SFX.CROSSBOW_SHOT)
	
