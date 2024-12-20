extends Node


func _ready():
	load_game()

###############################
#                             #
#           操作               #
#                             #
###############################

var can_run:bool = true
var can_action = true
var can_move_left = true
var can_move_right = true
var inputLock = 1

var yan_grabbing = false

func yan_grab_release():
	if yan_grabbing == false:
		return
	await(get_tree().create_timer(2).timeout)
	yan_grabbing = false

func allow_input():
	inputLock += 1

func ban_input():
	inputLock -= 1

func can_input() ->bool:
	return inputLock > 0

func reset_input_lock():
	inputLock = 1

var light_on:bool = true

func switch_light():
	if light_on == true:
		light_on = false
		RenderingServer.global_shader_parameter_set("light_on",false) 
	else:
		light_on = true
		RenderingServer.global_shader_parameter_set("light_on",true) 

###############################
#                             #
#       团队&交互区域           #
#                             #
###############################

signal group_change

var group = []
var cur_interact_body
var cur_interact_area:Area2D

func set_interact_area(area:Area2D):
	if cur_interact_area and cur_interact_area!= area:
		cur_interact_area.hide_tip()
	cur_interact_area = area
	cur_interact_area.show_tip()

func exit_interact_area(area:Area2D):
	if(area == cur_interact_area):
		cur_interact_area.hide_tip()
		cur_interact_area = null

func enter_group(character):
	group.append(character)
	group_change.emit()

func exit_group(character):
	group.erase(character)
	group_change.emit()

func yan_in_group() -> bool:
	for actor:Node in group:
		if actor.is_in_group("yan"):
			return true
	return false

###############################
#                             #
#           存档               #
#                             #
###############################

var cur_save_file_path:String = "res://save/SaveData.res"

func save_game():
	var cur_game_data:GameSaveData = GameSaveData.new()
	cur_game_data.album_list = album_list
	cur_game_data.cur_scene.pack(get_tree().current_scene)
	cur_game_data.album_bg_list = album_bg_list
	cur_game_data.photo_list = photo_list
	cur_game_data.item_list = item_list
	ResourceSaver.save(cur_game_data,cur_save_file_path)

func load_game():
	var cur_game_data:GameSaveData = GameSaveData.new()
	cur_game_data = ResourceLoader.load("res://save/SaveData.res")
	album_list = cur_game_data.album_list
	album_bg_list = cur_game_data.album_bg_list
	photo_list = cur_game_data.photo_list
	item_list = DataLoader.get_data("res://save/default/item_data.CSV")
	for item in item_list:
		item["id"] = item["id"].to_int()
		item["possessed"] = cur_game_data.item_possessed[item["id"]]

func new_game():
	var cur_game_data:GameSaveData = GameSaveData.new()
	cur_game_data = ResourceLoader.load("res://save/SaveData.res")
	album_list = cur_game_data.album_list
	album_bg_list = cur_game_data.album_bg_list
	photo_list = cur_game_data.photo_list
	item_list = DataLoader.get_data("res://save/default/item_data.CSV")
	for item in item_list:
		item["id"] = item["id"].to_int()
		item["possessed"] = cur_game_data.item_possessed[item["possessed"]]

###############################
#                             #
#          相册                #
#                             #
###############################

var photo_list = [] # 按顺序存储每一张相片的详细信息字典
var album_list = [] # 每一页的背景
var album_bg_list = []

signal confirm_photo

func save_img(img:Texture,location:String,discription:String):
	var photo = {}
	photo["id"] = photo_list.size()
	photo["time"] = "4/30"
	photo["image"] = img
	photo["location"] = location
	photo["description"] = discription
	img.get_image().save_png(str("save/photos/photo",photo_list.size(),".png"))
	photo_list.append(photo)

func get_img_by_id(id:int) ->Texture:
	var tex:Texture = photo_list[id]["image"]
	return tex

func get_album_bg_by_page(page:int) ->Texture:
	if album_list.size() <= page:
		album_list.append({"background":"highway"})
	var img = Image.load_from_file("res://asset/UI/photo album/bg/"+album_list[page]["background"]+".png")
	var tex = ImageTexture.create_from_image(img)
	return tex

func switch_photo_pos(grabbing_photo_id:int,switching_photo_id:int):
	# 交换信息
	var temp:Dictionary = photo_list[grabbing_photo_id]
	photo_list[grabbing_photo_id] = photo_list[switching_photo_id]
	photo_list[switching_photo_id] = temp
	photo_list[grabbing_photo_id]["id"] = grabbing_photo_id
	photo_list[switching_photo_id]["id"] = switching_photo_id
###############################
#                             #
#           游戏               #
#                             #
###############################

signal activater_result

###############################
#                             #
#           物品               #
#                             #
###############################
var item_list = []

func add_item(name:String):
	for item in item_list:
		if item["image"] == name:
			item["possessed"] == true

func have_item(name) -> bool:
	for item in item_list:
		if item["image"] == name:
			if item["possessed"] == true:
				return true
			else:
				return false
	return false

###############################
#                             #
#          对话框              #
#                             #
###############################

signal dialog_action(choice:int)
signal story_action
signal dialog_finish
signal door_transfer(transfer_or_not:bool)

func _get_main_balloon_path() -> String:
	var is_small_window: bool = ProjectSettings.get_setting("display/window/size/viewport_width") < 400
	var balloon_path: String = "/dialog/main_balloon/small_main_balloon.tscn" if is_small_window else "/dialog/main_balloon/main_balloon.tscn"
	return get_script().resource_path.get_base_dir() + balloon_path
## Show the mian balloon
func show_main_dialogue_balloon(path: String, title: String = "", extra_game_states: Array = []) -> CanvasLayer:
	var balloon: Node = load("res://dialog/main_balloon/main_balloon.tscn").instantiate()
	get_tree().current_scene.add_child(balloon)
	#禁用键盘输入,dialogue结束时自动allow一次
	ban_input()
	balloon.start(load(str("res://dialog/",path,".dialogue")), title, extra_game_states)
	return balloon

## Show the mian balloon
func show_bubble_dialogue_balloon(path: String, title: String = "", position:Vector2 = Vector2(0,0)) -> CanvasLayer:
	var balloon: Node = load("res://dialog/bubble_balloon/bubble_balloon.tscn").instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.set_offset(position)
	balloon.start(load(str("res://dialog/",path,".dialogue")), title, [])
	return balloon
