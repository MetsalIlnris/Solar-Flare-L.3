extends Node

@onready var animPlayer = $AnimatedSprite2D

#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = 500

enum state_enum  {
	controlling,
	following,
	idle,
	moving
}

var direction
var walk:bool
var run:bool 
var waiting:bool
var follow_target:Node
var wait_target:Node
var can_run = true
var can_action = true
var move_target_pos:Vector2
var stop_distance

@export var speed = 200.0 #步行速度
@export var run_speed = 400.0 #跑步速度
@export var cur_state:state_enum = state_enum.idle #状态
@export var rl_distinguished:bool #是否区分左右
@export var standby_distance = 200
@export var walk_distance = 400
@export var close_distance = 100


signal action_timeout

func _ready():
	pass

func _physics_process(delta):
	match cur_state:
		state_enum.idle:
			walk = false
			run = false
		state_enum.controlling:
			_input_handle()
		state_enum.following:
			_calculate_follow()
		state_enum.moving:
			_calculate_move()
	if wait_target:
		if global_position.distance_to(wait_target.global_position) > walk_distance:
			waiting = true
		elif global_position.distance_to(wait_target.global_position) < close_distance:
			waiting = false
	if waiting:
		walk = false
		run = false
	_move(delta)

func _move(delta):
	if rl_distinguished == true:
		if direction == -1 :
			if run == true:
				velocity.x = -run_speed
				animPlayer.play("runL")
			elif walk == true:
				velocity.x = -speed
				animPlayer.play("walkL")
			else:
				velocity.x = 0
				animPlayer.play("idleL")
		elif direction == 1:
			if run == true:
				velocity.x = run_speed
				animPlayer.play("runR")
			elif walk == true:
				velocity.x = speed
				animPlayer.play("walkR")
			else:
				velocity.x = 0
				animPlayer.play("idleR")
		else:
			velocity.x = 0
	else:
		if direction == -1 :
			if run == true:
				animPlayer.flip_h = false
				velocity.x = -run_speed
				animPlayer.play("run")
			elif walk == true:
				animPlayer.flip_h = false
				velocity.x = -speed
				animPlayer.play("walk")
			else:
				animPlayer.flip_h = false
				velocity.x = 0
				animPlayer.play("idle")
		elif direction == 1:
			if run == true:
				animPlayer.flip_h = true
				velocity.x = run_speed
				animPlayer.play("run")
			elif walk == true:
				animPlayer.flip_h = true
				velocity.x = speed
				animPlayer.play("walk")
			else:
				animPlayer.flip_h = true
				velocity=Vector2(0,0)
				animPlayer.play("idle")
		else:
			velocity.x = 0
			animPlayer.play("idle")
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func follow(node:Node):
	follow_target = node
	if follow_target:
		cur_state = state_enum.following

func wait(node:Node):
	wait_target = node

func on_door_transfer():
	if cur_state == state_enum.moving:
		cur_state = state_enum.idle

func control():
	cur_state = state_enum.controlling
	PlayerState.cur_interact_body = self
	PlayerState.group.append(self)

func uncontrol():
	cur_state = state_enum.idle
	if PlayerState.cur_interact_body == self:
		PlayerState.cur_interact_body = null
	PlayerState.group.erase(self)

func move_to(pos:Vector2,distance = close_distance):
	move_target_pos = pos
	stop_distance = distance
	cur_state = state_enum.moving

func _input_handle():
	var inp = Input.get_axis("ui_left", "ui_right")
	if inp == 1 and PlayerState.can_move_right():
		direction = 1
		if Input.is_action_pressed("ui_run") and can_run == true:
			run = true
			walk = false
		else:
			run = false
			walk = true
	elif inp == -1 and PlayerState.can_move_left():
		direction = -1
		if Input.is_action_pressed("ui_run") and can_run == true:
			run = true
			walk = false
		else:
			run = false
			walk = true
	else:
		walk = false
		run = false
	if Input.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y -= 400

func _calculate_follow():
	if follow_target:
		if global_position.distance_to(follow_target.global_position) > walk_distance && can_run == true:
			run = true
		elif global_position.distance_to(follow_target.global_position) > standby_distance:
			walk = true
			run = false
		elif global_position.distance_to(follow_target.global_position) > close_distance:
			run = false
		else:
			run = false
			walk = false
		if global_position.x > follow_target.global_position.x:
			direction = -1
		else :
			direction = 1

func _calculate_move():
	if move_target_pos:
		#if global_position.distance_to(move_target_pos) > walk_distance && can_run == true:
			#run = true
		if global_position.distance_to(move_target_pos) > standby_distance:
			walk = true
			run = false
		elif global_position.distance_to(move_target_pos) > close_distance:
			run = false
		else:
			run = false
			walk = false
		if global_position.x > move_target_pos.x:
			direction = -1
		else :
			direction = 1

func action_time():
	can_action = false
	$ActionTimer.start()

func _on_action_timer_timeout():
	can_action = true
	action_timeout.emit()
