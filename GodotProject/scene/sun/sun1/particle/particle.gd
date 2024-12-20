extends StaticBody2D

signal captured

@onready var tower = $"../../Tower/Main/Marker"
@onready var collision = $CollisionShape2D

@export var particle_id = 1

var direction = Vector2(-1,0)
var grabbing = false
var grabbed = false
var physic_scale = 1
var speed_scale = 1
var moving
var move_target
var is_excaped = false #这个标记将不允许粒子被拖动
var click_cnt = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grabbing == true:
		global_position = get_global_mouse_position()
	elif moving == true:
		global_position = global_position.move_toward(move_target.global_position,delta * 300 * speed_scale)
	else:
		position.x += 300 * direction.x * speed_scale * delta
		position.y += 300 * direction.y * speed_scale * delta
	rotate(3 * speed_scale * delta)
	if particle_id <= 3:
		if grabbed == true and grabbing == false:
			if global_position.distance_to(tower.global_position) < 20 + 10*physic_scale:
				captured.emit()
				PlayerState.yan_grab_release()
				queue_free()
	elif particle_id == 5:
		var t = (global_position - get_global_mouse_position()).normalized()
		var dis = global_position.distance_to(get_global_mouse_position())
		if dis < 200:
			direction = direction.move_toward(t,delta * 100/dis)
	

func init(n:int):
	particle_id = n
	for img in $Images.get_children():
		if img.name == str(n):
			img.show()
		else:
			if img.is_class("Node2D"):
				img.hide()
	match n:
		1:
			#中子
			speed_scale = 1
			physic_scale = 1
		2:
			#质子
			speed_scale = 0.7
			physic_scale = 0.6
		3:
			#电子
			speed_scale = 1.5
			physic_scale = 0.6
		4:
			#铁泡泡子 点击碎成泡泡
			speed_scale = 0.3
			physic_scale = 1.5
		5:
			#中微子 点击跑掉
			speed_scale = 0.2
			physic_scale = 1
		6:
			#猫猫子 点击发出猫叫
			speed_scale = 0.5
			physic_scale = 1.2
		7:
			#晕了 点击改变方向
			speed_scale = 0.8
			physic_scale = 1.5
	collision.scale = Vector2(physic_scale,physic_scale)
	$Timer.start(20.0/speed_scale)

func move_to(target:Node2D): 
	moving = true
	move_target = target

func _on_timer_timeout():
	queue_free()


func _on_button_button_down() -> void:
	grabbed = true
	click_cnt += 1
	match particle_id:
		4:
			#铁泡泡子
			if click_cnt >= 5:
				generate_bubbles()
				queue_free()
			else:
				$Images/ShakeComponent.amplitude = 20
				$"Images/4/FeTimer".start(0.5)
		5:
			#中微子
			speed_scale = 0.2
			physic_scale = 1
		6:
			#猫猫子
			speed_scale = 0.5
			physic_scale = 1.2
			grabbing = true
			$AudioStreamPlayer2D.play()
		7:
			#晕了
			speed_scale = 0.6
			physic_scale = 1.5
			grabbing = true
		_:
			grabbing = true


func _on_button_button_up() -> void:
	grabbing = false


func _on_fe_timer_timeout() -> void:
	$Images/ShakeComponent.amplitude = 0

func generate_bubbles():
	var node 
	var di = Vector2(-1,0)
	for i in range(7):
		node = load("res://scene/sun/sun1/particle/bubble.tscn").instantiate()
		get_parent().add_child(node)
		node.position = position
		node.init(di)
		di = di.rotated(randf_range(1,1.3))
