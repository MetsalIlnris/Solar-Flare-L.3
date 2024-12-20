extends Node2D

@onready var tower = $Tower
@onready var captured_particle = $Tower/Main/CapturedParticle
@onready var arrow = $Tower/Main/Cursor/Arrow
@onready var cursor = $Tower/Main/Cursor
@onready var near_arrow = $Tower/Main/Arrow
@onready var animation = $Tower/AnimationPlayer

@export var tower_id = 1
@export var excape_value_max = 150
@export var cursor_speed = 1.0

var excape_value = 150
var captured = 0
var target_particle
var in_cursor_area:bool = false
var nearest_particle = null

signal excape

enum state_enum  {
	idle,
	auto_capture,
	auto_collect
}

@export var cur_state:state_enum = state_enum.idle #状态

var ball_pos = []

func _ready():
	randomize()
	set_auto(0)
	ball_pos.append($Tower/Main.global_position)
	ball_pos.append($"Balls/1".global_position - $Tower/Main.global_position)
	ball_pos.append($"Balls/2".global_position - $"Balls/1".global_position)
	ball_pos.append($"Balls/3".global_position - $"Balls/2".global_position)
	ball_pos.append($Balls/Xu.global_position - $"Balls/3".global_position)
	$"Balls/1/FollowComponent".phase = ball_pos[1]
	$"Balls/2/FollowComponent".phase = ball_pos[2]
	$"Balls/3/FollowComponent".phase = ball_pos[3]
	$Balls/Xu/FollowComponent.phase = ball_pos[4]
	$Tower/Main/Cursor/CursorArea/FloatComponent.float_speed = cursor_speed

func _physics_process(delta):
	_check_cursor_area()
	var nearest_dis:float = 9999
	nearest_particle = null
	var tower_pos = tower.position
	for particle in $Particle.get_children():
		if particle.is_excaped == true:
			continue
		if particle.position.distance_to(tower_pos) < nearest_dis:
			nearest_dis = particle.position.distance_to(tower_pos)
			nearest_particle = particle
	if nearest_particle and nearest_dis <1000:
		var tan_x = nearest_particle.position.y - tower_pos.y
		var tan_y = nearest_particle.position.x - tower_pos.x
		near_arrow.rotation = atan2(tan_x, tan_y)
		if nearest_dis < 400:
			near_arrow.modulate.a = 1
		else:
			near_arrow.modulate.a = (1000.0-nearest_dis)/600.0
	else:
		near_arrow.modulate.a = 0
	match cur_state:
		state_enum.idle:
			if captured:
				_controll_captured(delta)
		state_enum.auto_capture:
			if not captured:
				_auto_capture()
			else:
				_controll_captured(delta)
		state_enum.auto_collect:
			if captured:
				_auto_collect()

#func _controll_move():
	#var inp = Input.get_axis("key_w", "key_s")
	#if inp == 1 or inp == -1:
		#tower.velocity.y = tower.velocity.y + inp * acceleration;
		#tower.velocity.y = clamp(tower.velocity.y,-speed,speed)
	#else:
		#if tower.velocity.y > acceleration:
			#tower.velocity.y -= acceleration
		#elif tower.velocity.y < -acceleration:
			#tower.velocity.y += acceleration
		#else:
			#tower.velocity.y = 0
	#tower.move_and_slide()

func _on_particle_captured():
	if captured == 0:
		captured = 1
		captured_particle.show()
		cursor.show()
		excape_value = excape_value_max
		$Tower/Main/Cursor/CursorArea/FloatComponent.stop = false

func _on_particle_excape():
	captured = 0
	captured_particle.hide()
	generate_particle(tower.position - Vector2(30,0),true)
	$Tower/Main/ShakeComponent.amplitude = 0
	target_particle = null
	excape_value = excape_value_max
	cursor.hide()
	excape.emit()

func _controll_captured(delta):
	var key
	match tower_id:
		1:
			key = KEY_A
		2: 
			key = KEY_S
		3:
			key = KEY_D
	var inp = Input.is_key_pressed(key)
	if inp == true:
		arrow.velocity.y = - 8000 * delta
	else:
		arrow.velocity.y = 8000 * delta
	arrow.move_and_slide()
	if not in_cursor_area:
		excape_value -= 1
		$Tower/Main/Cursor/Arrow/Sprite.play("no")
	else:
		if excape_value < excape_value_max:
			excape_value += 3
		$Tower/Main/Cursor/Arrow/Sprite.play("yes")
	if excape_value < 0:
		_on_particle_excape()
	else:
		$Tower/Main/ShakeComponent.amplitude = (excape_value_max - excape_value) / 3

func generate_particle(position:Vector2,is_excaped:bool = false):
	var node = load("res://scene/sun/sun1/particle/particle.tscn").instantiate()
	$Particle.add_child(node)
	node.position = position
	node.init(tower_id)
	node.captured.connect(_on_particle_captured)
	if is_excaped:
		node.is_excaped = true
	elif not target_particle:
		target_particle = node


func _on_timer_timeout():
	var pos =  Vector2(0,randi_range(-200,200))
	generate_particle($Timer/Marker2D.position + pos)

func _auto_capture():
	if PlayerState.yan_grabbing == true:
		return
	if nearest_particle:
		if nearest_particle.grabbed == false:
			var dis = nearest_particle.global_position.distance_to(tower.global_position)
			if  dis < 200:
				nearest_particle.move_to(tower.get_node("Main"))
				nearest_particle.grabbed = true
				PlayerState.yan_grabbing = true

func _auto_collect():
	arrow.position = $Tower/Main/Cursor/CursorArea.position

func set_auto(auto:int):
	cursor.hide()
	match auto:
		0:
			cur_state = state_enum.idle
		1:
			cur_state = state_enum.auto_capture
		2:
			cur_state = state_enum.auto_collect

func collect():
	captured = 0
	animation.play("collect")
	$Tower/Main/Cursor/CursorArea/FloatComponent.stop = true
	await(animation.animation_finished)
	captured_particle.hide()
	target_particle = null
	cursor.hide()
	$Tower/Main/ShakeComponent.amplitude = 0

func stop():
	$Timer.stop()
	
func _check_cursor_area():
	var dis = arrow.global_position.y - $Tower/Main/Cursor/CursorArea.global_position.y
	if dis>-35 and dis < 35:
		in_cursor_area = true
	else:
		in_cursor_area = false
