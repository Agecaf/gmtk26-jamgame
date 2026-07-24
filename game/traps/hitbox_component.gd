# Attach this scene to any projectile/object that hurts the player
# then add a collision to it, shape it to anything you want

class_name HitboxComponent extends Area2D

@export var damage : int = 1

# if you want to add knockback in the future
# have the function return a dictionary and include it with damage
func get_hit_data() -> int:
	# var direction = (target_position - global_position).normalized() <- for Knockback 
	
	return damage
