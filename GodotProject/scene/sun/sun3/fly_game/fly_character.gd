extends Node2D
@onready var one = $FlyCharacter
@onready var app = $FlyCharacter2

var  speed = 300
var one_hp = 4
var app_hp = 4
var app_speed = 5
var app_stop_timer
var app_hurting = false
var app_start_pos 
signal hp_changed
signal gameover
var game_is_over:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_is_over = true

func start():
	game_is_over = false
	$Timer.start(3)
	$Timer/StringTimer.start(12)
	app_stop_timer = Time.get_ticks_msec()
	app.position.x = 400 + sin(-PI/2+(Time.get_ticks_msec()-app_stop_timer) * 0.0001 * app_speed)*400
	app.position.y = 500 + sin((Time.get_ticks_msec()-app_stop_timer) * 0.0003 * app_speed)*100
	app_start_pos = app.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var inp_x = Input.get_axis("ui_left", "ui_right")
	var inp_y = Input.get_axis("ui_up","ui_down")
	one.velocity = Vector2(inp_x,inp_y)*speed
	if game_is_over == true:
		return
	var collision = one.move_and_collide(one.velocity*delta)
	if collision and !$FlyCharacter/AnimationPlayer.is_playing() :
		one.velocity = one.velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("apply_central_impulse"):
			collision.get_collider().apply_central_impulse(-collision.get_normal()*200)
			if collision.get_collider().get("heal") == true:
				collision.get_collider().queue_free()
				if one_hp <4:
					one_hp += 1
					hp_changed.emit()
			elif collision.get_collider().get("heal") == false:
				$FlyCharacter/BodyAnim.play("hurt")
				$FlyCharacter/AnimationPlayer.play("hurt")
				$FlyCharacter/HurtTimer.start(1)
				one_hp -= 1
				hp_changed.emit()
				if one_hp <= 0:
					gameover.emit()
	collision = app.move_and_collide(app.velocity*delta)
	if collision and !$FlyCharacter2/AnimationPlayer.is_playing():
		if collision.get_collider().get("heal") == true:
			collision.get_collider().queue_free()
			if app_hp <4:
				app_hp += 1
				hp_changed.emit()
		elif collision.get_collider().get("heal") == false:
			if collision.get_collider().has_method("apply_central_impulse"):
				collision.get_collider().apply_central_impulse(-collision.get_normal()*200)
			$FlyCharacter2/BodyAnim.play("hurt")
			$FlyCharacter2/AnimationPlayer.play("hurt")
			$FlyCharacter2/HurtTimer.start(1)
			app_hp -= 1
			app_hurting = true
			var tween = get_tree().create_tween()
			tween.tween_property(app, "position", app_start_pos, 2)
			tween.tween_callback(app_restart)
			hp_changed.emit()
			if app_hp <= 0:
				gameover.emit()
		adjust_app_speed()
	var moving_pos:Vector2
	moving_pos.x = 400 + sin(-PI/2+(Time.get_ticks_msec()-app_stop_timer) * 0.0001 * app_speed)*400
	moving_pos.y = 500 + sin((Time.get_ticks_msec()-app_stop_timer) * 0.0003 * app_speed)*100
	if app_hurting == false and game_is_over == false:
		app.position = moving_pos

func _on_hurt_timer_timeout() -> void:
	$FlyCharacter/BodyAnim.play("default")

func app_restart():
	app_stop_timer = Time.get_ticks_msec()
	app_hurting = false
	$FlyCharacter2/BodyAnim.play("default")

func _on_timer_timeout() -> void:
	var pos = $Timer/Marker2D.position + Vector2(0,randf_range(-180,180))
	var generate_id = randi_range(0,7)
	generate_barrier(pos,generate_id,randf_range(350,500))
	if generate_id == 0:
		$Timer.start(5)
	else:
		$Timer.start(randf_range(2,3))
	

func generate_barrier(position:Vector2,id,speed):
	var node = load("res://scene/sun/sun3/fly_game/barrier.tscn").instantiate()
	$Barriers.add_child(node)
	node.position = position
	if id == 0:
		node.position.y = -165
	node.speed = speed
	node.rotate_speed = speed/1000
	node.init(id)
		

func adjust_app_speed():
	match app_hp:
		4:
			app_speed = 7
		3:
			app_speed = 8
		2:
			app_speed = 10
		1:
			app_speed = 20


func _on_string_timer_timeout() -> void:
	var pos = $Timer/Marker2D.position + Vector2(0,randf_range(-20,180))
	var generate_id = -1
	generate_barrier(pos,generate_id,randf_range(400,500))
	$Timer/StringTimer.start(randf_range(10,15))

func on_gameover():
	app_hurting = true
	$FlyCharacter.velocity = Vector2(0,0)
	$Timer.stop()
	$Timer/StringTimer.stop()
	$FlyCharacter/CollisionShape2D.queue_free()
	$FlyCharacter2/CollisionShape2D.queue_free()
	game_is_over = true
