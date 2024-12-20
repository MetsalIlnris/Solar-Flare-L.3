extends "res://scene/map_scene.gd"

@onready var yan = $Characters/yan
@onready var one = $"Characters/16180"
@onready var ball = $RoomLayer/Ball

func _ready():
	Globals.play_bgm("太阳耀斑见")
	Globals.enter_room_effect()
	one.control()
	yan.follow(one)
	PlayerState.enter_group(yan)
	yan.switch_size(0.6)
	one.switch_size(0.6)
	change_camera($Camera/Main,0)

func _unhandled_key_input(event):
	super(event)
