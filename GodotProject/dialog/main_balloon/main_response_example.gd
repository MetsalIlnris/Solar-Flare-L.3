extends TextureButton



# Called when the node enters the scene tree for the first time.
func _ready():
	#image.set_texture(texture_normal)
	var bit_map = BitMap.new()
	bit_map.create_from_image_alpha(texture_normal.get_image())
	set_click_mask(bit_map)
	#set_texture_normal(load("res://asset/scene/class_room/kitPaper/characters/none.png"))
	pivot_offset = size/2

func set_text(text:String):
	$Label.set_text(text)

func _on_mouse_entered():
	set_scale(Vector2(1.1,1.1))

func _on_mouse_exited():
	set_scale(Vector2(1,1))

func _on_button_down():
	set_scale(Vector2(0.95,0.95))

func _on_button_up():
	set_scale(Vector2(1.1,1.1))
