extends State
class_name WanderState

var can_action = true

@onready var wander_timer = $WanderTimer

# Called when the node enters the scene tree for the first time.
func enter(paras:Array) -> void:
	pass # Replace with function body.

func exit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	pass

func physics_update(delta:float) -> void:
	if ch.is_on_wall():
		ch.motion.walk = false
		wander_timer.stop()
	elif wander_timer.is_stopped():
		ch.motion.run = false
		ch.motion.walk = randi_range(0,1)
		ch.motion.direction = randi_range(0,1)
		if ch.motion.direction == 0:
			ch.motion.direction = -1
		wander_timer.start(randf_range(2,8))
	else:
		pass
