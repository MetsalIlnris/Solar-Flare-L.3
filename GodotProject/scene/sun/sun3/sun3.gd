extends "res://scene/map_scene.gd"

@onready var yan = $Characters/yan
@onready var one = $"Characters/16180"
@onready var ball = $RoomLayer/Ball
@onready var room_closet = $RoomLayer/Base/Closet
@onready var room_table = $RoomLayer/Base/Table
@onready var room_door = $RoomLayer/Base/Door
@onready var light_switcher = $RoomLayer/Hall/Switch

var research_room = [[0,0,0],[0,0,0],[0,0,0]]#closet(0-4)table(0-3)door(0-2)

func _ready():
	super()
	#Globals.play_bgm("太阳耀斑见")
	#Globals.enter_room_effect()
	one.control()
	$Characters/Washer.wander()
	yan.follow(one)
	PlayerState.enter_group(yan)
	yan.switch_size(0.6)
	one.switch_size(0.6)
	$Characters/Washer.switch_size(0.5)
	$Characters/Washer.activate_start.connect(on_activate)
	change_camera($Camera/Main,0)
	randomize()
	for i in range(3):
		research_room[i][0] = randi() % 4 + 1
		research_room[i][1] = randi() % 3 + 1
		research_room[i][2] = randi() % 3

func _unhandled_key_input(event):
	super(event)

func sun3_room0():
	$Areas/RoomOut/Marker2D.position.x = 22
	if light_switcher.light_state[0] == false:
		$RoomLayer/Base/DarkMask.show()
		$PlayerBoundary/CollisionPolygon2D5.position.x = 2400
		PlayerState.show_main_dialogue_balloon("world_dialog/sun3","room_dark")
		return
	$RoomLayer/Base/DarkMask.hide()
	$PlayerBoundary/CollisionPolygon2D5.position.x = -143
	var i = 1
	for sp in room_closet.get_children():
		if i == research_room[0][0]:
			sp.show()
		else:
			sp.hide()
		i += 1
	i = 1
	for sp in room_table.get_children():
		if i == research_room[0][1]:
			sp.show()
		else:
			sp.hide()
		i += 1
	i = 1
	for sp in room_door.get_children():
		if i == research_room[0][2]:
			sp.show()
		else:
			sp.hide()
		i += 1

func sun3_room1():
	$Areas/RoomOut/Marker2D.position.x = 760
	if light_switcher.light_state[1] == false:
		$RoomLayer/Base/DarkMask.show()
		$PlayerBoundary/CollisionPolygon2D5.position.x = 2400
		PlayerState.show_main_dialogue_balloon("world_dialog/sun3","room_dark")
		return
	$RoomLayer/Base/DarkMask.hide()
	$PlayerBoundary/CollisionPolygon2D5.position.x = -143
	var i = 1
	for sp in room_closet.get_children():
		if i == research_room[1][0]:
			sp.show()
		else:
			sp.hide()
		i += 1
	i = 1
	for sp in room_table.get_children():
		if i == research_room[1][1]:
			sp.show()
		else:
			sp.hide()
		i += 1
	i = 1
	for sp in room_door.get_children():
		if i == research_room[1][2]:
			sp.show()
		else:
			sp.hide()
		i += 1

func sun3_room2():
	$Areas/RoomOut/Marker2D.position.x = 1450
	if light_switcher.light_state[2] == false:
		$RoomLayer/Base/DarkMask.show()
		$PlayerBoundary/CollisionPolygon2D5.position.x = 2400
		PlayerState.show_main_dialogue_balloon("world_dialog/sun3","room_dark")
		return
	$RoomLayer/Base/DarkMask.hide()
	$PlayerBoundary/CollisionPolygon2D5.position.x = -143
	var i = 1
	for sp in room_closet.get_children():
		if i == research_room[2][0]:
			sp.show()
		else:
			sp.hide()
		i += 1
	i = 1
	for sp in room_table.get_children():
		if i == research_room[2][1]:
			sp.show()
		else:
			sp.hide()
		i += 1
	i = 1
	for sp in room_door.get_children():
		if i == research_room[2][2]:
			sp.show()
		else:
			sp.hide()
		i += 1

func sun3_light_switch():
	light_switcher.display()
