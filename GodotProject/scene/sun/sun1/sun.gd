extends "res://scene/map_scene.gd"

@onready var yan = $Characters/yan
@onready var one = $"Characters/16180"
@onready var ball = $RoomLayer/Ball

func _ready():
	super()
	#Globals.play_bgm("太阳耀斑见")
	#Globals.enter_room_effect()
	one.control()
	#yan.move_to($Areas/InteractArea.position,110)
	yan.follow(one)
	#yan.wait(one)
	PlayerState.enter_group(yan)
	#camera_bound = Vector2(-20,5160)
	#camera_bound = Vector2(0,2070)
	yan.switch_size(0.6)
	one.switch_size(0.6)
	#yan.switch_outfit(2)
	#one.switch_outfit(2)
	change_camera($Camera/Main,0)

func _unhandled_key_input(event):
	super(event)

func sun_station_mid():
	change_camera($Camera/StationRoomCamera,1)
	await(PlayerState.dialog_finish)
	change_camera($Camera/StationCamera)

func sun_first():
	Globals.play_bgm("太阳耀斑见")
	await(PlayerState.dialog_finish)
	yan.move_to(Vector2(4933,800),110)

func sun_ball_saw():
	await(PlayerState.dialog_action)
	$Camera/BallCamera.set_zoom(Vector2(0.8,0.8))
	change_camera($Camera/BallCamera)
	await(PlayerState.dialog_finish)
	await get_tree().create_timer(2).timeout
	PlayerState.show_main_dialogue_balloon("world_dialog/sun","ball_saw2")
	await(PlayerState.dialog_finish)
	change_camera($Camera/TowerCamera)
	yan.move_to(Vector2(1300,-5600),110)

func sun_ball():
	await(PlayerState.dialog_finish)
	ball.move_to(Vector2(1166,-5682))

func sun_ball_enter():
	yan.follow(one)
	$Camera/BallCamera.set_follow_offset(Vector2(-50,-50))
	$Camera/BallCamera.set_zoom(Vector2(1.3,1.3))
	change_camera($Camera/BallCamera)
	await(PlayerState.dialog_finish)
	one.uncontrol()
	camera.fade_in()
	await(camera.fade_finish)
	$Camera/BallCamera.set_zoom(Vector2(1,1))
	var game = load("res://scene/sun/sun1/particle/particle_collect.tscn").instantiate()
	add_child(game)
	camera.fade_out()
	await(game.collect_finish)
	camera.fade_in()
	change_camera($Camera/TowerCamera)
	await(camera.fade_finish)
	game.queue_free()
	one.control()
	main_ui.switch_bag(2)
	camera.fade_out()

func sun_chain_eye():
	$RoomLayer/ChainStation/eye.play("look")

func sun_chain_down():
	SceneChanger.change_scene("res://scene/sun/sun2/sun2.tscn")
