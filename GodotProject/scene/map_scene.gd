extends Node2D

# ########################################
# 关于游戏的视图层规则：
# roomlayer处于canvas 1层，z值为零
# BlockLayer和FrontLayer处于canvas 1层，z值为5
# interact物品的交互tip label z值为50
# BackgroundLayer处于canvas -20层
# StoryCanvas处于canvas 35层
# Dialog处于canvas 40层
# Camera curtain处于canvas 45层
# 菜单处于 canvas 50层
# ########################################

@onready var main_ui = $Camera/main_ui
@onready var camera = %MainCamera
@onready var timer = $Timer
@onready var activater = $Camera/Activater
@onready var cur_camera = $Camera/Main

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_camera.set_tween_duration(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	main_ui.position.x = camera.position.x-960
	main_ui.position.y = camera.position.y-540


func _unhandled_key_input(event):
	if event.is_action_pressed("ui_camera"):
		main_ui.switch_camera()
	if event.is_action_pressed("ui_album"):
		main_ui.switch_album()
	if event.is_action_pressed("ui_cancel"):
		main_ui.switch_pause_menu()
	if event.is_action_pressed("ui_bag"):
		main_ui.switch_bag()
	if event.is_action_pressed("ui_up") and PlayerState.can_input():  
		if PlayerState.cur_interact_body and PlayerState.can_action and PlayerState.cur_interact_area:
			PlayerState.cur_interact_area.on_interact_button_pressed()

func change_camera(camera:PhantomCamera2D,dur:float = 1):
	cur_camera.set_priority(0)
	cur_camera = camera
	cur_camera.set_tween_duration(dur)
	cur_camera.set_priority(5)
	await(get_tree().create_timer(2).timeout)
	cur_camera.set_tween_duration(1)

func on_activate(code:Array):
	activater.init_game(code)
