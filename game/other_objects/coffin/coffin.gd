extends Node2D

@onready var back_effect: Sprite2D = %BackEffect


var t = 0.0
var player_grabbed: bool = false
var grab_width: float = 40
var grab_height: float = 40
var position_offset: Vector2 = Vector2(0.0, -24)


func _process(delta: float) -> void:
	
	# Update graphics
	t += delta
	var lambda = 0.5 * sin(t * PI) + 0.5
	var gradient: Gradient = (back_effect.texture as GradientTexture2D).gradient
	gradient.set_offset(1, lerpf(0.3, 0.35, lambda))
	gradient.set_offset(2, lerpf(0.4, 0.5, lambda))
	
	# Check for player grab
	if not player_grabbed:
		if (
			abs(Game.player.position.x - position.x) < grab_width and
			position.y - Game.player.position.y < grab_height and 
			Game.player.position.y < position.y
			
		):
			grab_player()
	
	# Move player towards coffin
	if player_grabbed:
		Game.player.position = lerp(
			position + position_offset, 
			Game.player.position, 
			exp(- delta * 4.0))


# Grab the player, end the game
func grab_player() -> void:
	player_grabbed = true
	Game.victory = true
	Game.countdown.stop()
	if Game.menu != null: Game.menu.go_to(&"PostLevelMenu")
	SFX.play(SFX.ENTER_COFFIN)
	Game.player.enter_coffin()
