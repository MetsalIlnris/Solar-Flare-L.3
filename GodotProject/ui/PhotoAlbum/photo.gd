extends TextureButton

@onready var timer = $Timer
@onready var photos = %Photos

var grabbing:bool = false
var photo_id

signal grab
signal put
signal enter_slot
signal exit_slot
signal click

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(0.5,0.5)


func _on_button_down():
	timer.start(0.2)

func _on_timer_timeout():
	#确定是长按
	grab.emit(self)
	#scale = Vector2(0.6,0.6)
	grabbing = true
	z_index = 10

func _on_button_up():
	grabbing = false
	z_index = 0
	scale = Vector2(0.5,0.5)
	if(timer.time_left > 0):
		#表明玩家是点击操作
		click.emit(self)
	else:
		put.emit()
	timer.stop()

func move_to(pos:Vector2):
	global_position = pos


func _on_area_2d_area_entered(area):
	if (grabbing == true and area.is_in_group("photo")):
		enter_slot.emit(area.get_parent())


func _on_area_2d_area_exited(area):
	if (grabbing == true and area.is_in_group("photo")):
		exit_slot.emit(area.get_parent)
