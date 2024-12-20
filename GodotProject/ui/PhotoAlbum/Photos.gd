extends Node2D

var grabbing_photo
var switching_photo

var album:CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	album = get_parent().get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if grabbing_photo!=null:
		grabbing_photo.global_position = get_global_mouse_position()-Vector2(220,155)

func grab_photo(photo:TextureButton):
	album.grabbing_photo_id = photo.photo_id
	grabbing_photo = photo
	grabbing_photo.name = "grabbing_photo"
	switching_photo = null
	grabbing_photo.enter_slot.connect(_on_grab_photo_enter_slot)
	grabbing_photo.exit_slot.connect(_on_grab_photo_exit_slot)

func put_photo():
	if switching_photo:
		PlayerState.switch_photo_pos(grabbing_photo.photo_id,switching_photo.photo_id)
	grabbing_photo.queue_free()
	switching_photo = null
	album.grabbing_photo_id = -1
	album.turn_to_page(album.cur_page)

func _on_grab_photo_enter_slot(photo):
	switching_photo = photo
	if(switching_photo):
		pass

func _on_grab_photo_exit_slot(photo):
	switching_photo = null

#func _find_photo_in_slot(slot:Area2D) -> TextureButton:
	#for node in slot.get_children():
		#if node.is_in_group("photo"):
			#return node
	#return null


func _on_left_area_entered(area):
	if(area.is_in_group("photo")):
		$DragAreas/Left/DragLeftTimer.start(1)

func _on_left_area_exited(area):
	if(area.is_in_group("photo")):
		$DragAreas/Left/DragLeftTimer.stop()

func _on_drag_left_timer_timeout():
	album.page_down()


func _on_right_area_entered(area):
	if(area.is_in_group("photo")):
		$DragAreas/Right/DragRightTimer.start(1)


func _on_right_area_exited(area):
	if(area.is_in_group("photo")):
		$DragAreas/Right/DragRightTimer.stop()


func _on_drag_right_timer_timeout():
	album.page_up()
