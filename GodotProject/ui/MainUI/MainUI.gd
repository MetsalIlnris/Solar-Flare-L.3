extends Control

@onready var camera_scene = $CameraScene
@onready var pause_menu = $PauseMenu
@onready var photo_album = $PhotoAlbum
@onready var item_bag = $ItemBag

var opening = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#func on_switch(ui:String):
	#if ui!="camera_scene":
		#camera_scene.quit()
	#if ui!="pause_menu":
		#get_tree().paused = false
		#pause_menu.hide()
	#if ui!="photo_album":
		#photo_album.close()

func switch_camera():
	if camera_scene.visible:
		camera_scene.quit()
	elif opening == false:
		camera_scene.init()
		opening = true

func switch_album():
	if photo_album.visible:
		photo_album.close()
	elif opening == false:
		photo_album.turn_to_page()
		opening = true

func switch_pause_menu():
	if get_tree().paused == true:
		get_tree().paused = false
		pause_menu.hide()
		opening = false
	elif opening == false:
		get_tree().paused = true
		pause_menu.show()
		opening = true

func switch_bag(id = 0):
	if item_bag.visible:
		item_bag.close()
	elif opening == false:
		item_bag.init(id)
		opening = true
