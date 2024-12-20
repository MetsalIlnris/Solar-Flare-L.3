extends Node2D

var open:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if open == false:
		open = true
		var time = randf_range(0,3)
		$Timer.start(time)
		$Open.show()
		$Close.hide()

func flip(flip_or_not):
	if flip_or_not == true:
		scale.x = -1
	else:
		scale.x = 1

func _on_timer_timeout() -> void:
	$Close.show()
	$Open.hide()
	open = false
