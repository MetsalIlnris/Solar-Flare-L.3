extends Node

@export var blink_speed:float = 0.8
@export var blink_range:Vector2 = Vector2(0,1)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var weight = clamp(sin(Time.get_ticks_msec() * 0.001 * blink_speed)/2+0.5,0,1)
	var trans = lerp(blink_range.x,blink_range.y,weight)
	get_parent().modulate.a = trans
