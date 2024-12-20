extends State
class_name ControlState

# Called when the node enters the scene tree for the first time.
func enter(paras:Array) -> void:
	pass # Replace with function body.

func exit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	pass

func physics_update(delta:float) -> void:
	if !PlayerState.can_input():
		ch.motion.walk = false
		ch.motion.run = false
		return
	var inp = Input.get_axis("ui_left", "ui_right")
	if inp == 1 and PlayerState.can_move_right:
		ch.motion.direction = 1
		if Input.is_action_pressed("ui_run") and ch.can_run == true:
			ch.motion.run = true
			ch.motion.walk = false
		else:
			ch.motion.run = false
			ch.motion.walk = true
	elif inp == -1 and PlayerState.can_move_left:
		ch.motion.direction = -1
		if Input.is_action_pressed("ui_run") and ch.can_run == true:
			ch.motion.run = true
			ch.motion.walk = false
		else:
			ch.motion.run = false
			ch.motion.walk = true
	else:
		ch.motion.walk = false
		ch.motion.run = false
	if Input.is_action_pressed("ui_jump") and ch.is_on_floor():
		ch.velocity.y -= 400
