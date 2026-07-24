# Attach this scene to any projectile/object that hurts the player
# then add a collision to it, shape it to anything you want
class_name HitboxComponent extends Area2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Game.player.hurt()
