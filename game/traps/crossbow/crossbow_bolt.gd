class_name CrossbowBolt extends Node2D


var velocity: Vector2 = Vector2.ZERO
var final_velocity: Vector2 = Vector2.ZERO


func _ready() -> void:
	$HitboxComponent.body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	position += velocity * delta
	velocity = lerp(velocity, final_velocity, exp(-delta * 50))


func face(direction: Enums.Direction) -> void:
	if direction == Enums.Direction.LEFT:
		scale = Vector2.ONE
	elif direction == Enums.Direction.RIGHT:
		scale = Vector2(-1, 1)


func _on_body_entered(body: Node2D) -> void:
	if body is not Player:
		velocity = Vector2.ZERO
		final_velocity = Vector2.ZERO
		$HitboxComponent/Collider.set_deferred('disabled', true)
		$Animator.play(&'CrossbowBolt/Vanish')

