extends State
class_name WashState

var target_rubbish:Node2D = null
var cleaning:bool = false

@onready var wander_timer = $WanderTimer
@onready var wash_timer = $WashTimer

# Called when the node enters the scene tree for the first time.
func enter(paras:Array) -> void:
	pass # Replace with function body.

func exit() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func update(delta: float) -> void:
	pass

func physics_update(delta:float) -> void:
	if cleaning == true:
		return
	if target_rubbish == null:
		_wander()
		return
	var move_target_pos = target_rubbish.position
	if move_target_pos.distance_to(ch.global_position) > 20:
		ch.motion.walk = true
		if ch.global_position.x > move_target_pos.x:
			ch.motion.direction = -1
		else :
			ch.motion.direction = 1
	else:
		ch.motion.walk = false
		ch.mainAnim.play("wash")
		wash_timer.start(target_rubbish.clean())
		cleaning = true
		ch.move = false
		ch.motion.walk = false
		target_rubbish.clean_finish.connect(on_clean_finish)

func _wander():
	if ch.is_on_wall():
		ch.motion.walk = false
		wander_timer.stop()
	elif wander_timer.is_stopped() or wander_timer.time_left == 0:
		ch.motion.walk = randi_range(0,1)
		ch.motion.direction = randi_range(0,1)
		find_near_rubbish()
		if ch.motion.direction == 0:
			ch.motion.direction = -1
		wander_timer.start(randf_range(2,8))
	else:
		pass

func find_near_rubbish():
	var min_dis = 9999
	for o:Node2D in get_tree().get_current_scene().get_node("%Objects").get_children():
		if o.is_in_group("rubbish"):
			if o.position.distance_to(ch.global_position) < min_dis:
				target_rubbish = o
				min_dis = o.position.distance_to(ch.global_position)


func _on_wash_timer_timeout() -> void:
	on_clean_finish()

func on_clean_finish():
	cleaning = false
	ch.move = true
	wander_timer.start(1)
	target_rubbish = null
