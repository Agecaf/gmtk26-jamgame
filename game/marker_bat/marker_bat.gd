class_name MarkerBat
extends Node2D


static var template: PackedScene = preload('res://game/marker_bat/marker_bat.tscn')
static var instance: MarkerBat

var sprite: Sprite2D:
	get: return $Sprite
var animator: AnimationPlayer:
	get: return $Animator


func face(direction: Enums.Direction) -> void:
	scale = Vector2.ONE if direction == Enums.Direction.RIGHT else Vector2(-1, 1)


static func mark(target: Vector2) -> void:
	if is_instance_valid(instance):
		var old_instance: MarkerBat = instance
		old_instance.animator.play(&'MarkerBat/Vanish')
		old_instance.animator.animation_finished.connect(
			func(_anim_name: StringName) -> void:
				old_instance.queue_free()
		)
	
	var new_instance: MarkerBat = MarkerBat.template.instantiate() as MarkerBat
	Game.scene.add_child(new_instance)

	var y_offset: float = Game.player.collider.shape.get_rect().size.y / 2

	new_instance.position = target + y_offset * Vector2.DOWN
	new_instance.face(Game.player.current_facing)
	new_instance.animator.play(&'MarkerBat/Arrive')
	new_instance.animator.animation_finished.connect(
		func(_anim_name: StringName) -> void:
			new_instance.animator.play(&'MarkerBat/Rest')
	)

	instance = new_instance
