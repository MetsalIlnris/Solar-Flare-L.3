extends "res://scene/map_scene.gd"

@onready var yan = $Characters/yan
@onready var one = $"Characters/16180"

# Called when the node enters the scene tree for the first time.
func _ready():
	one.control()
	yan.move_to($InteractArea.global_position,110)
	yan.wait(one)
	yan.switch_size(0.8)
	one.switch_size(0.8)
	#camera_bound = Vector2(200,2260)


func _unhandled_key_input(event):
	super(event)
