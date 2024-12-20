extends Node2D

var rubbish_id = 0
var clean_time = 4

var cleaning:bool = false

signal clean_finish

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rubbish_id = randi_range(0,6)
	for im in $Image.get_children():
		im.hide()
	$Image.get_child(rubbish_id).show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func clean() -> float:
	if cleaning == false:
		cleaning = true
		$Timer.start(clean_time)
	return clean_time


func rubbish_check():
	PlayerState.show_main_dialogue_balloon("world_dialog/washer","rubbish_" + $Image.get_child(rubbish_id).get_name())


func _on_timer_timeout() -> void:
	clean_finish.emit()
	queue_free()
