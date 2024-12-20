extends State
class_name FollowState

var follow_target:Node

# Called when the node enters the scene tree for the first time.
func enter(paras:Array) -> void:
	follow_target = paras[0]

func exit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	pass

func physics_update(delta:float) -> void:
	if follow_target:
		if ch.global_position.distance_to(follow_target.global_position) > ch.walk_distance && ch.can_run == true:
			ch.motion.run = true
		elif ch.global_position.distance_to(follow_target.global_position) > ch.standby_distance:
			ch.motion.walk = true
			ch.motion.run = false
		elif ch.global_position.distance_to(follow_target.global_position) > ch.close_distance:
			ch.motion.run = false
		else:
			ch.motion.run = false
			ch.motion.walk = false
		if ch.global_position.x > follow_target.global_position.x:
			ch.motion.direction = -1
		else :
			ch.motion.direction = 1
