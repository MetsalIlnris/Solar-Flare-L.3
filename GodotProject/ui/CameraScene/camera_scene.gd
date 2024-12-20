extends CanvasLayer

@onready var camera_screen = $ScreenContainer/Screen
@onready var confirm_ui = $ConfirmUI

var cur_image:Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerState.confirm_photo.connect(quit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# 捕捉图像
	camera_screen.texture = get_viewport().get_texture()

func init():
	self.show()

func quit():
	self.hide()
	confirm_ui.hide()
	get_parent().opening = false

func _on_shutter_pressed():
	$ScreenContainer/AnimationPlayer.play("Shutter")
	await($ScreenContainer/AnimationPlayer.animation_finished)
	# 保存图像为资源
	var tex = get_viewport().get_texture()
	$ScreenViewport/Screen.set_texture(tex)
	#$ScreenViewport/Screen.scale = camera_screen.scale
	var tex_cuted = $ScreenViewport.get_texture()
	tex_cuted = round_corner(tex_cuted,20)
	cur_image = tex_cuted
	confirm_ui.pop_image(cur_image)



func _on_v_slider_value_changed(value):
	camera_screen.scale = - value/100 * Vector2(0.4,0.4) + Vector2(1,1)

func round_corner(texture:Texture2D,radius:int) -> ImageTexture:
	var new_texture = ImageTexture.new()
	var img = texture.get_image()
	for x in range(img.get_width()):
		for y in range(img.get_height()):
			if(x>radius and x<img.get_width()-radius):
				continue;
			if(y>radius and y<img.get_height()-radius):
				continue;
			#var old_color = img.get_pixel(x,y)
			#var gray = (old_color.r +  old_color.g +  old_color.b)/3
			#var new_color = Color(gray,gray,gray,old_color.a)
			if(check_corner_point(radius,Vector2(x,y),Vector2(img.get_width(),img.get_height()))==false):
				img.set_pixel(x,y,Color(0,0,0,0))
	new_texture = new_texture.create_from_image(img)
	return new_texture

func check_corner_point(radius,pos:Vector2,texture_size:Vector2):
	if (pos.x > radius && pos.x < texture_size.x - radius):
		return true;
	elif(pos.y > radius && pos.y < texture_size.y - radius):
		return true;
	elif(pow(pos.x - radius,2.0) + pow(pos.y - radius,2.0) <= pow(radius, 2.0)):
		return true;
	elif(pow(pos.x - (texture_size.x - radius),2.0) + pow(pos.y - radius,2.0) <= pow(radius, 2.0)):
		return true;
	elif(pow(pos.x - radius,2.0) + pow(pos.y - (texture_size.y - radius),2.0) <= pow(radius, 2.0)):
		return true;
	elif(pow(pos.x - (texture_size.x - radius),2.0) + pow(pos.y - (texture_size.y - radius),2.0) <= pow(radius, 2.0)):
		return true;
	else:
		return false;
