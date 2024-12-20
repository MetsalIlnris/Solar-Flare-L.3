extends Node2D

@onready var anime = $AnimationPlayer
@onready var location = $LocationLabel
@onready var time = $TimeLabel

var detail_dic = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init(photo_id):
	show()
	anime.play_backwards("dissolve")
	detail_dic = PlayerState.photo_list[photo_id]
	location.set_text(detail_dic["location"])
	time.set_text(detail_dic["time"])
	$Photo/Sample.set_texture(PlayerState.get_img_by_id(photo_id))

func close():
	anime.play("dissolve")
	await(anime.animation_finished)
	hide()


func _on_back_button_pressed():
	close()
