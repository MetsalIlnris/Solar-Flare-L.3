extends Node2D

var cur_image:Texture

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func pop_image(im:Texture):
	show()
	cur_image = im
	$Photo/Sample.set_texture(im)
	$AnimationPlayer.play("pop")


func _on_cancel_pressed():
	$AnimationPlayer.play_backwards("pop")
	await($AnimationPlayer.animation_finished)
	hide()


func _on_confirm_pressed():
	PlayerState.save_img(cur_image,"太阳耀斑三号线","太阳耀斑三号线")
	PlayerState.confirm_photo.emit()
	$AnimationPlayer.play_backwards("pop")
	await($AnimationPlayer.animation_finished)
	hide()
