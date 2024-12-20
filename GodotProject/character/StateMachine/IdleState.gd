extends State
class_name IdleState


# Called when the node enters the scene tree for the first time.
func enter(paras:Array) -> void:
	pass # Replace with function body.

func exit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	pass

func physics_update(delta:float) -> void:
	ch.motion.run = false
	ch.motion.walk = false
