extends CanvasLayer

@onready var item_anim = $ItemAnim

var cur_id:int = 0
var possessed_list:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	for item in PlayerState.item_list:
		if item["possessed"] == true:
			possessed_list.append(item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init(id:int = 0):
	PlayerState.ban_input()
	show()
	var cnt = 0
	for item in PlayerState.item_list:
		if item["possessed"] == true:
			possessed_list.append(item)
			cnt += 1
		if item["id"] == id:
			cur_id = cnt - 1
	construct_item()

func close():
	PlayerState.allow_input()
	hide()
	get_parent().opening = false

func construct_item():
	var cur_item = possessed_list[cur_id]
	if cur_item["image"]:
		item_anim.play(cur_item["image"])
	else:
		item_anim.play("default")
	

func _on_detail_button_pressed():
	var cur_item = possessed_list[cur_id]
	PlayerState.show_main_dialogue_balloon("world_dialog/item",cur_item["image"])


func _on_back_button_pressed():
	cur_id -= 1
	if cur_id<0:
		cur_id = possessed_list.size()-1
	construct_item()


func _on_forward_button_pressed():
	cur_id += 1
	if cur_id>=possessed_list.size():
		cur_id = 0
	construct_item()
