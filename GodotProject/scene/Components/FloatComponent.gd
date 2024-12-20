extends Node

@export var float_speed:float = 0.6
@export var float_range:Vector2 = Vector2(0,2)

var position
var stop:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_parent().position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stop:
		return
	var offset_x = sin(Time.get_ticks_msec() * 0.001 * float_speed) * float_range.x * 5
	var offset_y = sin(Time.get_ticks_msec() * 0.001 * float_speed) * float_range.y * 5
	get_parent().position.x = position.x + offset_x
	get_parent().position.y = position.y + offset_y
