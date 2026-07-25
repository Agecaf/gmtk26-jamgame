extends Node2D

@onready var sprite: Sprite2D = %Sprite

var picked: bool = false

var t = 0.0
func _process(delta: float) -> void:
	# Animation
	t += delta
	sprite.frame = posmod(floor(t * 5.0), 6)
	sprite.position.y = round(sin(t * TAU / 2) * 0.8)
	
	# Check picked
	if not picked and Game.player.position.distance_to(position) < 24:
		pick()

# Pick the fruit
func pick() -> void:
	hide()
	picked = true
	Game.fruits += 1
	SFX.play(SFX.LITTLE_BATS)
