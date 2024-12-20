extends Node

@export var target:Node2D
@export var speed:float = 10
@export var phase:Vector2 = Vector2(0,0)

var position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = get_parent().global_position
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not target:
		return
	var tar_pos = target.global_position
	var dis = position.distance_to(tar_pos+phase)
	if dis < speed:
		position = tar_pos+phase
	else:
		position += position.direction_to(tar_pos+phase) * speed
	get_parent().global_position = position
