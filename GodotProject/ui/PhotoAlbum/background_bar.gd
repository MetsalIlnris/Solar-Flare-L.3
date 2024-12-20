extends Node2D

@onready var scroll:ScrollContainer = $SubViewport/Scroll
@onready var buttons = $SubViewport/Scroll/Buttons
@onready var anime = $AnimationPlayer
@onready var choose_block = $SubViewport/Scroll/Buttons/TextureButton2/ColorRect

var is_dragging = false
var start_pos = 0
var drag_v = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(is_dragging == false and abs(drag_v)>=4):
		scroll.set_h_scroll(scroll.get_h_scroll() + drag_v)
		if (drag_v > 0):
			drag_v -= 5
		else:
			drag_v += 5

func open(cur_album_bg_name:String):
	choose_block.get_parent().remove_child(choose_block)
	for button in buttons.get_children():
		if(button.is_in_group("album_bg")):
			button.queue_free()
	for album_bg in PlayerState.album_bg_list:
		var button = $SubViewport/AlbumBgButtonExample.duplicate(DUPLICATE_GROUPS|DUPLICATE_SCRIPTS|DUPLICATE_SIGNALS)
		var tex = load("res://asset/UI/photo album/bg/icon/"+album_bg["name"]+".png")
		button.set_texture_normal(tex)
		button.show()
		button.add_to_group("album_bg")
		buttons.add_child(button)
		buttons.move_child(button,-2)
		if(album_bg["name"] == cur_album_bg_name):
			button.add_child(choose_block)
	show()
	scroll.set_h_scroll(choose_block.get_parent().get_position().x)
	anime.play("open")

func close():
	anime.play_backwards("open")
	await(anime.animation_finished)
	hide()

func _on_drag_gui_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		is_dragging = true
		start_pos = event.position.x
	
	if event is InputEventMouseButton and !event.is_pressed():
		is_dragging = false
		start_pos = 0
	
	if is_dragging:
		drag_v = start_pos - event.position.x
		scroll.set_h_scroll(scroll.get_h_scroll() + drag_v)
		start_pos = event.position.x


func _on_close_button_pressed():
	close()
