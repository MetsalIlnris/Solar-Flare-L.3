extends Node2D

var spot_id = 0 # 1-4为spot
var bubble_pos = Vector2(200,600)

signal spot_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate(id:int,size:float = 1):
	spot_id = id
	var tar_spot = null
	match id:
		1:
			# spot1
			tar_spot = $"Spots/1"
		2:
			# spot2
			tar_spot = $"Spots/2"
		3:
			# spot3
			tar_spot = $"Spots/3"
		4:
			# spot4
			tar_spot = $"Spots/4"
		5:
			# eye1
			$Eye1.show()
			$Eye2.queue_free()
			$Mouth.queue_free()
			$Spots.queue_free()
			$Other.queue_free()
			$Eye1/Eyeopen.hide()
			$Eye1/Eyeclosed.show()
		6:
			# eye2
			$Eye1.queue_free()
			$Eye2.show()
			$Mouth.queue_free()
			$Spots.queue_free()
			$Other.queue_free()
			$Eye2/Eyeleft.show()
			$Eye2/Eyeright.hide()
		7:
			# hand1
			tar_spot = $Other/Hand1
			
		8:
			# hand2
			tar_spot = $Other/Hand2
		9:
			# ear
			tar_spot = $Other/Ear
		10:
			# mouth
			$Eye1.queue_free()
			$Eye2.queue_free()
			$Mouth.show()
			$Spots.queue_free()
			$Other.queue_free()
			$Mouth/Smile.show()
			$Mouth/Surprised.hide()
		_:
			queue_free()
			
	if tar_spot:
		tar_spot.get_parent().remove_child(tar_spot)
		add_child(tar_spot)
		tar_spot.show()
		$Eye1.queue_free()
		$Eye2.queue_free()
		$Mouth.queue_free()
		$Spots.queue_free()
		$Other.queue_free()
	
	scale = Vector2(size,size)

func _on_button_pressed() -> void:
	match spot_id:
		1:
			# spot1
			spot_pressed.emit()
		2:
			# spot2
			spot_pressed.emit()
		3:
			# spot3
			spot_pressed.emit()
		4:
			# spot4
			spot_pressed.emit()
		5:
			# eye1
			PlayerState.show_bubble_dialogue_balloon("world_dialog/sunspot","eye1",bubble_pos)
			$Eye1/Eyeopen.show()
			$Eye1/Eyeclosed.hide()
			$Timer.start(2)
			await($Timer.timeout)
			$Eye1/Eyeopen.hide()
			$Eye1/Eyeclosed.show()
		6:
			# eye2
			PlayerState.show_bubble_dialogue_balloon("world_dialog/sunspot","eye2",bubble_pos)
			if $Eye2/Eyeleft.visible:
				$Eye2/Eyeleft.hide()
				$Eye2/Eyeright.show()
			else:
				$Eye2/Eyeleft.show()
				$Eye2/Eyeright.hide()
		7:
			# hand1
			PlayerState.show_bubble_dialogue_balloon("world_dialog/sunspot","hand1",bubble_pos)
			
		8:
			# hand2
			PlayerState.show_bubble_dialogue_balloon("world_dialog/sunspot","hand2",bubble_pos)
		9:
			# ear
			PlayerState.show_bubble_dialogue_balloon("world_dialog/sunspot","ear",bubble_pos)
		10:
			# mouth
			PlayerState.show_bubble_dialogue_balloon("world_dialog/sunspot","mouth",bubble_pos)
			$Mouth/Smile.hide()
			$Mouth/Surprised.show()
			$Timer.start(2)
			await($Timer.timeout)
			$Mouth/Smile.show()
			$Mouth/Surprised.hide()
		_:
			queue_free()
	
