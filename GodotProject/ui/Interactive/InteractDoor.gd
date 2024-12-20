extends "res://ui/Interactive/InteractArea.gd"

@onready var timer = $Timer

@export var change_camera:PhantomCamera2D
@export var transfer_fade:bool = false
@export var transfer_duration:float = 0
@export var change_size:float = -1
@export var change_bgm:String
@export var change_bgm_effect:effect_enum

enum effect_enum{
	none,
	enter_room,
	out_room
}

func interact():
	if dialog and scene and label:
		PlayerState.show_main_dialogue_balloon("world_dialog/"+scene,label)
		PlayerState.door_transfer.connect(transfer)
	else:
		transfer(true)
	if one_shot:
		queue_free()

func transfer(transfer_or_not:bool):
	if(transfer_or_not == false):
		return
	var camera = get_tree().current_scene.get_node("%MainCamera")
	if(transfer_fade == true):
		camera.fade_in()
		await(camera.fade_finish)
	var objects = PlayerState.group
	var object_move_offset = 0
	for object in objects:
		if change_size!=-1:
			object.switch_size(change_size)
		object.position = $Marker2D.global_position 
		object.position.x -= object_move_offset
		object_move_offset += 50
		object.on_door_transfer()
	if change_camera:
		get_tree().current_scene.change_camera(change_camera,transfer_duration)
	match change_bgm_effect:
		effect_enum.enter_room:
			Globals.enter_room_effect()
		effect_enum.out_room:
			Globals.out_room_effect()
	if(transfer_fade == true):
		timer.start(transfer_duration)
		await(timer.timeout)
		camera.fade_out()
	if scene_func and scene and label:
		get_tree().current_scene.call(str(scene,'_',label))
