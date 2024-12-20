extends CharacterBody2D
class_name character

@onready var mainAnim:AnimatedSprite2D = $MainAnim
@onready var wonder_timer = $WonderTimer

#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 980

#状态机可以改变的状态柄
class motion_class:
	var direction:int = 0
	var walk:bool = false
	var run:bool  = true
#状态机
var states : Dictionary = {}
var cur_state : State
@export var initial_state : State

var motion:motion_class = motion_class.new()
var move:bool = true
var waiting:bool
var wait_target:Node

#角色的属性值
@export var speed = 200.0 #步行速度
@export var run_speed = 800.0 #跑步速度
@export var rl_distinguished:bool #是否区分左右
@export var standby_distance = 200
@export var walk_distance = 400
@export var close_distance = 100
@export var can_run = true

# 控制显示大小的变量
var cur_size = 1
var base_data:Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for state in $StateMachines.get_children():
		if state is State:
			states[state.name.to_lower()] = state
			state.transition.connect(state_transition)
	
	if initial_state:
		initial_state.enter([])
		cur_state = initial_state
	
	base_data["speed"] = speed
	base_data["run_speed"] = run_speed
	base_data["standby_distance"] = standby_distance
	base_data["walk_distance"] = walk_distance
	base_data["close_distance"] = close_distance
	base_data["anim_pos"] = mainAnim.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if cur_state:
		cur_state.ch = self
		cur_state.physics_update(delta)
	else:
		motion.run = false
		motion.direction = 0
		motion.walk = false
	#单独处理wait的motion
	if wait_target:
		if global_position.distance_to(wait_target.global_position) > walk_distance:
			waiting = true
		elif global_position.distance_to(wait_target.global_position) < close_distance:
			waiting = false
	if waiting:
		motion.walk = false
		motion.run = false
	if move == true:
		_move(delta)
	else:
		velocity = Vector2(0,0)
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func state_transition(state, new_state_name:String , paras = []):
	if state != cur_state:
		return
		
	var new_state:State = states.get((new_state_name + "State").to_lower())
	
	if !new_state:
		return
		
	if cur_state:
		cur_state.exit()
		
	new_state.enter(paras)
	cur_state = new_state

func switch_size(tar_size):
	mainAnim.scale = Vector2(tar_size,tar_size)
	mainAnim.position.y = base_data["anim_pos"].y*tar_size
	speed = base_data["speed"]*tar_size
	run_speed = base_data["run_speed"]*tar_size
	standby_distance = base_data["standby_distance"]*tar_size
	walk_distance = base_data["walk_distance"]*tar_size
	close_distance = base_data["close_distance"]*tar_size


func _move(delta):
	if rl_distinguished == true:
		if motion.direction == -1 :
			if motion.run == true:
				velocity.x = -run_speed
				mainAnim.play("runL")
			elif motion.walk == true:
				velocity.x = -speed
				mainAnim.play("walkL")
			else:
				velocity.x = 0
				mainAnim.play("idleL")
		elif motion.direction == 1:
			if motion.run == true:
				velocity.x = run_speed
				mainAnim.play("runR")
			elif motion.walk == true:
				velocity.x = speed
				mainAnim.play("walkR")
			else:
				velocity.x = 0
				mainAnim.play("idleR")
		else:
			velocity.x = 0
	else:
		if motion.direction == -1 :
			flip(false)
			if motion.run == true:
				velocity.x = -run_speed
				mainAnim.play("run")
			elif motion.walk == true:
				velocity.x = -speed
				mainAnim.play("walk")
			else:
				velocity.x = 0
				mainAnim.play("idle")
		elif motion.direction == 1:
			flip(true)
			if motion.run == true:
				velocity.x = run_speed
				mainAnim.play("run")
			elif motion.walk == true:
				velocity.x = speed
				mainAnim.play("walk")
			else:
				velocity.x = 0
				mainAnim.play("idle")
		else:
			velocity.x = 0
			mainAnim.play("idle")

func follow(node:Node):
	if node:
		state_transition(cur_state, "follow",[node])

func wait(node:Node):
	wait_target = node

func on_door_transfer():
	if cur_state == states.get("move"):
		state_transition(cur_state, "idle")

func control():
	state_transition(cur_state, "control")
	PlayerState.cur_interact_body = self
	PlayerState.group.append(self)

func uncontrol():
	state_transition(cur_state, "idle")
	if PlayerState.cur_interact_body == self:
		PlayerState.cur_interact_body = null
		PlayerState.group = []

func move_to(pos:Vector2,distance = close_distance):
	var move_target_pos = pos
	var stop_distance = distance
	state_transition(cur_state, "move" , [move_target_pos, stop_distance])

func flip(flip_or_not:bool):
	if flip_or_not == true:
		mainAnim.flip_h = true
		for anim in mainAnim.get_children():
			if anim.has_method("flip"):
				anim.flip(true)
	else:
		mainAnim.flip_h = false
		for anim in mainAnim.get_children():
			if anim.has_method("flip"):
				anim.flip(false)

func wander():
	state_transition(cur_state , "wander")
