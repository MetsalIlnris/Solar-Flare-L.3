extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_mouse_entered():
	set_scale(Vector2(1.05,1.05))


func _on_mouse_exited():
	set_scale(Vector2(1,1))


func _on_button_down():
	set_scale(Vector2(0.98,0.98))


func _on_button_up():
	set_scale(Vector2(1.1,1.1))
