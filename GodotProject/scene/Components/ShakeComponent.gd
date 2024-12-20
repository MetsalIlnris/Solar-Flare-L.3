extends Node

@export var amplitude = 10
@export var frequency = 5

var time_passed = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta):
	time_passed += delta
	var offset = sin(time_passed * frequency) * amplitude / 20
	get_parent().position.x += offset
