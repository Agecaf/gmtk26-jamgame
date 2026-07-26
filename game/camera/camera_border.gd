class_name CameraBorder extends Area2D

@export var block_left : bool
@export var block_right : bool
@export var block_up : bool
@export var block_down : bool
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("camera_borders")
	
func get_border_shape() -> Rect2:
	if collision_shape_2d == null:
		Debug.error("No Camera Border Collision")
		return Rect2()
	
	var shape = collision_shape_2d.shape as RectangleShape2D
	
	var size : Vector2 = shape.size
	var center : Vector2 = collision_shape_2d.global_position
	
	return Rect2(center - size / 2.0, size)
	

func clamp_camera(target_position: Vector2, player_position: Vector2, half_camera_size: Vector2) -> Vector2:
	var result: Vector2 = target_position
	var border_shape: Rect2 = get_border_shape()
	
	# For Left and Right Camera blocking
	if (player_position.y > border_shape.position.y and player_position.y < border_shape.end.y):
		
		# okay if the camera is to the LEFT of the wall,
		# block its RIGHT EDGE.
		if block_left and target_position.x < border_shape.position.x:
			
			var camera_right : float = target_position.x + half_camera_size.x
			
			if camera_right > border_shape.position.x:
				result.x = border_shape.position.x - half_camera_size.x
		
		# okay if the camera is to the RIGHT of the wall,
		# block its LEFT EDGE.
		elif block_right and target_position.x > border_shape.end.x: 
			var camera_left : float = target_position.x - half_camera_size.x
			
			if camera_left < border_shape.end.x:
				result.x = border_shape.end.x + half_camera_size.x
	
	# For Up and Down Camera blocking
	elif (player_position.x > border_shape.position.x and player_position.x < border_shape.end.x):

		# okay if the camera is to the ABOVE of the wall,
		# block its BOTTOM EDGE.
		if block_up and target_position.y < border_shape.position.y:
			
			var camera_bottom : float = target_position.y + half_camera_size.y
			
			if camera_bottom > border_shape.position.y:
				result.y = border_shape.position.y - half_camera_size.y
		
		# okay if the camera is to the BELOW of the wall,
		# block its TOP EDGE.
		elif block_down and target_position.y > border_shape.end.y: 
			var camera_top : float = target_position.y - half_camera_size.y
			
			if camera_top < border_shape.end.y:
				result.y = border_shape.end.y + half_camera_size.y
	
	return result
