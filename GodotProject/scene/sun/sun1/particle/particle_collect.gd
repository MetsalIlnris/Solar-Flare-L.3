extends CanvasLayer

@onready var tower1 = $GameLayer/Tower1
@onready var tower2 = $GameLayer/Tower2
@onready var tower3 = $GameLayer/Tower3
#@onready var capture_timer = $GameLayer/CaptureTimer
@onready var charactor = $UI/Charactor
@onready var mid = $UI/Mid

var game_mode:int = 1 #1收集粒子2操控收集塔3同时操控
var collect_cnt = 0
var bubble_pos = Vector2(200,600)
var sign_a = 0
var sign_bright_time = 0

signal collect_finish

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerState.show_main_dialogue_balloon("world_dialog/sun","particle_collect_start")
	PlayerState.dialog_action.connect(set_game_mode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if capture_timer.time_left == 0:
		#if sign_bright_time > 0:
			#$GameLayer/Sign.modulate.a = 1
			#sign_bright_time -= 1
		#elif sign_a < 0.5:
			#sign_a += 0.02
	#else:
		#sign_a = capture_timer.time_left/4
	$GameLayer/Sign/BlinkComponent.blink_range = Vector2(0.8 - sign_a,1 - sign_a)
	if tower1.captured!=0 and tower2.captured!=0 and tower3.captured!=0:
		if tower1.in_cursor_area and tower2.in_cursor_area and tower3.in_cursor_area:
		# 此时三个捕捉塔同时收集到了粒子
			collect_success()

func set_game_mode(index:int):
	game_mode = index
	match game_mode:
		1:
			tower1.set_auto(2)
			tower2.set_auto(2)
			tower3.set_auto(2)
		2:
			tower1.set_auto(1)
			tower2.set_auto(1)
			tower3.set_auto(1)
		3:
			tower1.set_auto(0)
			tower2.set_auto(0)
			tower3.set_auto(0)
	PlayerState.dialog_action.disconnect(set_game_mode)


#func _on_capture_timer_timeout():
	#$UI/Tip.hide()
	#if tower1.captured!=0 and tower2.captured!=0 and tower3.captured!=0:
		#collect_success()

func collect_success():
	tower1.collect()
	tower2.collect()
	tower3.collect()
	collect_cnt+=1
	sign_bright_time = 100
	$UI/MainProcess/Label.set_text(str(collect_cnt,"/5"))
	await get_tree().create_timer(1).timeout
	var process_mark = $UI/MainProcess.find_child(str(collect_cnt))
	process_mark.scale = Vector2(2.5,2.5)
	process_mark.modulate = Color(1,1,1,0)
	process_mark.show()
	var tween = get_tree().create_tween()
	tween.tween_property(process_mark, "scale", Vector2(1, 1), 0.5)
	tween.set_parallel()
	tween.tween_property(process_mark, "modulate", Color(1,1,1,1), 0.5) 
	if collect_cnt< 5:
		PlayerState.show_bubble_dialogue_balloon("world_dialog/sun","particle_collect_success",bubble_pos)
	if collect_cnt == 5:
		tower1.stop()
		tower2.stop()
		PlayerState.show_bubble_dialogue_balloon("world_dialog/sun","particle_collect_finish",bubble_pos)
		mid.play("vic")
		charactor.play("vic")
		await get_tree().create_timer(3).timeout
		collect_finish.emit()

func collect_fail():
	PlayerState.show_bubble_dialogue_balloon("world_dialog/sun","particle_collect_fail",bubble_pos)


func _on_help_mouse_entered() -> void:
	$UI/Help/Dialog.show()


func _on_help_mouse_exited() -> void:
	$UI/Help/Dialog.hide()


func _on_timer_timeout() -> void:
	var pos =  Vector2(0,randi_range(-300,300))
	generate_particle($Timer/Marker2D.position + pos)
	$Timer.start(randi_range(1,5))

func generate_particle(position:Vector2):
	var node = load("res://scene/sun/sun1/particle/particle.tscn").instantiate()
	$Particle.add_child(node)
	node.position = position
	#node.init(randi_range(4,11))
	node.init(6)
