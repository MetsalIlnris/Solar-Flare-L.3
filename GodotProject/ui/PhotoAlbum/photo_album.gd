extends CanvasLayer

@onready var anime = $AnimationPlayer
@onready var photo_example = $Album/Photos/PhotoExample
@onready var back_button = $Album/BackButton
@onready var forward_button = $Album/ForwardButton
@onready var photos = %Photos
@onready var photo_detail = $PhotoDetail
@onready var bg_bar = $BackgroundBar
@onready var background = $Album/Background
@onready var activater = $Camera/Activater

var cur_page = 1
var grabbing_photo_id

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerState.confirm_photo.connect(pop_new_photo)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func turn_to_page(page:int = PlayerState.photo_list.size()/4+1):
	if(page <= 1):
		page = 1
	elif(page >=PlayerState.photo_list.size()/4+1):
		page = PlayerState.photo_list.size()/4+1
	show()
	$Album.show()
	cur_page = page
	if(cur_page==1):
		back_button.hide()
		forward_button.show()
	elif(cur_page == PlayerState.photo_list.size()/4+1):
		forward_button.hide()
		back_button.show()
	else:
		back_button.show()
		forward_button.show()
	construct_page(page)

func close():
	$Album.hide()
	bg_bar.close()
	photo_detail.hide()
	anime.play("dissolve")
	await(anime.animation_finished)
	hide()
	get_parent().opening = false

func construct_page(page:int):
	var photo_dic
	var photo:TextureButton
	var tex:Texture
	var slot
	# 设置相册背景
	background.texture = PlayerState.get_album_bg_by_page(page)
	# 往4个slot中添加照片
	for i in range(4):
		slot = photos.find_child(str("PhotoSlot",i))
		_delete_photo_in_slot(slot)
		if((page-1)*4+i>=PlayerState.photo_list.size()):
			continue
		photo_dic = PlayerState.photo_list[(page-1)*4+i]
		if photo_dic["id"] == grabbing_photo_id:
			continue
		photo = photo_example.duplicate(DUPLICATE_GROUPS | DUPLICATE_SCRIPTS | DUPLICATE_SIGNALS)
		tex = PlayerState.get_img_by_id(photo_dic["id"])
		photo.set_texture_normal(tex)
		slot.add_child(photo)
		photo.set_name("Photo")
		photo.position = Vector2(-190,-135)
		photo.photo_id = photo_dic["id"]
		photo.grab.connect(photos.grab_photo)
		photo.put.connect(photos.put_photo)
		photo.click.connect(on_photo_click)
		photo.show()


func _on_back_button_pressed():
	page_down()

func _on_forward_button_pressed():
	page_up()

func page_up():
	turn_to_page(cur_page+1)

func page_down():
	turn_to_page(cur_page-1)

func _on_close_button_pressed():
	close()

func _delete_photo_in_slot(slot):
	for node in slot.get_children():
		if node.is_in_group("photo") and node.name != "grabbing_photo":
			slot.remove_child(node)
	return null

func on_photo_click(photo):
	photo_detail.init(photo.photo_id)

func pop_new_photo():
	await(turn_to_page())
	photo_detail.init(PlayerState.photo_list.size() - 1)

func _on_bg_button_pressed():
	bg_bar.open(PlayerState.album_list[cur_page]["background"])
