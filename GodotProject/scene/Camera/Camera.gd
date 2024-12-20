extends Camera2D

@onready var animation = $CanvasLayer/Animation
@onready var shake_timer = $ShakeTimer

signal fade_finish
var shaking:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.hide()

func _process(delta):
	if shaking == true:
		disturb_offset(20)

func disturb_offset(strength : float):
	var p = shake_timer.time_left
	offset = Vector2(randf_range(-strength,strength),randf_range(-strength,strength))*p

func shake(time:float = 0.5):
	shaking = true
	shake_timer.start(time)

func _on_shake_timer_timeout():
	shaking = false

func fade_in():
	$AnimationPlayer.play("fade")
	await($AnimationPlayer.animation_finished)
	#animation.show()
	#animation.set_rotation(0)
	#animation.play("fade")
	#await(animation.animation_finished)
	fade_finish.emit()

func fade_out():
	$AnimationPlayer.play_backwards("fade")
	await($AnimationPlayer.animation_finished)
	#animation.set_rotation(PI)
	#animation.play_backwards("fade")
	#await(animation.animation_finished)
	animation.hide()
