extends CharacterBody2D

@onready var ballAnim = $BallNormal
@onready var shake_timer = $ShakeTimer

var move_target_pos
var stop_distance = 11
var close_distance = 200
var max_speed = 200

var acceleration = 2.0  # 缓动加速度
var deceleration = 1.6  # 缓动减速度

# 设置移动范围和移动速度
var float_range = Vector2(0, 10) 
var float_speed = 0.6 

var shaking:bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	_calculate_move()
	
func move_to(pos:Vector2,distance = stop_distance):
	move_target_pos = pos
	stop_distance = distance


func _calculate_move():
	var cur_speed = velocity.length()
	if move_target_pos:
		var direction = (move_target_pos - global_position).normalized()
		if global_position.distance_to(move_target_pos) > close_distance:
			if(cur_speed<= max_speed):
				cur_speed += acceleration
		elif global_position.distance_to(move_target_pos) > stop_distance:
			cur_speed -= deceleration
			if(cur_speed<40):
				cur_speed = 40
		else :
			global_position = move_target_pos
			cur_speed = 0
			move_target_pos = null
			open()
		velocity = direction* cur_speed
		move_and_slide()
	var offset = sin(Time.get_ticks_msec() * 0.001 * float_speed) * float_range.y 
	ballAnim.offset.y = offset
	if shaking == true:
		disturb_offset(0)

func open():
	shake()
	await(shake_timer.timeout)
	shaking = false
	ballAnim.play("open")
	float_range.y = 4
	$InteractArea.monitorable = true
	$InteractArea.monitoring = true


func disturb_offset(strength : float):
	var p = shake_timer.time_left
	ballAnim.offset += Vector2(randf_range(-strength,strength),randf_range(-strength,strength))*p

func shake():
	shaking = true
	shake_timer.start(1)
