extends Node2D

var ball_pos = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ball_pos.append($Main.global_position)
	ball_pos.append($"1".global_position - $Main.global_position)
	ball_pos.append($"2".global_position - $"1".position)
	ball_pos.append($"3".global_position - $"2".position)
	$"1/FollowComponent".phase = ball_pos[1]
	$"2/FollowComponent".phase = ball_pos[2]
	$"3/FollowComponent".phase = ball_pos[3]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#$Main.position = get_global_mouse_position()
	pass
