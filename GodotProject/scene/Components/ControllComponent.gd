extends Node

@export var move_speed = 10
@export var limit_h = Vector2(-100000,100000)
@export var limit_v = Vector2(-100000,100000)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var inp_x = Input.get_axis("ui_left", "ui_right")
	var inp_y = Input.get_axis("ui_up","ui_down")
	get_parent().position += Vector2( inp_x * move_speed, inp_y * move_speed ) 
	get_parent().position.x = clamp(get_parent().position.x,limit_h.x,limit_h.y)
	get_parent().position.y = clamp(get_parent().position.y,limit_v.x,limit_v.y)
