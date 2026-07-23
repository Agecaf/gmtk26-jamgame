class_name Crossbow extends StaticBody2D


@export_range(24, 1920, 24) var detection_range: float = 96
@export_range(25, 500, 25) var bolt_speed: float = 150
@export_range(0.5, 10, 0.5) var bolt_cooldown: float = 2.5

var bolt_template: PackedScene = preload('res://game/traps/crossbow_bolt.tscn')

var bolt_cooldown_remaining: float = 0


func _process(delta: float) -> void:
	bolt_cooldown_remaining = maxf(0, bolt_cooldown_remaining - delta)


func _physics_process(_delta: float) -> void:
	$Raycast.target_position = detection_range * Vector2.LEFT
	$Raycast.force_raycast_update()
	
	if $Raycast.is_colliding():
		face(Enums.Direction.LEFT)
		fire(Enums.Direction.LEFT)
	
	$Raycast.target_position = detection_range * Vector2.RIGHT
	$Raycast.force_raycast_update()

	if $Raycast.is_colliding():
		face(Enums.Direction.RIGHT)
		fire(Enums.Direction.RIGHT)


func face(direction: Enums.Direction) -> void:
	if direction == Enums.Direction.LEFT:
		$Sprite.scale = Vector2.ONE
		$Collider.scale = Vector2.ONE
	elif direction == Enums.Direction.RIGHT:
		$Sprite.scale = Vector2(-1, 1)
		$Collider.scale = Vector2(-1, 1)


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
		bolt.velocity = bolt_speed * Vector2.LEFT
	elif direction == Enums.Direction.RIGHT:
		bolt.velocity = bolt_speed * Vector2.RIGHT
