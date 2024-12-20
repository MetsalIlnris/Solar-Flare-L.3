extends State
class_name MoveState

var move_target_pos:Vector2
var stop_distance

# Called when the node enters the scene tree for the first time.
func enter(paras:Array) -> void:
	move_target_pos = paras[0]
	stop_distance = paras[1]

func exit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	pass

func physics_update(delta:float) -> void:
	if move_target_pos:
		#if global_position.distance_to(move_target_pos) > walk_distance && can_run == true:
			#ch.motion.run = true
		if ch.global_position.distance_to(move_target_pos) > ch.standby_distance:
			ch.motion.walk = true
			ch.motion.run = false
		elif ch.global_position.distance_to(move_target_pos) > ch.close_distance:
			ch.motion.run = false
		else:
			ch.motion.run = false
			ch.motion.walk = false
		if ch.global_position.x > move_target_pos.x:
			ch.motion.direction = -1
		else :
			ch.motion.direction = 1
