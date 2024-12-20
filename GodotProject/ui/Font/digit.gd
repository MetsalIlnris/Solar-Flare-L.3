extends Node2D

@onready var templates = $Templates
@onready var canvas = $Canvas

var font_spacing = 65
var horizontal_alignment = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate(100)
	$Templates.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate(number:int):
	for node in canvas.get_children():
		node.queue_free()
	var cnt = 0
	var cur_num = 0
	var cur_sprite:Sprite2D
	if number == 0:
		cur_sprite = templates.get_node("0").duplicate()
		canvas.add_child(cur_sprite)
		cur_sprite.show()
		canvas.position.x = font_spacing / 2 
		return
	while number > 0:
		cur_num = number % 10
		number /= 10
		cur_sprite = templates.get_node(str(cur_num)).duplicate()
		canvas.add_child(cur_sprite)
		cur_sprite.position.x = -cnt * font_spacing
		cur_sprite.show()
		cnt += 1
	canvas.position.x = (cnt-1) * font_spacing/2
