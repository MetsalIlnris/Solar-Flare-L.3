extends "res://scene/map_scene.gd"

@onready var yan = $Characters/yan
@onready var one = $"Characters/16180"

func _ready():
	super()
	#Globals.play_bgm("太阳耀斑见")
	#Globals.enter_room_effect()
	one.control()
	yan.follow(one)
	PlayerState.enter_group(yan)
	yan.switch_size(0.6)
	one.switch_size(0.6)
	$Characters/Wahser.wash()
	$Characters/Wahser.switch_size(0.5)
	$Characters/Wahser.activate_start.connect(on_activate)
	change_camera($Camera/Main,0)
	activater.gameover.connect(on_repair_gameover)

func _unhandled_key_input(event):
	super(event)

func on_repair_gameover(success:bool):
	if success:
		pass
	else:
		pass
