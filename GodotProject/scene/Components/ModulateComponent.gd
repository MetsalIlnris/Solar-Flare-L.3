extends Node

@export var speed:float = 0.5
@export var offset:float = 0
@export var limit:float = 0.6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ob = get_parent()
	ob.modulate.r = clamp(sin(Time.get_ticks_msec() * 0.001 * speed+offset)+0.5,limit,1)
	ob.modulate.g = clamp(sin(Time.get_ticks_msec() * 0.001 * speed+2*PI/3+offset)+0.5,limit,1)
	ob.modulate.b = clamp(sin(Time.get_ticks_msec() * 0.001 * speed+4*PI/3+offset)+0.5,limit,1)
