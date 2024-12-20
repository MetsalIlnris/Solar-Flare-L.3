extends AnimatedSprite2D

@onready var timer = $Timer
var tween
var portrait 
var shaking:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if shaking == true:
		disturb_offset(50)

func disturb_offset(strength : float):
	var p = timer.time_left
	portrait.offset = Vector2(randf_range(-strength,strength),randf_range(-strength,strength))*p

func shake():
	shaking = true
	timer.start(1)

func _on_timer_timeout():
	shaking = false
