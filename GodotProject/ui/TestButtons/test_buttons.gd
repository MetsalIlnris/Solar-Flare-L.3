extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hide_button_pressed():
	self.hide()


func _on_save_button_pressed():
	PlayerState.save_game()


func _on_load_button_pressed():
	PlayerState.load_game()
